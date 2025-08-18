`timescale 1ns/1ps
module pc_tb;
  reg clk=0, reset=1, load=0, enable=0;
  reg [7:0] load_value=8'h00;
  wire [7:0] pc_out;

  always #5 clk=~clk;

  pc dut(.clk(clk), .reset(reset), .load(load), .enable(enable),
         .load_value(load_value), .pc_out(pc_out));

  initial begin
    $dumpfile("pc_tb.vcd"); $dumpvars(0, pc_tb);
    repeat(2) @(posedge clk);
    reset=0;

    // expect hold at 00
    repeat(2) @(posedge clk);

    // increment 3 cycles -> expect 03
    enable=1; repeat(3) @(posedge clk);
    enable=0; @(posedge clk);
    $display("pc_out=%0d (should be 3)", pc_out);

    // load 0x0A on next edge
    load_value=8'h0A; load=1; @(posedge clk);
    load=0; @(posedge clk);
    $display("pc_out=%0d (should be 10)", pc_out);

    $finish;
  end
endmodule
