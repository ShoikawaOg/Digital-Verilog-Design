module pwm_top (
    input  wire clk,
    input  wire reset,

    output wire pwm_out
);

    // 50% duty cycle
    wire [7:0] duty_cycle;

    assign duty_cycle = 8'd128;


    pwm_generator #(
        .COUNTER_WIDTH(8)
    ) pwm_unit (
        .clk(clk),
        .reset(reset),
        .enable(1'b1),
        .duty_cycle(duty_cycle),
        .pwm_out(pwm_out)
    );

endmodule