module tb;

    reg I0, I1, I2, I3;
    reg S1, S0;

    wire Y1;

    mux_assign uut1(I0,I1,I2,I3,S1,S0,Y1);

    initial begin
        $dumpfile("mux.vcd");
        $dumpvars(0, tb);

        I0=0; I1=1; I2=0; I3=1;

        S1=0; S0=0;
        #10 S1=0; S0=1;
        #10 S1=1; S0=0;
        #10 S1=1; S0=1;

        #10 $finish;
    end
endmodule