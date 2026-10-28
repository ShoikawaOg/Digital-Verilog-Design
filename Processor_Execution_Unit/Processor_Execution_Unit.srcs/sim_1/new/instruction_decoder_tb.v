`timescale 1ns / 1ps

module instruction_decoder_tb;

    reg [31:0] instruction;

    wire [5:0] opcode;
    wire [4:0] rs1;
    wire [4:0] rs2;
    wire [4:0] rd;

    wire [3:0] alu_opcode;

    wire valid;
    wire uses_rs1;
    wire uses_rs2;
    wire writes_rd;


    instruction_decoder uut (

        .instruction(instruction),

        .opcode(opcode),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),

        .alu_opcode(alu_opcode),

        .valid(valid),
        .uses_rs1(uses_rs1),
        .uses_rs2(uses_rs2),
        .writes_rd(writes_rd)

    );


    initial begin

        // =================================================
        // ADD R3, R1, R2
        // =================================================

        instruction = {
            6'b000000,
            5'd1,
            5'd2,
            5'd3,
            11'b0
        };

        #10;

        if ((opcode == 6'b000000) &&
            (rs1 == 5'd1) &&
            (rs2 == 5'd2) &&
            (rd == 5'd3) &&
            (alu_opcode == 4'b0000) &&
            (valid == 1) &&
            (uses_rs1 == 1) &&
            (uses_rs2 == 1) &&
            (writes_rd == 1))

            $display("PASS: ADD decoder");

        else
            $display("FAIL: ADD decoder");


        // =================================================
        // SUB R5, R3, R4
        // =================================================

        instruction = {
            6'b000001,
            5'd3,
            5'd4,
            5'd5,
            11'b0
        };

        #10;

        if ((alu_opcode == 4'b0001) &&
            (rs1 == 5'd3) &&
            (rs2 == 5'd4) &&
            (rd == 5'd5) &&
            (valid == 1))

            $display("PASS: SUB decoder");

        else
            $display("FAIL: SUB decoder");


        // =================================================
        // MUL R8, R6, R7
        // =================================================

        instruction = {
            6'b001011,
            5'd6,
            5'd7,
            5'd8,
            11'b0
        };

        #10;

        if ((alu_opcode == 4'b1011) &&
            (rs1 == 5'd6) &&
            (rs2 == 5'd7) &&
            (rd == 5'd8) &&
            (valid == 1))

            $display("PASS: MUL decoder");

        else
            $display("FAIL: MUL decoder");


        // =================================================
        // DIV R10, R8, R9
        // =================================================

        instruction = {
            6'b001100,
            5'd8,
            5'd9,
            5'd10,
            11'b0
        };

        #10;

        if ((alu_opcode == 4'b1100) &&
            (rs1 == 5'd8) &&
            (rs2 == 5'd9) &&
            (rd == 5'd10) &&
            (valid == 1))

            $display("PASS: DIV decoder");

        else
            $display("FAIL: DIV decoder");


        // =================================================
        // REM R11, R10, R2
        // =================================================

        instruction = {
            6'b001101,
            5'd10,
            5'd2,
            5'd11,
            11'b0
        };

        #10;

        if ((alu_opcode == 4'b1101) &&
            (rs1 == 5'd10) &&
            (rs2 == 5'd2) &&
            (rd == 5'd11) &&
            (valid == 1))

            $display("PASS: REM decoder");

        else
            $display("FAIL: REM decoder");


        // =================================================
        // NOT R4, R3
        // =================================================

        instruction = {
            6'b000101,
            5'd3,
            5'd0,
            5'd4,
            11'b0
        };

        #10;

        if ((alu_opcode == 4'b0101) &&
            (rs1 == 5'd3) &&
            (uses_rs1 == 1) &&
            (uses_rs2 == 0) &&
            (writes_rd == 1))

            $display("PASS: NOT decoder");

        else
            $display("FAIL: NOT decoder");


        // =================================================
        // INVALID OPCODE
        // =================================================

        instruction = {
            6'b111111,
            5'b0,
            5'b0,
            5'b0,
            11'b0
        };

        #10;

        if ((valid == 0) &&
            (writes_rd == 0))

            $display("PASS: INVALID decoder");

        else
            $display("FAIL: INVALID decoder");


        // =================================================
        // COMPLETE
        // =================================================

        $display("");
        $display("========================================");
        $display("INSTRUCTION DECODER TEST COMPLETE");
        $display("========================================");

        $finish;

    end

endmodule