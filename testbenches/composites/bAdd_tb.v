module bAdd_tb;
    reg A, B, c_in;
    wire sum, c_out;

    bAdd uut (
        .A(A), .B(B), .c_in(c_in),
        .sum(sum), .c_out(c_out)
    );

    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, bAdd_tb);
        $monitor("A=%b B=%b c_in=%b => sum=%b c_out=%b", A, B, c_in, sum, c_out);

        A = 0; B = 0; c_in = 0; #10;
        A = 0; B = 1; c_in = 0; #10;
        A = 1; B = 0; c_in = 0; #10;
        A = 1; B = 1; c_in = 0; #10;
        A = 0; B = 0; c_in = 1; #10;
        A = 0; B = 1; c_in = 1; #10;
        A = 1; B = 0; c_in = 1; #10;
        A = 1; B = 1; c_in = 1; #10;

        $finish;
    end
endmodule
