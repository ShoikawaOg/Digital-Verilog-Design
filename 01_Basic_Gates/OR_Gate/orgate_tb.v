`timescale 1ns / 1ps

module or_gate_tb;

    reg A;
    reg B;
    wire Y;

    // Instantiate the Unit Under Test (UUT)
    or_gate uut (
        .A(A),
        .B(B),
        .Y(Y)
    );

    initial begin
        $display("Time\tA B | Y");
        $monitor("%0t\t%b %b | %b", $time, A, B, Y);

        // Test Case 1
        A = 0; B = 0;
        #10;

        // Test Case 2
        A = 0; B = 1;
        #10;

        // Test Case 3
        A = 1; B = 0;
        #10;

        // Test Case 4
        A = 1; B = 1;
        #10;

        $finish;
    end

endmodule