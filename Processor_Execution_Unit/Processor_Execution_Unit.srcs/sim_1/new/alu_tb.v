`timescale 1ns / 1ps

module alu_tb;

    reg [31:0] A;
    reg [31:0] B;
    reg [3:0]  opcode;

    wire [31:0] result;
    wire        zero;
    wire        negative;
    wire        carry;
    wire        overflow;

    alu uut (
        .A(A),
        .B(B),
        .opcode(opcode),
        .result(result),
        .zero(zero),
        .negative(negative),
        .carry(carry),
        .overflow(overflow)
    );

    initial begin

        // ADD
        A = 10;
        B = 5;
        opcode = 4'b0000;
        #10;

        // SUB
        A = 10;
        B = 5;
        opcode = 4'b0001;
        #10;

        // AND
        A = 32'hF0F0F0F0;
        B = 32'h0F0F0F0F;
        opcode = 4'b0010;
        #10;

        // OR
        A = 32'hF0F0F0F0;
        B = 32'h0F0F0F0F;
        opcode = 4'b0011;
        #10;

        // XOR
        A = 32'hAAAAAAAA;
        B = 32'h55555555;
        opcode = 4'b0100;
        #10;

        // NOT
        A = 32'hAAAAAAAA;
        B = 0;
        opcode = 4'b0101;
        #10;

        // SHIFT LEFT
        A = 1;
        B = 4;
        opcode = 4'b0110;
        #10;

        // SHIFT RIGHT
        A = 32;
        B = 2;
        opcode = 4'b0111;
        #10;

        // ARITHMETIC SHIFT RIGHT
        A = 32'h80000000;
        B = 4;
        opcode = 4'b1000;
        #10;

        // SIGNED LESS THAN
        A = -5;
        B = 3;
        opcode = 4'b1001;
        #10;

        // UNSIGNED LESS THAN
        A = 5;
        B = 10;
        opcode = 4'b1010;
        #10;
        
        // ADD OVERFLOW
A = 32'h7FFFFFFF;
B = 32'h00000001;
opcode = 4'b0000;
#10;

// SUB OVERFLOW
A = 32'h80000000;
B = 32'h00000001;
opcode = 4'b0001;
#10;

// ADD CARRY
A = 32'hFFFFFFFF;
B = 32'h00000001;
opcode = 4'b0000;
#10;

// SUB BORROW
A = 32'h00000000;
B = 32'h00000001;
opcode = 4'b0001;
#10;

        $finish;

    end

endmodule