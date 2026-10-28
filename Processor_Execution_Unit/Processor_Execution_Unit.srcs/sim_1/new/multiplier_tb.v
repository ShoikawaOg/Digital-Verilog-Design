`timescale 1ns / 1ps

module multiplier_tb;

    reg clk;
    reg reset;
    reg start;

    reg [31:0] A;
    reg [31:0] B;

    wire [63:0] product;
    wire        done;
    wire        busy;

    multiplier uut (
        .clk(clk),
        .reset(reset),
        .start(start),
        .A(A),
        .B(B),
        .product(product),
        .done(done),
        .busy(busy)
    );

    // Clock: 10 ns period
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

        // Test 1: 5 × 3
        A = 5;
        B = 3;
        start = 1;

        #10;
        start = 0;

        // Wait for multiplication to finish
        wait(done);

        #10;

        // Test 2: 15 × 7
        A = 15;
        B = 7;
        start = 1;

        #10;
        start = 0;

        wait(done);

        #10;
        
        // Test 3: -5 × 3
A = -5;
B = 3;
start = 1;
#10;
start = 0;
wait(done);
#10;

// Test 4: -5 × -3
A = -5;
B = -3;
start = 1;
#10;
start = 0;
wait(done);
#10;

        $finish;

    end

endmodule