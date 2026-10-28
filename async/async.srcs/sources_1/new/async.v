module counter(
    input clk,
    input reset,
    input enable,
    output reg [2:0] Q
);

    always @(posedge clk) begin
        if (reset)
            Q <= 3'b000;
        else if (enable)
            Q <= Q + 1;
    end

endmodule