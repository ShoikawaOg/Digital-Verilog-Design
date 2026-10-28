module instruction_decoder (

    input  wire [31:0] instruction,

    output wire [5:0]  opcode,
    output wire [4:0]  rs1,
    output wire [4:0]  rs2,
    output wire [4:0]  rd,

    output reg  [3:0]  alu_opcode,

    output reg         valid,
    output reg         uses_rs1,
    output reg         uses_rs2,
    output reg         writes_rd

);

    // =====================================================
    // INSTRUCTION FIELDS
    // =====================================================

    assign opcode = instruction[31:26];
    assign rs1    = instruction[25:21];
    assign rs2    = instruction[20:16];
    assign rd     = instruction[15:11];


    // =====================================================
    // DECODER
    // =====================================================

    always @(*) begin

        // Defaults
        alu_opcode = 4'b0000;

        valid     = 1'b0;
        uses_rs1  = 1'b0;
        uses_rs2  = 1'b0;
        writes_rd = 1'b0;

        case (opcode)

            // ADD
            6'b000000: begin
                alu_opcode = 4'b0000;
                valid      = 1'b1;
                uses_rs1   = 1'b1;
                uses_rs2   = 1'b1;
                writes_rd  = 1'b1;
            end

            // SUB
            6'b000001: begin
                alu_opcode = 4'b0001;
                valid      = 1'b1;
                uses_rs1   = 1'b1;
                uses_rs2   = 1'b1;
                writes_rd  = 1'b1;
            end

            // AND
            6'b000010: begin
                alu_opcode = 4'b0010;
                valid      = 1'b1;
                uses_rs1   = 1'b1;
                uses_rs2   = 1'b1;
                writes_rd  = 1'b1;
            end

            // OR
            6'b000011: begin
                alu_opcode = 4'b0011;
                valid      = 1'b1;
                uses_rs1   = 1'b1;
                uses_rs2   = 1'b1;
                writes_rd  = 1'b1;
            end

            // XOR
            6'b000100: begin
                alu_opcode = 4'b0100;
                valid      = 1'b1;
                uses_rs1   = 1'b1;
                uses_rs2   = 1'b1;
                writes_rd  = 1'b1;
            end

            // NOT
            6'b000101: begin
                alu_opcode = 4'b0101;
                valid      = 1'b1;
                uses_rs1   = 1'b1;
                uses_rs2   = 1'b0;
                writes_rd  = 1'b1;
            end

            // SLL
            6'b000110: begin
                alu_opcode = 4'b0110;
                valid      = 1'b1;
                uses_rs1   = 1'b1;
                uses_rs2   = 1'b1;
                writes_rd  = 1'b1;
            end

            // SRL
            6'b000111: begin
                alu_opcode = 4'b0111;
                valid      = 1'b1;
                uses_rs1   = 1'b1;
                uses_rs2   = 1'b1;
                writes_rd  = 1'b1;
            end

            // SRA
            6'b001000: begin
                alu_opcode = 4'b1000;
                valid      = 1'b1;
                uses_rs1   = 1'b1;
                uses_rs2   = 1'b1;
                writes_rd  = 1'b1;
            end

            // SLT
            6'b001001: begin
                alu_opcode = 4'b1001;
                valid      = 1'b1;
                uses_rs1   = 1'b1;
                uses_rs2   = 1'b1;
                writes_rd  = 1'b1;
            end

            // SLTU
            6'b001010: begin
                alu_opcode = 4'b1010;
                valid      = 1'b1;
                uses_rs1   = 1'b1;
                uses_rs2   = 1'b1;
                writes_rd  = 1'b1;
            end

            // MUL
            6'b001011: begin
                alu_opcode = 4'b1011;
                valid      = 1'b1;
                uses_rs1   = 1'b1;
                uses_rs2   = 1'b1;
                writes_rd  = 1'b1;
            end

            // DIV
            6'b001100: begin
                alu_opcode = 4'b1100;
                valid      = 1'b1;
                uses_rs1   = 1'b1;
                uses_rs2   = 1'b1;
                writes_rd  = 1'b1;
            end

            // REM
            6'b001101: begin
                alu_opcode = 4'b1101;
                valid      = 1'b1;
                uses_rs1   = 1'b1;
                uses_rs2   = 1'b1;
                writes_rd  = 1'b1;
            end

            // Invalid instruction
            default: begin
                alu_opcode = 4'b0000;
                valid      = 1'b0;
                uses_rs1   = 1'b0;
                uses_rs2   = 1'b0;
                writes_rd  = 1'b0;
            end

        endcase

    end

endmodule