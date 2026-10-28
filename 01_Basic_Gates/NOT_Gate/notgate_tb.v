`timescale 1ns / 1ps

module not_gate_tb;

    reg A;
    wire Y;

    // Instantiate the Unit Under Test (UUT)
    not_gate uut (
        .A(A),
        .Y(Y)
    );

    initial begin
        $display("Time\tA | Y");
        $monitor("%0t\t%b | %b", $time, A, Y);

        A = 0; #10;
        A = 1; #10;

        $finish;
    end

endmodule