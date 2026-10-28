module register_file (
    input  wire        clk,
    input  wire        reset,

    // Read ports
    input  wire [4:0]  read_addr1,
    input  wire [4:0]  read_addr2,

    output wire [31:0] read_data1,
    output wire [31:0] read_data2,

    // Write port
    input  wire        write_enable,
    input  wire [4:0]  write_addr,
    input  wire [31:0] write_data
);

    // 32 registers × 32 bits
    reg [31:0] registers [0:31];

    integer i;

    // =====================================================
    // RESET
    // =====================================================

    always @(posedge clk or posedge reset) begin

        if (reset) begin

            for (i = 0; i < 32; i = i + 1)
                registers[i] <= 32'b0;

        end

        else begin

            // R0 is hardwired to zero
            registers[0] <= 32'b0;

            // Write
            if (write_enable && (write_addr != 5'b00000))
                registers[write_addr] <= write_data;

        end

    end

    // =====================================================
    // READ PORTS
    // =====================================================

    assign read_data1 =
        (read_addr1 == 5'b00000) ? 32'b0 :
        registers[read_addr1];

    assign read_data2 =
        (read_addr2 == 5'b00000) ? 32'b0 :
        registers[read_addr2];

endmodule