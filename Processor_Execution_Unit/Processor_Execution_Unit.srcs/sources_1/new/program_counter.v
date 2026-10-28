module program_counter (
    input  wire        clk,
    input  wire        reset,

    input  wire        enable,
    input  wire        branch,
    input  wire [31:0] branch_target,

    output reg  [31:0] pc
);

    always @(posedge clk or posedge reset) begin

        if (reset) begin
            pc <= 32'b0;
        end

        else if (enable) begin

            if (branch)
                pc <= branch_target;

            else
                pc <= pc + 32'd4;

        end

    end

endmodule