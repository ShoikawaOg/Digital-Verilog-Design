module processor_datapath (
    input wire        clk,
    input wire        reset,

    output wire [31:0] pc,
    output wire [31:0] instruction,
    output wire [31:0] result,

    output wire        zero,
    output wire        negative,
    output wire        carry,
    output wire        overflow,

    output wire        busy,
    output wire        done,
    output wire        error
);

    // =====================================================
    // DECODER SIGNALS
    // =====================================================

    wire [5:0] opcode;
    wire [4:0] rs1;
    wire [4:0] rs2;
    wire [4:0] rd;

    wire [3:0] alu_opcode;

    wire decoder_valid;
    wire uses_rs1;
    wire uses_rs2;
    wire writes_rd;


    // =====================================================
    // CONTROL SIGNALS
    // =====================================================

    wire reg_write;
    wire alu_start;
    wire mem_read;
    wire mem_write;
    wire branch;
    wire control_valid;


    // =====================================================
    // REGISTER FILE
    // =====================================================

    wire [31:0] reg_data1;
    wire [31:0] reg_data2;


    // =====================================================
    // WRITE-BACK
    // =====================================================

    wire [31:0] write_data;
    wire         write_enable;


    assign write_data = result;

    assign write_enable =
        reg_write &&
        writes_rd &&
        decoder_valid &&
        done &&
        !error;


    // =====================================================
    // PROGRAM COUNTER
    // =====================================================

    program_counter pc_unit (
        .clk(clk),
        .reset(reset),

        .enable(1'b1),
        .branch(1'b0),
        .branch_target(32'b0),

        .pc(pc)
    );


    // =====================================================
    // INSTRUCTION MEMORY
    // =====================================================

    instruction_memory instruction_mem (
        .address(pc),
        .instruction(instruction)
    );


    // =====================================================
    // INSTRUCTION DECODER
    // =====================================================

    instruction_decoder decoder (
        .instruction(instruction),

        .opcode(opcode),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),

        .alu_opcode(alu_opcode),

        .valid(decoder_valid),
        .uses_rs1(uses_rs1),
        .uses_rs2(uses_rs2),
        .writes_rd(writes_rd)
    );


    // =====================================================
    // CONTROL UNIT
    // =====================================================

    control_unit control (
        .opcode(opcode),

        .reg_write(reg_write),
        .alu_start(alu_start),

        .mem_read(mem_read),
        .mem_write(mem_write),

        .branch(branch),
        .valid(control_valid)
    );


    // =====================================================
    // REGISTER FILE
    // =====================================================

    register_file registers (
        .clk(clk),
        .reset(reset),

        .read_addr1(rs1),
        .read_addr2(rs2),

        .read_data1(reg_data1),
        .read_data2(reg_data2),

        .write_enable(write_enable),
        .write_addr(rd),
        .write_data(write_data)
    );


    // =====================================================
    // EXECUTION UNIT
    // =====================================================

    execution_unit execution (
        .clk(clk),
        .reset(reset),

        .start(alu_start),

        .A(reg_data1),
        .B(reg_data2),

        .opcode(alu_opcode),

        .result(result),
        .result_hi(),
        .remainder(),

        .zero(zero),
        .negative(negative),
        .carry(carry),
        .overflow(overflow),

        .busy(busy),
        .done(done),
        .error(error)
    );

endmodule