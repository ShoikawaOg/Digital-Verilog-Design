module control_unit (
    input  wire [5:0] opcode,

    output reg        reg_write,
    output reg        alu_start,
    output reg        mem_read,
    output reg        mem_write,
    output reg        branch,
    output reg        valid
);

    always @(*) begin

        // Defaults
        reg_write = 1'b0;
        alu_start = 1'b0;
        mem_read  = 1'b0;
        mem_write = 1'b0;
        branch    = 1'b0;
        valid     = 1'b0;

        case (opcode)

            // ADD
            6'b000000: begin
                reg_write = 1'b1;
                alu_start = 1'b1;
                valid     = 1'b1;
            end

            // SUB
            6'b000001: begin
                reg_write = 1'b1;
                alu_start = 1'b1;
                valid     = 1'b1;
            end

            // AND
            6'b000010: begin
                reg_write = 1'b1;
                alu_start = 1'b1;
                valid     = 1'b1;
            end

            // OR
            6'b000011: begin
                reg_write = 1'b1;
                alu_start = 1'b1;
                valid     = 1'b1;
            end

            // XOR
            6'b000100: begin
                reg_write = 1'b1;
                alu_start = 1'b1;
                valid     = 1'b1;
            end

            // NOT
            6'b000101: begin
                reg_write = 1'b1;
                alu_start = 1'b1;
                valid     = 1'b1;
            end

            // SLL
            6'b000110: begin
                reg_write = 1'b1;
                alu_start = 1'b1;
                valid     = 1'b1;
            end

            // SRL
            6'b000111: begin
                reg_write = 1'b1;
                alu_start = 1'b1;
                valid     = 1'b1;
            end

            // SRA
            6'b001000: begin
                reg_write = 1'b1;
                alu_start = 1'b1;
                valid     = 1'b1;
            end

            // SLT
            6'b001001: begin
                reg_write = 1'b1;
                alu_start = 1'b1;
                valid     = 1'b1;
            end

            // SLTU
            6'b001010: begin
                reg_write = 1'b1;
                alu_start = 1'b1;
                valid     = 1'b1;
            end

            // MUL
            6'b001011: begin
                reg_write = 1'b1;
                alu_start = 1'b1;
                valid     = 1'b1;
            end

            // DIV
            6'b001100: begin
                reg_write = 1'b1;
                alu_start = 1'b1;
                valid     = 1'b1;
            end

            // REM
            6'b001101: begin
                reg_write = 1'b1;
                alu_start = 1'b1;
                valid     = 1'b1;
            end

            // Invalid opcode
            default: begin
                reg_write = 1'b0;
                alu_start = 1'b0;
                mem_read  = 1'b0;
                mem_write = 1'b0;
                branch    = 1'b0;
                valid     = 1'b0;
            end

        endcase

    end

endmodule