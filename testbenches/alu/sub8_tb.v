`timescale 1ns/1ps

module sub8_tb;

    reg  [7:0] A;
    reg  [7:0] B;
    wire [7:0] diff;
    wire       c_out;
    wire signed [8:0] signed_result;

    // Signed version for monitoring actual subtraction
    assign signed_result = {1'b0, A} - {1'b0, B};  // 9-bit to prevent overflow

    // Instantiate the DUT
    sub8 uut (
        .A(A),
        .B(B),
        .diff(diff),
        .c_out(c_out)
    );

    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, sub8_tb);

        $display("Time\tA\tB\tExpected\tDiff\tCarryOut");
        $monitor("%0t\t%h\t%h\t%0d\t\t%h\t%b", $time, A, B, signed_result, diff, c_out);

        // Test 1: 10 - 5 = 5
        A = 8'd10; B = 8'd5; #10;

        // Test 2: 20 - 20 = 0
        A = 8'd20; B = 8'd20; #10;

        // Test 3: 5 - 10 = -5
        A = 8'd5; B = 8'd10; #10;

        // Test 4: 0 - 1 = -1
        A = 8'd0; B = 8'd1; #10;

        // Test 5: 255 - 128 = 127
        A = 8'd255; B = 8'd128; #10;

        $finish;
    end

endmodule
