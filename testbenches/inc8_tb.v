`timescale 1ns/1ps

module inc8_tb;

    reg  [7:0] A;
    wire [7:0] Y;
    wire       c_out;

    // Device Under Test
    inc8 uut (
        .A(A),
        .Y(Y),
        .c_out(c_out)
    );

    // Signed version for expected output
    wire signed [8:0] expected = {1'b0, A} + 1;

    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, inc8_tb);

        $display("Time\tA\tA+1\t\tY\tCarryOut");
        $monitor("%0t\t%h\t%0d\t\t%h\t%b", $time, A, expected, Y, c_out);

        // Test 1: 0 + 1 = 1
        A = 8'd0; #10;

        // Test 2: 5 + 1 = 6
        A = 8'd5; #10;

        // Test 3: 127 + 1 = 128
        A = 8'd127; #10;

        // Test 4: 255 + 1 = 0 with carry
        A = 8'd255; #10;

        // Test 5: 200 + 1 = 201
        A = 8'd200; #10;

        $finish;
    end

endmodule
