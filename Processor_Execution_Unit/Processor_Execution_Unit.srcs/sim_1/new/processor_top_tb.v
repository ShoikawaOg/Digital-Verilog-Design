`timescale 1ns / 1ps

module processor_top_tb;

    reg clk;
    reg reset;

    wire [31:0] result;
    wire [31:0] pc;

    wire busy;
    wire done;
    wire error;


    // =====================================================
    // DUT
    // =====================================================

    processor_top uut (
        .clk(clk),
        .reset(reset),

        .result(result),
        .pc(pc),

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

        // Reset
        #20;
        reset = 1'b0;


        // =================================================
        // INITIAL REGISTER VALUES
        // =================================================

        // R1 = 10
        uut.registers.registers[1] = 32'd10;

        // R2 = 5
        uut.registers.registers[2] = 32'd5;


        $display("");
        $display("========================================");
        $display("FULL PROCESSOR TEST");
        $display("========================================");

        $display("Initial R1 = %d",
                 uut.registers.registers[1]);

        $display("Initial R2 = %d",
                 uut.registers.registers[2]);


        // =================================================
        // WAIT FOR PROGRAM
        // =================================================

        #500;


        // =================================================
        // DISPLAY FINAL VALUES
        // =================================================

        $display("");
        $display("FINAL REGISTER VALUES");
        $display("----------------------------------------");

        $display("R1 = %d",
                 uut.registers.registers[1]);

        $display("R2 = %d",
                 uut.registers.registers[2]);

        $display("R3 = %d",
                 uut.registers.registers[3]);

        $display("R4 = %d",
                 uut.registers.registers[4]);

        $display("R5 = %d",
                 uut.registers.registers[5]);

        $display("R6 = %d",
                 uut.registers.registers[6]);

        $display("R7 = %d",
                 uut.registers.registers[7]);


        // =================================================
        // CHECK ADD
        // =================================================

        if (uut.registers.registers[3] == 32'd15)
            $display("PASS: ADD R3 = 15");
        else
            $display("FAIL: ADD R3 = %d",
                     uut.registers.registers[3]);


        // =================================================
        // CHECK SUB
        // =================================================

        if (uut.registers.registers[4] == 32'd5)
            $display("PASS: SUB R4 = 5");
        else
            $display("FAIL: SUB R4 = %d",
                     uut.registers.registers[4]);


        // =================================================
        // CHECK MUL
        // =================================================

        if (uut.registers.registers[5] == 32'd75)
            $display("PASS: MUL R5 = 75");
        else
            $display("FAIL: MUL R5 = %d",
                     uut.registers.registers[5]);


        // =================================================
        // CHECK DIV
        // =================================================

        if (uut.registers.registers[6] == 32'd7)
            $display("PASS: DIV R6 = 7");
        else
            $display("FAIL: DIV R6 = %d",
                     uut.registers.registers[6]);


        // =================================================
        // CHECK REM
        // =================================================

        if (uut.registers.registers[7] == 32'd0)
            $display("PASS: REM R7 = 0");
        else
            $display("FAIL: REM R7 = %d",
                     uut.registers.registers[7]);


        // =================================================
        // ERROR CHECK
        // =================================================

        if (error == 1'b0)
            $display("PASS: NO PROCESSOR ERROR");
        else
            $display("FAIL: PROCESSOR ERROR");


        // =================================================
        // COMPLETE
        // =================================================

        $display("");
        $display("========================================");
        $display("FULL PROCESSOR TEST COMPLETE");
        $display("========================================");

        $finish;

    end

endmodule