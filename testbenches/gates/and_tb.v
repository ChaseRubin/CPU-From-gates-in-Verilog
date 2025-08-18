module and_tb;

    reg A, B;
    wire Y;

    // Instantiate
    and_gate uut (
        .A(A),
        .B(B),
        .Y(Y)
    );

    initial begin
        
        $monitor("Time=%0t A=%b -> Y=%b", $time, A, Y);
        $dumpfile("wave.vcd");
        $dumpvars(0, and_tb);


        A = 0;
        B = 0;
        #10;
        A = 1;
        B = 0;
        #10;
        A = 0;
        B = 1;
        #10;
        A = 1;
        B = 1;
        #10;

        $finish;
    end

endmodule
