`timescale 1ns / 1ps

module divider_tb;

    reg clk;
    reg reset;
    reg start;

    reg [31:0] A;
    reg [31:0] B;

    wire [31:0] quotient;
    wire [31:0] remainder;
    wire        done;
    wire        busy;
    wire        divide_by_zero;

    divider uut (
        .clk(clk),
        .reset(reset),
        .start(start),
        .A(A),
        .B(B),
        .quotient(quotient),
        .remainder(remainder),
        .done(done),
        .busy(busy),
        .divide_by_zero(divide_by_zero)
    );

    always #5 clk = ~clk;

    initial begin

        clk   = 0;
        reset = 1;
        start = 0;
        A     = 0;
        B     = 0;

        // Reset
        #20;
        reset = 0;

        // 1. 15 / 3 = 5, remainder 0
        A = 15;
        B = 3;
        start = 1;

        #10;
        start = 0;

        wait(done);
        #10;

        // 2. 17 / 5 = 3, remainder 2
        A = 17;
        B = 5;
        start = 1;

        #10;
        start = 0;

        wait(done);
        #10;

        // 3. -15 / 3 = -5
        A = -15;
        B = 3;
        start = 1;

        #10;
        start = 0;

        wait(done);
        #10;

        // 4. -17 / 5 = -3, remainder -2
        A = -17;
        B = 5;
        start = 1;

        #10;
        start = 0;

        wait(done);
        #10;

        // 5. -17 / -5 = 3, remainder -2
        A = -17;
        B = -5;
        start = 1;

        #10;
        start = 0;

        wait(done);
        #10;

        // 6. Divide by zero
        A = 25;
        B = 0;
        start = 1;

        #10;
        start = 0;

        wait(done);
        #10;

        $finish;

    end

endmodule