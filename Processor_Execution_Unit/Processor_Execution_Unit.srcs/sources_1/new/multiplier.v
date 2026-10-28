module multiplier (
    input clk,
    input reset,
    input start,

    input [31:0] A,
    input [31:0] B,

    output reg [63:0] product,
    output reg        done,
    output reg        busy
);

    reg [63:0] multiplicand;
    reg [31:0] multiplier_reg;
    reg [63:0] accumulator;
    reg [5:0]  count;

    reg        result_negative;

    always @(posedge clk or posedge reset) begin

        if (reset) begin
            multiplicand   <= 64'b0;
            multiplier_reg <= 32'b0;
            accumulator    <= 64'b0;
            product        <= 64'b0;
            count          <= 6'b0;
            done           <= 1'b0;
            busy           <= 1'b0;
            result_negative <= 1'b0;
        end

        else begin

            done <= 1'b0;

            if (start && !busy) begin

                // Store absolute values
                if (A[31])
                    multiplicand <= {32'b0, (~A + 1'b1)};
                else
                    multiplicand <= {32'b0, A};

                if (B[31])
                    multiplier_reg <= (~B + 1'b1);
                else
                    multiplier_reg <= B;

                accumulator <= 64'b0;
                count <= 6'b0;

                // Result sign = A sign XOR B sign
                result_negative <= A[31] ^ B[31];

                busy <= 1'b1;

            end

            else if (busy) begin

                if (multiplier_reg[0])
                    accumulator <= accumulator + multiplicand;

                multiplicand <= multiplicand << 1;
                multiplier_reg <= multiplier_reg >> 1;

                if (count == 6'd31) begin

                    if (multiplier_reg[0]) begin

                        if (result_negative)
                            product <= -(accumulator + multiplicand);
                        else
                            product <= accumulator + multiplicand;

                    end
                    else begin

                        if (result_negative)
                            product <= -accumulator;
                        else
                            product <= accumulator;

                    end

                    busy <= 1'b0;
                    done <= 1'b1;

                end

                else begin
                    count <= count + 1'b1;
                end

            end

        end

    end

endmodule