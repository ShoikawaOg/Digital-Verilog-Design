module instruction_memory (
    input  wire [31:0] address,
    output reg  [31:0] instruction
);

    always @(*) begin

        case (address)

            32'd0: begin
                instruction = {
                    6'b000000,
                    5'd1,
                    5'd2,
                    5'd3,
                    11'b0
                };
            end

            32'd4: begin
                instruction = {
                    6'b000001,
                    5'd3,
                    5'd1,
                    5'd4,
                    11'b0
                };
            end

            32'd8: begin
                instruction = {
                    6'b001011,
                    5'd3,
                    5'd4,
                    5'd5,
                    11'b0
                };
            end

            32'd12: begin
                instruction = {
                    6'b001100,
                    5'd5,
                    5'd1,
                    5'd6,
                    11'b0
                };
            end

            32'd16: begin
                instruction = {
                    6'b001101,
                    5'd5,
                    5'd1,
                    5'd7,
                    11'b0
                };
            end

            default: begin
                instruction = 32'b0;
            end

        endcase

    end

endmodule