module tb;

    reg clk, reset, enable;
    wire [2:0] Q;

    counter uut (
        .clk(clk),
        .reset(reset),
        .enable(enable),
        .Q(Q)
    );

    initial begin
        $dumpfile("counter.vcd");
        $dumpvars(0, tb);

        clk = 0;
        reset = 1;
        enable = 0;

        #10 reset = 0;
        enable = 1;

        #100 enable = 0;
        #30 enable = 1;

        #50 $finish;
    end

    always #5 clk = ~clk;

endmodule