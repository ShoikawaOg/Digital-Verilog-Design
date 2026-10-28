module pwm_generator #(
    parameter COUNTER_WIDTH = 8
)(
    input  wire                     clk,
    input  wire                     reset,
    input  wire                     enable,

    input  wire [COUNTER_WIDTH-1:0] duty_cycle,

    output reg                      pwm_out
);

    reg [COUNTER_WIDTH-1:0] counter;

    always @(posedge clk or posedge reset) begin

        if (reset) begin
            counter <= {COUNTER_WIDTH{1'b0}};
            pwm_out <= 1'b0;
        end

        else if (!enable) begin
            counter <= {COUNTER_WIDTH{1'b0}};
            pwm_out <= 1'b0;
        end

        else begin

            // Counter wraps automatically
            counter <= counter + 1'b1;

            // PWM comparison
            if (counter < duty_cycle)
                pwm_out <= 1'b1;
            else
                pwm_out <= 1'b0;

        end

    end

endmodule