module divider (
    input clk,
    input reset,
    input start,

    input [31:0] A,
    input [31:0] B,

    output reg [31:0] quotient,
    output reg [31:0] remainder,
    output reg        done,
    output reg        busy,
    output reg        divide_by_zero
);

    reg [31:0] dividend_reg;
    reg [31:0] divisor_reg;
    reg [32:0] remainder_reg;
    reg [31:0] quotient_reg;

    reg [5:0] count;

    reg quotient_negative;
    reg remainder_negative;

    reg [32:0] shifted_remainder;
    reg [31:0] next_quotient;
    reg [31:0] final_quotient;
    reg [32:0] final_remainder;

    always @(posedge clk or posedge reset) begin

        if (reset) begin
            dividend_reg     <= 32'b0;
            divisor_reg      <= 32'b0;
            remainder_reg    <= 33'b0;
            quotient_reg     <= 32'b0;

            quotient         <= 32'b0;
            remainder        <= 32'b0;

            count             <= 6'b0;
            done              <= 1'b0;
            busy              <= 1'b0;
            divide_by_zero    <= 1'b0;

            quotient_negative <= 1'b0;
            remainder_negative <= 1'b0;
        end

        else begin

            done <= 1'b0;

            // Start division
            if (start && !busy) begin

                divide_by_zero <= 1'b0;

                // Divide by zero
                if (B == 32'b0) begin

                    quotient      <= 32'hFFFFFFFF;
                    remainder     <= A;
                    divide_by_zero <= 1'b1;
                    done          <= 1'b1;
                    busy          <= 1'b0;

                end

                else begin

                    // Absolute value of A
                    if (A[31])
                        dividend_reg <= (~A) + 1'b1;
                    else
                        dividend_reg <= A;

                    // Absolute value of B
                    if (B[31])
                        divisor_reg <= (~B) + 1'b1;
                    else
                        divisor_reg <= B;

                    remainder_reg <= 33'b0;
                    quotient_reg  <= 32'b0;
                    count         <= 6'b0;

                    // Determine signs
                    quotient_negative <= A[31] ^ B[31];
                    remainder_negative <= A[31];

                    busy <= 1'b1;

                end

            end

            // Perform one division step
            else if (busy) begin

                // Shift next dividend bit into remainder
                shifted_remainder =
                    {remainder_reg[31:0], dividend_reg[31]};

                // Shift dividend
                dividend_reg <= dividend_reg << 1;

                // Compare and subtract
                if (shifted_remainder >= {1'b0, divisor_reg}) begin

                    remainder_reg <=
                        shifted_remainder - {1'b0, divisor_reg};

                    next_quotient =
                        {quotient_reg[30:0], 1'b1};

                end

                else begin

                    remainder_reg <= shifted_remainder;

                    next_quotient =
                        {quotient_reg[30:0], 1'b0};

                end

                quotient_reg <= next_quotient;

                // Last iteration
                if (count == 6'd31) begin

                    final_quotient = next_quotient;

                    if (shifted_remainder >= {1'b0, divisor_reg})
                        final_remainder =
                            shifted_remainder - {1'b0, divisor_reg};
                    else
                        final_remainder =
                            shifted_remainder;

                    // Apply quotient sign
                    if (quotient_negative)
                        quotient <= (~final_quotient) + 1'b1;
                    else
                        quotient <= final_quotient;

                    // Apply remainder sign
                    if (remainder_negative)
                        remainder <= (~final_remainder[31:0]) + 1'b1;
                    else
                        remainder <= final_remainder[31:0];

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