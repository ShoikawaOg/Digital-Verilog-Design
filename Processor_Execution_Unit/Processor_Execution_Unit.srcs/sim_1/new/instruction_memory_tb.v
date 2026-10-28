`timescale 1ns / 1ps

module instruction_memory_tb;

    reg [31:0] address;
    wire [31:0] instruction;

    instruction_memory uut (
        .address(address),
        .instruction(instruction)
    );

    initial begin

        address = 32'd0;
        #10;
        $display("Address = %h  Instruction = %h", address, instruction);

        if (instruction[31:26] == 6'b000000)
            $display("PASS: ADD");
        else
            $display("FAIL: ADD");


        address = 32'd4;
        #10;
        $display("Address = %h  Instruction = %h", address, instruction);

        if (instruction[31:26] == 6'b000001)
            $display("PASS: SUB");
        else
            $display("FAIL: SUB");


        address = 32'd8;
        #10;
        $display("Address = %h  Instruction = %h", address, instruction);

        if (instruction[31:26] == 6'b001011)
            $display("PASS: MUL");
        else
            $display("FAIL: MUL");


        address = 32'd12;
        #10;
        $display("Address = %h  Instruction = %h", address, instruction);

        if (instruction[31:26] == 6'b001100)
            $display("PASS: DIV");
        else
            $display("FAIL: DIV");


        address = 32'd16;
        #10;
        $display("Address = %h  Instruction = %h", address, instruction);

        if (instruction[31:26] == 6'b001101)
            $display("PASS: REM");
        else
            $display("FAIL: REM");


        $display("");
        $display("========================================");
        $display("INSTRUCTION MEMORY TEST COMPLETE");
        $display("========================================");

        $finish;

    end

endmodule