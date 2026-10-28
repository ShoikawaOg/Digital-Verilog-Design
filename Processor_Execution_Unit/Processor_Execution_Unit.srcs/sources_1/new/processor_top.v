module processor_top (
    input wire        clk,
    input wire        reset,

    output wire [31:0] result,
    output wire [31:0] pc,

    output wire        busy,
    output wire        done,
    output wire        error
);

    // =====================================================
    // PROCESSOR STATES
    // =====================================================

    localparam FETCH     = 3'b000;
    localparam EXECUTE   = 3'b001;
    localparam WAIT_EXEC = 3'b010;
    localparam WRITEBACK = 3'b011;

    reg [2:0] state;


    // =====================================================
    // PROGRAM COUNTER
    // =====================================================

    reg [31:0] pc_reg;

    assign pc = pc_reg;


    // =====================================================
    // INSTRUCTION MEMORY
    // =====================================================

    wire [31:0] instruction;


    instruction_memory instruction_mem (
        .address(pc_reg),
        .instruction(instruction)
    );


    // =====================================================
    // INSTRUCTION DECODER
    // =====================================================

    wire [5:0] opcode;
    wire [4:0] rs1;
    wire [4:0] rs2;
    wire [4:0] rd;

    wire [3:0] eu_opcode;

    wire decoder_valid;
    wire uses_rs1;
    wire uses_rs2;
    wire writes_rd;


    instruction_decoder decoder (
        .instruction(instruction),

        .opcode(opcode),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),

        .alu_opcode(eu_opcode),

        .valid(decoder_valid),
        .uses_rs1(uses_rs1),
        .uses_rs2(uses_rs2),
        .writes_rd(writes_rd)
    );


    // =====================================================
    // CONTROL UNIT
    // =====================================================

    wire reg_write;
    wire alu_start;
    wire mem_read;
    wire mem_write;
    wire branch;
    wire control_valid;


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

    wire [31:0] reg_data1;
    wire [31:0] reg_data2;

    reg        register_write_enable;
    reg [4:0]  register_write_addr;
    reg [31:0] register_write_data;


    register_file registers (
        .clk(clk),
        .reset(reset),

        .read_addr1(rs1),
        .read_addr2(rs2),

        .read_data1(reg_data1),
        .read_data2(reg_data2),

        .write_enable(register_write_enable),
        .write_addr(register_write_addr),
        .write_data(register_write_data)
    );


    // =====================================================
    // EXECUTION UNIT
    // =====================================================

    reg eu_start;

    wire [31:0] eu_result;
    wire [31:0] eu_result_hi;
    wire [31:0] eu_remainder;

    wire eu_zero;
    wire eu_negative;
    wire eu_carry;
    wire eu_overflow;

    wire eu_busy;
    wire eu_done;
    wire eu_error;


    execution_unit execution (
        .clk(clk),
        .reset(reset),

        .start(eu_start),

        .A(reg_data1),
        .B(reg_data2),

        .opcode(eu_opcode),

        .result(eu_result),
        .result_hi(eu_result_hi),
        .remainder(eu_remainder),

        .zero(eu_zero),
        .negative(eu_negative),
        .carry(eu_carry),
        .overflow(eu_overflow),

        .busy(eu_busy),
        .done(eu_done),
        .error(eu_error)
    );


    // =====================================================
    // OUTPUTS
    // =====================================================

    assign result = eu_result;

    assign busy  = eu_busy;
    assign done  = eu_done;
    assign error = eu_error;


    // =====================================================
    // WRITE-BACK CONTROL
    // =====================================================

    always @(*) begin

        // Defaults

        eu_start = 1'b0;

        register_write_enable = 1'b0;
        register_write_addr   = rd;
        register_write_data   = eu_result;


        case (state)

            // =============================================
            // FETCH
            // =============================================

            FETCH: begin

                // Instruction is already available
                // from instruction memory.
                // Move to execution.

            end


            // =============================================
            // EXECUTE
            // =============================================

            EXECUTE: begin

                if (decoder_valid &&
                    control_valid &&
                    alu_start) begin

                    eu_start = 1'b1;

                end

            end


            // =============================================
            // WAIT
            // =============================================

            WAIT_EXEC: begin

                // Wait for MUL / DIV / REM.

            end


            // =============================================
            // WRITE BACK
            // =============================================

            WRITEBACK: begin

                if (decoder_valid &&
                    control_valid &&
                    reg_write &&
                    writes_rd &&
                    !eu_error) begin

                    register_write_enable = 1'b1;

                end

            end


            default: begin

                eu_start = 1'b0;

            end

        endcase

    end


    // =====================================================
    // MAIN PROCESSOR FSM
    // =====================================================

    always @(posedge clk or posedge reset) begin

        if (reset) begin

            state  <= FETCH;
            pc_reg <= 32'b0;

        end

        else begin

            case (state)

                // =========================================
                // FETCH
                // =========================================

                FETCH: begin

                    state <= EXECUTE;

                end


                // =========================================
                // EXECUTE
                // =========================================

                EXECUTE: begin

                    if (!decoder_valid ||
                        !control_valid) begin

                        // Invalid instruction:
                        // skip it.

                        pc_reg <= pc_reg + 32'd4;
                        state  <= FETCH;

                    end

                    else if ((eu_opcode == 4'b1011) ||
                             (eu_opcode == 4'b1100) ||
                             (eu_opcode == 4'b1101)) begin

                        // MUL / DIV / REM
                        // are multi-cycle.

                        state <= WAIT_EXEC;

                    end

                    else begin

                        // ADD / SUB / AND / OR / XOR /
                        // NOT / shifts / comparisons.

                        state <= WRITEBACK;

                    end

                end


                // =========================================
                // WAIT FOR MULTI-CYCLE EXECUTION
                // =========================================

                WAIT_EXEC: begin

                    if (eu_done) begin

                        state <= WRITEBACK;

                    end

                end


                // =========================================
                // WRITE BACK
                // =========================================

                WRITEBACK: begin

                    // Move to next instruction.

                    pc_reg <= pc_reg + 32'd4;

                    state <= FETCH;

                end


                default: begin

                    state  <= FETCH;
                    pc_reg <= 32'b0;

                end

            endcase

        end

    end

endmodule