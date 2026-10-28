`timescale 1ns / 1ps

module pwm_generator_random_tb;

    reg clk;
    reg reset;
    reg enable;

    reg [7:0] duty_cycle;

    wire pwm_out;

    integer i;
    integer high_count;
    integer total_count;
    integer expected_high;
    integer tolerance;


    pwm_generator #(
        .COUNTER_WIDTH(8)
    ) uut (
        .clk(clk),
        .reset(reset),
        .enable(enable),
        .duty_cycle(duty_cycle),
        .pwm_out(pwm_out)
    );


    // 100 MHz clock
    always #5 clk = ~clk;


    initial begin

        clk = 1'b0;
        reset = 1'b1;
        enable = 1'b0;
        duty_cycle = 8'd0;

        #20;

        reset = 1'b0;
        enable = 1'b1;

        $display("");
        $display("========================================");
        $display("PWM RANDOMIZED TEST");
        $display("========================================");


        // Test 20 different duty cycles

        for (i = 0; i < 20; i = i + 1) begin

            duty_cycle = $urandom_range(0,255);

            high_count = 0;
            total_count = 0;

            // Wait for counter to reach a known boundary
            @(negedge uut.counter[0]);

            // Measure one complete PWM period
            repeat (256) begin

                @(posedge clk);

                if (pwm_out)
                    high_count = high_count + 1;

                total_count = total_count + 1;

            end

            expected_high = duty_cycle;

            tolerance = 3;

            $display(
                "Test %0d: Duty=%0d  High=%0d  Expected=%0d",
                i + 1,
                duty_cycle,
                high_count,
                expected_high
            );

            if ((high_count >= expected_high - tolerance) &&
                (high_count <= expected_high + tolerance))

                $display("PASS");

            else

                $display("FAIL");

        end


        $display("");
        $display("========================================");
        $display("PWM RANDOMIZED TEST COMPLETE");
        $display("========================================");

        $finish;

    end

endmodule