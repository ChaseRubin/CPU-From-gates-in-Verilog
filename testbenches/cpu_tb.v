`timescale 1ns/1ps

module cpu_tb;

  reg clk   = 1'b0;
  reg reset = 1'b1;

  // for stop-on-halt loop
  integer i;
  integer max_cycles;

  cpu dut (
    .clk  (clk),
    .reset(reset)
  );

  always #5 clk = ~clk;

  initial begin
    reset = 1'b1;
    #12;
    reset = 1'b0;
  end

  initial begin
    $dumpfile("wave.vcd");
    $dumpvars(0, cpu_tb);
  end


  initial begin
    $display(" time | PC  IR  T |  A   R1  R2  R5 | BUS");
    $monitor("%5t | %02h  %02h  %0d | %02h  %02h  %02h  %02h | %02h",
      $time,
      dut.pc_out,                 // PC
      dut.IR,                     // IR
      dut.T,                      // microstep
      dut.acc_q,                  // A
      dut.g_gprs[1].u_gpr.reg_q,  // R1
      dut.g_gprs[2].u_gpr.reg_q,  // R2
      dut.g_gprs[5].u_gpr.reg_q,  // R3
      dut.bus                     // shared bus
    );
  end

  // stop on HALT (IR==0xF0 at T0) 
  initial begin
    max_cycles = 5000;  // safety 
    for (i = 0; i < max_cycles; i = i + 1) begin
      @(posedge clk);

      // When opcode fetch shows HLT at T0 ends
      if (dut.IR == 8'hF0 && dut.T == 2'b00) begin
      
        @(posedge clk);
        @(posedge clk);



        $finish;
      end
    end

    $display("Timeout without HALT.");
    $finish;
  end

endmodule
