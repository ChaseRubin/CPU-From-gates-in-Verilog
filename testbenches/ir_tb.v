`timescale 1ns/1ps
module ir_tb;
    reg        clk, reset, load;
    reg  [7:0] instr_in;
    wire [7:0] instr_out;

    ir dut(.clk(clk), .reset(reset), .load(load), .instr_in(instr_in), .instr_out(instr_out));

    // clock: 10 ns
    initial begin clk = 0; forever #5 clk = ~clk; end

    // waves
    initial begin $dumpfile("wave.vcd"); $dumpvars(0, ir_tb); end

    // edge-stamped log
    always @(posedge clk)
        $strobe("posedge %0t | reset=%b load=%b instr_in=%02h -> IR=%02h",
                $time, reset, load, instr_in, instr_out);

    initial begin
        // reset on first edge
        reset=1; load=0; instr_in=8'h00; @(posedge clk);
        reset=0;

        // fetch: load instruction 0xA3
        instr_in=8'hA3; load=1; @(posedge clk);
        // execute: hold
        load=0; @(posedge clk);

        // fetch next: 0x1C
        instr_in=8'h1C; load=1; @(posedge clk);
        // execute: hold
        load=0; @(posedge clk);

        // change instr_in while holding (IR must not change)
        instr_in=8'hFF; @(posedge clk);

        $finish;
    end
endmodule
