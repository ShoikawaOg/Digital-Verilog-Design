`timescale 1ns / 1ps

module program_counter_tb;

    reg clk;
    reg reset;

    reg enable;
    reg branch;
    reg [31:0] branch_target;

    wire [31:0] pc;


    // =====================================================
    // DUT
    // =====================================================

    program_counter uut (
        .clk(clk),
        .reset(reset),

        .enable(enable),
        .branch(branch),
        .branch_target(branch_target),

        .pc(pc)
    );


    // =====================================================
    // CLOCK
    // =====================================================

    always #5 clk = ~clk;


    // =====================================================
    // TESTS
    // =====================================================

    initial begin

        clk = 1'b0;
        reset = 1'b1;

        enable = 1'b0;
        branch = 1'b0;
        branch_target = 32'b0;


        // =================================================
        // RESET
        // =================================================

        #20;

        reset = 1'b0;
        #1;

        if (pc == 32'd0)
            $display("PASS: PC RESET = 0");
        else
            $display("FAIL: PC RESET = %d", pc);


        // =================================================
        // PC = 4
        // =================================================

        enable = 1'b1;

        @(posedge clk);
        #1;

        if (pc == 32'd4)
            $display("PASS: PC = 4");
        else
            $display("FAIL: PC = %d", pc);


        // =================================================
        // PC = 8
        // =================================================

        @(posedge clk);
        #1;

        if (pc == 32'd8)
            $display("PASS: PC = 8");
        else
            $display("FAIL: PC = %d", pc);


        // =================================================
        // PC = 12
        // =================================================

        @(posedge clk);
        #1;

        if (pc == 32'd12)
            $display("PASS: PC = 12");
        else
            $display("FAIL: PC = %d", pc);


        // =================================================
        // HOLD PC
        // =================================================

        enable = 1'b0;

        @(posedge clk);
        #1;

        if (pc == 32'd12)
            $display("PASS: PC HOLD");
        else
            $display("FAIL: PC HOLD = %d", pc);


        // =================================================
        // BRANCH TO 100
        // =================================================

        enable = 1'b1;
        branch = 1'b1;
        branch_target = 32'd100;

        @(posedge clk);
        #1;

        if (pc == 32'd100)
            $display("PASS: BRANCH PC = 100");
        else
            $display("FAIL: BRANCH PC = %d", pc);


        // =================================================
        // CONTINUE AFTER BRANCH
        // =================================================

        branch = 1'b0;

        @(posedge clk);
        #1;

        if (pc == 32'd104)
            $display("PASS: PC AFTER BRANCH = 104");
        else
            $display("FAIL: PC AFTER BRANCH = %d", pc);


        // =================================================
        // SECOND BRANCH
        // =================================================

        branch_target = 32'd200;
        branch = 1'b1;

        @(posedge clk);
        #1;

        if (pc == 32'd200)
            $display("PASS: SECOND BRANCH = 200");
        else
            $display("FAIL: SECOND BRANCH = %d", pc);


        // =================================================
        // CONTINUE FROM 200
        // =================================================

        branch = 1'b0;

        @(posedge clk);
        #1;

        if (pc == 32'd204)
            $display("PASS: PC AFTER SECOND BRANCH = 204");
        else
            $display("FAIL: PC AFTER SECOND BRANCH = %d", pc);


        // =================================================
        // COMPLETE
        // =================================================

        $display("");
        $display("========================================");
        $display("PROGRAM COUNTER TEST COMPLETE");
        $display("========================================");

        $finish;

    end

endmodule