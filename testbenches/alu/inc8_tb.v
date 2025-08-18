`timescale 1ns/1ps
module inc8_tb;
  reg  [7:0] A;
  wire [7:0] Y;
  wire       c_out;
  inc8 dut(.A(A), .Y(Y), .c_out(c_out));
  initial begin
    A=8'd0; #1 $display("A=0  Y=%0d (exp 1)", Y);
    A=8'd1; #1 $display("A=1  Y=%0d (exp 2)", Y);
    A=8'd2; #1 $display("A=2  Y=%0d (exp 3)", Y);
    A=8'd255; #1 $display("A=255 Y=%0d c_out=%b (exp 0,1)", Y, c_out);
    $finish;
  end
endmodule
