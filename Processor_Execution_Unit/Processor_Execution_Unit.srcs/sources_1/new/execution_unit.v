module execution_unit (
    input clk,
    input reset,
    input start,

    input [31:0] A,
    input [31:0] B,
    input [3:0]  opcode,

    output reg [31:0] result,
    output reg [31:0] result_hi,
    output reg [31:0] remainder,

    output reg        zero,
    output reg        negative,
    output reg        carry,
    output reg        overflow,

    output reg        busy,
    output reg        done,
    output reg        error
);

    // =========================================================
    // ALU
    // =========================================================

    wire [31:0] alu_result;
    wire        alu_zero;
    wire        alu_negative;
    wire        alu_carry;
    wire        alu_overflow;


    // =========================================================
    // MULTIPLIER
    // =========================================================

    wire [63:0] mult_product;
    wire        mult_done;
    wire        mult_busy;


    // =========================================================
    // DIVIDER
    // =========================================================

    wire [31:0] div_quotient;
    wire [31:0] div_remainder;
    wire        div_done;
    wire        div_busy;
    wire        div_by_zero;


    // =========================================================
    // ALU INSTANCE
    // =========================================================

    alu alu_unit (
        .A(A),
        .B(B),
        .opcode(opcode),
        .result(alu_result),
        .zero(alu_zero),
        .negative(alu_negative),
        .carry(alu_carry),
        .overflow(alu_overflow)
    );


    // =========================================================
    // MULTIPLIER INSTANCE
    // =========================================================

    multiplier multiplier_unit (
        .clk(clk),
        .reset(reset),

        .start(start && (opcode == 4'b1011)),

        .A(A),
        .B(B),

        .product(mult_product),

        .done(mult_done),
        .busy(mult_busy)
    );


    // =========================================================
    // DIVIDER INSTANCE
    // =========================================================

    divider divider_unit (
        .clk(clk),
        .reset(reset),

        .start(start &&
               ((opcode == 4'b1100) ||
                (opcode == 4'b1101))),

        .A(A),
        .B(B),

        .quotient(div_quotient),
        .remainder(div_remainder),

        .done(div_done),
        .busy(div_busy),

        .divide_by_zero(div_by_zero)
    );


    // =========================================================
    // OUTPUT SELECTION
    // =========================================================

    always @(*) begin

        // -----------------------------------------------------
        // Defaults
        // -----------------------------------------------------

        result    = 32'b0;
        result_hi = 32'b0;
        remainder = 32'b0;

        zero      = 1'b0;
        negative  = 1'b0;
        carry     = 1'b0;
        overflow  = 1'b0;

        busy      = 1'b0;
        done      = 1'b0;
        error     = 1'b0;


        // =====================================================
        // OPCODE SELECTION
        // =====================================================

        case (opcode)

            // -------------------------------------------------
            // ALU OPERATIONS
            // -------------------------------------------------

            4'b0000,     // ADD
            4'b0001,     // SUB
            4'b0010,     // AND
            4'b0011,     // OR
            4'b0100,     // XOR
            4'b0101,     // NOT
            4'b0110,     // SLL
            4'b0111,     // SRL
            4'b1000,     // SRA
            4'b1001,     // SLT
            4'b1010: begin // SLTU

                result   = alu_result;

                zero     = alu_zero;
                negative = alu_negative;
                carry    = alu_carry;
                overflow = alu_overflow;

                // ALU result is available immediately
                done = start;

            end


            // -------------------------------------------------
            // MUL
            // -------------------------------------------------

            4'b1011: begin

                result_hi = mult_product[63:32];
                result    = mult_product[31:0];

                busy = mult_busy;
                done = mult_done;

            end


            // -------------------------------------------------
            // DIV
            // -------------------------------------------------

            4'b1100: begin

                result = div_quotient;

                busy  = div_busy;
                done  = div_done;
                error = div_by_zero;

            end


            // -------------------------------------------------
            // REM
            // -------------------------------------------------

            4'b1101: begin

                result = div_remainder;

                busy  = div_busy;
                done  = div_done;
                error = div_by_zero;

            end


            // -------------------------------------------------
            // INVALID OPCODE
            // -------------------------------------------------

            default: begin

                result = 32'b0;
                error  = 1'b1;
                done   = start;

            end

        endcase


        // Always expose divider remainder
        remainder = div_remainder;

    end

endmodule