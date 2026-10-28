`timescale 1ns / 1ps

module register_file_tb;

    reg clk;
    reg reset;

    reg [4:0] read_addr1;
    reg [4:0] read_addr2;

    wire [31:0] read_data1;
    wire [31:0] read_data2;

    reg write_enable;
    reg [4:0] write_addr;
    reg [31:0] write_data;


    register_file uut (
        .clk(clk),
        .reset(reset),

        .read_addr1(read_addr1),
        .read_addr2(read_addr2),

        .read_data1(read_data1),
        .read_data2(read_data2),

        .write_enable(write_enable),
        .write_addr(write_addr),
        .write_data(write_data)
    );


    always #5 clk = ~clk;


    initial begin

        clk = 0;
        reset = 1;

        read_addr1 = 0;
        read_addr2 = 0;

        write_enable = 0;
        write_addr = 0;
        write_data = 0;

        // =================================================
        // RESET
        // =================================================

        #20;
        reset = 0;


        // =================================================
        // TEST 1: WRITE R1 = 100
        // =================================================

        @(negedge clk);

        write_enable = 1;
        write_addr = 5'd1;
        write_data = 32'd100;

        @(posedge clk);

        #1;

        write_enable = 0;

        read_addr1 = 5'd1;

        #1;

        if (read_data1 == 32'd100)
            $display("PASS: R1 = %d", read_data1);
        else
            $display("FAIL: R1 = %d", read_data1);


        // =================================================
        // TEST 2: WRITE R2 = 200
        // =================================================

        @(negedge clk);

        write_enable = 1;
        write_addr = 5'd2;
        write_data = 32'd200;

        @(posedge clk);

        #1;

        write_enable = 0;

        read_addr2 = 5'd2;

        #1;

        if (read_data2 == 32'd200)
            $display("PASS: R2 = %d", read_data2);
        else
            $display("FAIL: R2 = %d", read_data2);


        // =================================================
        // TEST 3: TWO READ PORTS
        // =================================================

        read_addr1 = 5'd1;
        read_addr2 = 5'd2;

        #1;

        if ((read_data1 == 32'd100) &&
            (read_data2 == 32'd200))
            $display("PASS: TWO READ PORTS");
        else
            $display("FAIL: TWO READ PORTS");


        // =================================================
        // TEST 4: R0 MUST ALWAYS BE ZERO
        // =================================================

        @(negedge clk);

        write_enable = 1;
        write_addr = 5'd0;
        write_data = 32'hFFFFFFFF;

        @(posedge clk);

        #1;

        write_enable = 0;

        read_addr1 = 5'd0;

        #1;

        if (read_data1 == 32'b0)
            $display("PASS: R0 ALWAYS ZERO");
        else
            $display("FAIL: R0 = %h", read_data1);


        // =================================================
        // TEST 5: OVERWRITE R1
        // =================================================

        @(negedge clk);

        write_enable = 1;
        write_addr = 5'd1;
        write_data = 32'd500;

        @(posedge clk);

        #1;

        write_enable = 0;

        read_addr1 = 5'd1;

        #1;

        if (read_data1 == 32'd500)
            $display("PASS: R1 OVERWRITE = %d", read_data1);
        else
            $display("FAIL: R1 OVERWRITE = %d", read_data1);


        // =================================================
        // COMPLETE
        // =================================================

        $display("");
        $display("========================================");
        $display("REGISTER FILE TEST COMPLETE");
        $display("========================================");

        $finish;

    end

endmodule