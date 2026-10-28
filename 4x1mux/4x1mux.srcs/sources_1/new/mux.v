module mux_assign(
    input I0, I1, I2, I3,
    input S1, S0,
    output Y
);
    assign Y = S1 ? (S0 ? I3 : I2) : (S0 ? I1 : I0);
endmodule