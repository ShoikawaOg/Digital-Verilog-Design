`timescale 1ns / 1ps

module control_unit_tb;

    reg [5:0] opcode;

    wire reg_write;
    wire alu_start;
    wire mem_read;
    wire mem_write;
    wire branch;
    wire valid;


    control_unit uut (
        .opcode(opcode),

        .reg_write(reg_write),
        .alu_start(alu_start),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .branch(branch),
        .valid(valid)
    );


    task test_alu_opcode;
        input [5:0] op;
        begin

            opcode = op;
            #10;

            if ((reg_write == 1'b1) &&
                (alu_start == 1'b1) &&
                (mem_read == 1'b0) &&
                (mem_write == 1'b0) &&
                (branch == 1'b0) &&
                (valid == 1'b1))

                $display("PASS: opcode %b", op);

            else

                $display("FAIL: opcode %b", op);

        end
    endtask


    initial begin

        // =================================================
        // ALU OPERATIONS
        // =================================================

        test_alu_opcode(6'b000000); // ADD
        test_alu_opcode(6'b000001); // SUB
        test_alu_opcode(6'b000010); // AND
        test_alu_opcode(6'b000011); // OR
        test_alu_opcode(6'b000100); // XOR
        test_alu_opcode(6'b000101); // NOT
        test_alu_opcode(6'b000110); // SLL
        test_alu_opcode(6'b000111); // SRL
        test_alu_opcode(6'b001000); // SRA
        test_alu_opcode(6'b001001); // SLT
        test_alu_opcode(6'b001010); // SLTU
        test_alu_opcode(6'b001011); // MUL
        test_alu_opcode(6'b001100); // DIV
        test_alu_opcode(6'b001101); // REM


        // =================================================
        // INVALID OPCODE
        // =================================================

        opcode = 6'b111111;

        #10;

        if ((reg_write == 1'b0) &&
            (alu_start == 1'b0) &&
            (mem_read == 1'b0) &&
            (mem_write == 1'b0) &&
            (branch == 1'b0) &&
            (valid == 1'b0))

            $display("PASS: INVALID OPCODE");

        else

            $display("FAIL: INVALID OPCODE");


        // =================================================
        // COMPLETE
        // =================================================

        $display("");
        $display("========================================");
        $display("CONTROL UNIT TEST COMPLETE");
        $display("========================================");

        $finish;

    end

endmodule