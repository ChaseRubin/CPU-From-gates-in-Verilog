`timescale 1ns/1ps

module add8_tb;

    // Inputs
    reg [7:0] A;
    reg [7:0] B;
    reg       c_in;

    // Outputs
    wire [7:0] sum;
    wire       c_out;

    // Instantiate  8-bit adder
    add8 uut (
        .A(A),
        .B(B),
        .c_in(c_in),
        .sum(sum),
        .c_out(c_out)
    );

    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, add8_tb);

        // Test 1: 0 + 0
        A = 8'h00; B = 8'h00; c_in = 0;
        #10;
        $display("A=%h B=%h Cin=%b -> Sum=%h Cout=%b", A, B, c_in, sum, c_out);

        // Test 2: 1 + 1
        A = 8'h01; B = 8'h01; c_in = 0;
        #10;
        $display("A=%h B=%h Cin=%b -> Sum=%h Cout=%b", A, B, c_in, sum, c_out);

        // Test 3: 0x55 + 0x0A
        A = 8'h55; B = 8'h0A; c_in = 0;
        #10;
        $display("A=%h B=%h Cin=%b -> Sum=%h Cout=%b", A, B, c_in, sum, c_out);

        // Test 4: 0xFF + 0x01
        A = 8'hFF; B = 8'h01; c_in = 0;
        #10;
        $display("A=%h B=%h Cin=%b -> Sum=%h Cout=%b", A, B, c_in, sum, c_out);

        // Test 5: 0x80 + 0x80 + Cin
        A = 8'h80; B = 8'h80; c_in = 1;
        #10;
        $display("A=%h B=%h Cin=%b -> Sum=%h Cout=%b", A, B, c_in, sum, c_out);

        $finish;
    end

endmodule