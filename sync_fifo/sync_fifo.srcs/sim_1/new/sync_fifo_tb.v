`timescale 1ns / 1ps

module sync_fifo_tb;

    parameter DATA_WIDTH = 8;
    parameter DEPTH = 16;

    reg clk;
    reg rst;
    reg wr_en;
    reg rd_en;
    reg [DATA_WIDTH-1:0] data_in;

    wire [DATA_WIDTH-1:0] data_out;
    wire full;
    wire empty;

    // Instantiate FIFO
    sync_fifo #(
        .DATA_WIDTH(DATA_WIDTH),
        .DEPTH(DEPTH)
    ) dut (
        .clk(clk),
        .rst(rst),
        .wr_en(wr_en),
        .rd_en(rd_en),
        .data_in(data_in),
        .data_out(data_out),
        .full(full),
        .empty(empty)
    );

    // Clock generation
    always #5 clk = ~clk;

    // Test sequence
    initial begin

        // Initial values
        clk = 0;
        rst = 1;
        wr_en = 0;
        rd_en = 0;
        data_in = 0;

        // Reset
        #10;
        rst = 0;

        // -------------------------
        // WRITE TEST
        // -------------------------
        $display("Starting WRITE test...");

        repeat (16) begin
            @(posedge clk);
            wr_en = 1;
            data_in = data_in + 1;
        end

        @(posedge clk);
        wr_en = 0;

        #1;

        if (full)
            $display("PASS: FIFO is FULL");
        else
            $display("FAIL: FIFO should be FULL");


        // -------------------------
        // READ TEST
        // -------------------------
        $display("Starting READ test...");

        repeat (16) begin
            @(posedge clk);
            rd_en = 1;
        end

        @(posedge clk);
        rd_en = 0;

        #1;

        if (empty)
            $display("PASS: FIFO is EMPTY");
        else
            $display("FAIL: FIFO should be EMPTY");


        // -------------------------
        // SIMULTANEOUS READ/WRITE
        // -------------------------
        $display("Starting simultaneous READ/WRITE test...");

        @(posedge clk);
        wr_en = 1;
        rd_en = 0;
        data_in = 8'hAA;

        @(posedge clk);
        wr_en = 1;
        rd_en = 1;
        data_in = 8'hBB;

        @(posedge clk);
        wr_en = 0;
        rd_en = 1;

        @(posedge clk);
        rd_en = 0;

        $display("Simultaneous READ/WRITE test completed");


        // -------------------------
        // FINISH
        // -------------------------
        #20;

        $display("--------------------------------");
        $display("FIFO TESTBENCH COMPLETED");
        $display("--------------------------------");

        $finish;
    end

endmodule