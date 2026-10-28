module parity(
    input A, B, C, D,
    output P
);
    assign P = A ^ B ^ C ^ D;
endmodule