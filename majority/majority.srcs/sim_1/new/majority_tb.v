module tb;

    reg A, B, C;
    wire Y;

    majority uut (
        .A(A),
        .B(B),
        .C(C),
        .Y(Y)
    );

    initial begin
        $dumpfile("majority.vcd");
        $dumpvars(0, tb);

        A=0; B=0; C=0;
        #10 A=0; B=0; C=1;
        #10 A=0; B=1; C=0;
        #10 A=0; B=1; C=1;
        #10 A=1; B=0; C=0;
        #10 A=1; B=0; C=1;
        #10 A=1; B=1; C=0;
        #10 A=1; B=1; C=1;

        #10 $finish;
    end
endmodule