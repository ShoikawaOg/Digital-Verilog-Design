`timescale 1ns / 1ps

module processor_datapath_tb;

    reg clk;
    reg reset;

    wire [31:0] pc;
    wire [31:0] instruction;
    wire [31:0] result;

    wire zero;
    wire negative;
    wire carry;
    wire overflow;

    wire busy;
    wire done;
    wire error;


    // =====================================================
    // DUT
    // =====================================================

    processor_datapath uut (
        .clk(clk),
        .reset(reset),

        .pc(pc),
        .instruction(instruction),
        .result(result),

        .zero(zero),
        .negative(negative),
        .carry(carry),
        .overflow(overflow),

        .busy(busy),
        .done(done),
        .error(error)
    );


    // =====================================================
    // CLOCK
    // =====================================================

    always #5 clk = ~clk;


    // =====================================================
    // TEST
    // =====================================================

    initial begin

        clk   = 1'b0;
        reset = 1'b1;


        // =================================================
        // RESET
        // =================================================

        #20;

        reset = 1'b0;


        // =================================================
        // TEST VALUES
        // R1 = 10
        // R2 = 5
        // =================================================

        uut.registers.registers[1] = 32'd10;
        uut.registers.registers[2] = 32'd5;


        $display("");
        $display("========================================");
        $display("PROCESSOR EXECUTION TEST");
        $display("========================================");

        $display("R1 = %d",
                 uut.registers.registers[1]);

        $display("R2 = %d",
                 uut.registers.registers[2]);


        // =================================================
        // WAIT FOR ADD
        // =================================================

        #10;

        $display("");
        $display("ADD R3, R1, R2");
        $display("Result = %d", result);

        #10;


        // =================================================
        // CHECK R3
        // =================================================

        $display("R3 = %d",
                 uut.registers.registers[3]);


        if (uut.registers.registers[3] == 32'd15)
            $display("PASS: ADD R3 = 15");
        else
            $display("FAIL: ADD R3 = %d",
                     uut.registers.registers[3]);


        // =================================================
        // WAIT FOR SUB
        // =================================================

        #10;

        $display("");
        $display("SUB R4, R3, R1");
        $display("Result = %d", result);

        #10;


        // =================================================
        // CHECK R4
        // =================================================

        $display("R4 = %d",
                 uut.registers.registers[4]);


        if (uut.registers.registers[4] == 32'd5)
            $display("PASS: SUB R4 = 5");
        else
            $display("FAIL: SUB R4 = %d",
                     uut.registers.registers[4]);


        // =================================================
        // FINAL
        // =================================================

        $display("");
        $display("========================================");
        $display("PROCESSOR EXECUTION TEST COMPLETE");
        $display("========================================");

        $finish;

    end

endmodule