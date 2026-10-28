`timescale 1ns / 1ps

module execution_unit_tb;

    reg clk;
    reg reset;
    reg start;

    reg [31:0] A;
    reg [31:0] B;
    reg [3:0]  opcode;

    wire [31:0] result;
    wire [31:0] result_hi;
    wire [31:0] remainder;

    wire zero;
    wire negative;
    wire carry;
    wire overflow;

    wire busy;
    wire done;
    wire error;

    integer i;
    integer errors;

    reg [31:0] expected;
    reg [63:0] expected_mul;


    // =====================================================
    // DUT
    // =====================================================

    execution_unit uut (
        .clk(clk),
        .reset(reset),
        .start(start),

        .A(A),
        .B(B),
        .opcode(opcode),

        .result(result),
        .result_hi(result_hi),
        .remainder(remainder),

        .zero(zero),
        .negative(negative),
        .carry(carry),
        .overflow(overflow),

        .busy(busy),
        .done(done),
        .error(error)
    );


    // =====================================================
    // CLOCK
    // =====================================================

    always #5 clk = ~clk;


    // =====================================================
    // MAIN TEST
    // =====================================================

    initial begin

        clk    = 0;
        reset  = 1;
        start  = 0;
        A      = 0;
        B      = 0;
        opcode = 0;

        errors = 0;

        // Reset
        #20;
        reset = 0;
        #10;


        // =================================================
        // RANDOM ALU TESTS
        // Opcodes 0-10
        // =================================================

        $display("");
        $display("========================================");
        $display("RANDOM ALU TESTS");
        $display("========================================");

        for (i = 0; i < 100; i = i + 1) begin

            A = $random;
            B = $random;

            opcode = $urandom_range(0,10);

            start = 1;
            #10;
            start = 0;
            #1;

            case (opcode)

                // ADD
                4'b0000: begin

                    expected = A + B;

                    if (result !== expected) begin
                        $display(
                            "FAIL ADD: A=%h B=%h RESULT=%h EXPECTED=%h",
                            A, B, result, expected
                        );
                        errors = errors + 1;
                    end

                end


                // SUB
                4'b0001: begin

                    expected = A - B;

                    if (result !== expected) begin
                        $display(
                            "FAIL SUB: A=%h B=%h RESULT=%h EXPECTED=%h",
                            A, B, result, expected
                        );
                        errors = errors + 1;
                    end

                end


                // AND
                4'b0010: begin

                    expected = A & B;

                    if (result !== expected) begin
                        $display(
                            "FAIL AND: A=%h B=%h RESULT=%h EXPECTED=%h",
                            A, B, result, expected
                        );
                        errors = errors + 1;
                    end

                end


                // OR
                4'b0011: begin

                    expected = A | B;

                    if (result !== expected) begin
                        $display(
                            "FAIL OR: A=%h B=%h RESULT=%h EXPECTED=%h",
                            A, B, result, expected
                        );
                        errors = errors + 1;
                    end

                end


                // XOR
                4'b0100: begin

                    expected = A ^ B;

                    if (result !== expected) begin
                        $display(
                            "FAIL XOR: A=%h B=%h RESULT=%h EXPECTED=%h",
                            A, B, result, expected
                        );
                        errors = errors + 1;
                    end

                end


                // NOT
                4'b0101: begin

                    expected = ~A;

                    if (result !== expected) begin
                        $display(
                            "FAIL NOT: A=%h RESULT=%h EXPECTED=%h",
                            A, result, expected
                        );
                        errors = errors + 1;
                    end

                end


                // Logical left shift
                4'b0110: begin

                    expected = A << B[4:0];

                    if (result !== expected) begin
                        $display(
                            "FAIL SLL: A=%h B=%h RESULT=%h EXPECTED=%h",
                            A, B, result, expected
                        );
                        errors = errors + 1;
                    end

                end


                // Logical right shift
                4'b0111: begin

                    expected = A >> B[4:0];

                    if (result !== expected) begin
                        $display(
                            "FAIL SRL: A=%h B=%h RESULT=%h EXPECTED=%h",
                            A, B, result, expected
                        );
                        errors = errors + 1;
                    end

                end


                // Arithmetic right shift
                4'b1000: begin

                    expected = $signed(A) >>> B[4:0];

                    if (result !== expected) begin
                        $display(
                            "FAIL SRA: A=%h B=%h RESULT=%h EXPECTED=%h",
                            A, B, result, expected
                        );
                        errors = errors + 1;
                    end

                end


                // Signed less-than
                4'b1001: begin

                    expected = ($signed(A) < $signed(B))
                               ? 32'd1
                               : 32'd0;

                    if (result !== expected) begin
                        $display(
                            "FAIL SLT: A=%h B=%h RESULT=%h EXPECTED=%h",
                            A, B, result, expected
                        );
                        errors = errors + 1;
                    end

                end


                // Unsigned less-than
                4'b1010: begin

                    expected = (A < B)
                               ? 32'd1
                               : 32'd0;

                    if (result !== expected) begin
                        $display(
                            "FAIL SLTU: A=%h B=%h RESULT=%h EXPECTED=%h",
                            A, B, result, expected
                        );
                        errors = errors + 1;
                    end

                end

            endcase

            #10;

        end


        // =================================================
        // RANDOM MULTIPLICATION TESTS
        // Positive operands to avoid signed ambiguity
        // =================================================

        $display("");
        $display("========================================");
        $display("RANDOM MULTIPLICATION TESTS");
        $display("========================================");

        for (i = 0; i < 50; i = i + 1) begin

            A = $urandom_range(0, 65535);
            B = $urandom_range(0, 65535);

            opcode = 4'b1011;

            expected_mul = A * B;

            start = 1;
            #10;
            start = 0;

            wait(done);
            #1;

            if ((result_hi !== expected_mul[63:32]) ||
                (result    !== expected_mul[31:0])) begin

                $display(
                    "FAIL MUL: A=%h B=%h HI=%h LO=%h EXPECTED=%h",
                    A,
                    B,
                    result_hi,
                    result,
                    expected_mul
                );

                errors = errors + 1;

            end

            #10;

        end


        // =================================================
        // RANDOM DIVISION TESTS
        // Positive operands, B never zero
        // =================================================

        $display("");
        $display("========================================");
        $display("RANDOM DIVISION TESTS");
        $display("========================================");

        for (i = 0; i < 50; i = i + 1) begin

            A = $urandom_range(0, 100000);
            B = $urandom_range(1, 1000);

            opcode = 4'b1100;

            expected = A / B;

            start = 1;
            #10;
            start = 0;

            wait(done);
            #1;

            if ((result !== expected) ||
                (error != 0)) begin

                $display(
                    "FAIL DIV: A=%d B=%d RESULT=%d EXPECTED=%d ERROR=%b",
                    A,
                    B,
                    result,
                    expected,
                    error
                );

                errors = errors + 1;

            end

            #10;

        end


        // =================================================
        // RANDOM REMAINDER TESTS
        // =================================================

        $display("");
        $display("========================================");
        $display("RANDOM REMAINDER TESTS");
        $display("========================================");

        for (i = 0; i < 50; i = i + 1) begin

            A = $urandom_range(0, 100000);
            B = $urandom_range(1, 1000);

            opcode = 4'b1101;

            expected = A % B;

            start = 1;
            #10;
            start = 0;

            wait(!busy);
            #1;

            if ((result !== expected) ||
                (remainder !== expected) ||
                (error != 0)) begin

                $display(
                    "FAIL REM: A=%d B=%d RESULT=%d REM=%d EXPECTED=%d ERROR=%b",
                    A,
                    B,
                    result,
                    remainder,
                    expected,
                    error
                );

                errors = errors + 1;

            end

            #10;

        end


        // =================================================
        // DIVIDE BY ZERO TESTS
        // =================================================

        $display("");
        $display("========================================");
        $display("DIVIDE-BY-ZERO TESTS");
        $display("========================================");

        for (i = 0; i < 10; i = i + 1) begin

            A = $urandom;

            B = 0;

            opcode = 4'b1100;

            start = 1;
            #10;
            start = 0;

            wait(done);
            #1;

            if (error != 1) begin

                $display(
                    "FAIL DIV0: A=%h ERROR=%b",
                    A,
                    error
                );

                errors = errors + 1;

            end
            else begin

                $display(
                    "PASS DIV0: A=%h",
                    A
                );

            end

            #10;

        end


        // =================================================
        // FINAL RESULT
        // =================================================

        $display("");
        $display("========================================");

        if (errors == 0) begin

            $display("RANDOMIZED VERIFICATION PASSED");
            $display("TOTAL ERRORS = 0");

        end
        else begin

            $display("RANDOMIZED VERIFICATION FAILED");
            $display("TOTAL ERRORS = %d", errors);

        end

        $display("========================================");

        $finish;

    end

endmodule