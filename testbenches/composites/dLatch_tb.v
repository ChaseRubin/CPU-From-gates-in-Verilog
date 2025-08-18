`timescale 1ns/1ps

module dLatch_tb;

    reg D, E;
    wire Q;

    dLatch uut (
        .D(D),
        .E(E),
        .Q(Q)
    );

    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, dLatch_tb);
        $monitor("Time=%0t | D=%b E=%b => Q=%b", $time, D, E, Q);

        // Initial
        D = 0; E = 0; #10;

        // Enable high, test D=0 --> Q=0
        E = 1;
        D = 0; #10;


        // D=1 while enabled --> Q=1
        D = 1; 
        E = 1; #10;

        // Disable latch --> Q should hold
        E = 0; 
        D = 1; #10;


        // Change D to 0 while disabled --> Q stays 1
        D = 0; 
        E = 0; #10;


        // Enable again Q
        E = 1; 
        D = 0; #10;

        // Disable again
        E = 0; 
        D = 0; #10;

        $finish;
    end

endmodule
