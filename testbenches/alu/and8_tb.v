`timescale 1ns/1ps

module and8_tb;

  reg [7:0] a, b;
  wire [7:0] y;

  // Instantiate the module under test
  and8 uut (
    .a(a),
    .b(b),
    .y(y)
  );

  initial begin
    // Dump waveforms for GTKWave
    $dumpfile("wave.vcd");
    $dumpvars(0, and8_tb);

    // Monitor signal changes
    $monitor("Time=%0t | a=%b b=%b => y=%b", $time, a, b, y);

    // Test cases
    a = 8'b00000000; b = 8'b00000000; #10;
    a = 8'b11111111; b = 8'b00000000; #10;
    a = 8'b10101010; b = 8'b11001100; #10;
    a = 8'b11110000; b = 8'b00001111; #10;
    a = 8'b11111111; b = 8'b11111111; #10;

    $finish;
  end

endmodule
