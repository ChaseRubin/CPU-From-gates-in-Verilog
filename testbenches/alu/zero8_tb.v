`timescale 1ns/1ps

module zero8_tb;

    reg  [7:0] a;
    wire [7:0] y;

    // Instantiate
    zero8 uut (
        .a(a),
        .y(y)
    );

    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, zero8_tb);

        $monitor("Time=%0t | a=%b | y=%b", $time, a, y);

       
        a = 8'b00000000; #10;
        a = 8'b11111111; #10;
        a = 8'b10101010; #10;
        a = 8'b01010101; #10;
        a = 8'b11001100; #10;
        a = 8'b00110011; #10;

        $finish;
    end

endmodule
