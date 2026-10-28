`timescale 1ns / 1ps

module xor_gate_tb;

    reg A;
    reg B;
    wire Y;

    // Instantiate the Unit Under Test (UUT)
    xor_gate uut (
        .A(A),
        .B(B),
        .Y(Y)
    );

    initial begin
        $display("Time\tA B | Y");
        $monitor("%0t\t%b %b | %b", $time, A, B, Y);

        A = 0; B = 0; #10;
        A = 0; B = 1; #10;
        A = 1; B = 0; #10;
        A = 1; B = 1; #10;

        $finish;
    end

endmodule