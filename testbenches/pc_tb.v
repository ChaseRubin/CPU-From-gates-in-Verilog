`timescale 1ns/1ps

module pc_tb;
    reg        clk;
    reg        reset;       // synchronous
    reg        load;
    reg        enable;
    reg  [7:0] load_value;
    wire [7:0] pc_out;

    // DUT
    pc uut (
        .clk(clk),
        .reset(reset),
        .load(load),
        .enable(enable),
        .load_value(load_value),
        .pc_out(pc_out)
    );

    // === Optional internal probes for GTKWave ===
    // (Remove if your simulator disallows hierarchical refs.)
    wire [7:0] pc_plus1_probe      = uut.pc_plus1;
    wire [7:0] pc_inc_or_hold_probe= uut.pc_inc_or_hold;
    wire [7:0] pc_next_probe       = uut.pc_next;

    // 10 ns period clock
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // VCD dump
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, pc_tb);
    end

    // Edge-stamped log at every posedge
    always @(posedge clk) begin
        $strobe("posedge @ %0t | reset=%b load=%b enable=%b load_value=%02h | pc_out=%02h | plus1=%02h inc_or_hold=%02h next=%02h",
                $time, reset, load, enable, load_value, pc_out,
                pc_plus1_probe, pc_inc_or_hold_probe, pc_next_probe);
    end

    // Stimulus
    initial begin
        // Defaults
        reset = 1'b1;  // synchronous: will take effect on first posedge
        load  = 1'b0;
        enable= 1'b0;
        load_value = 8'h00;

        // 1) Reset to 0 and hold
        @(posedge clk);  // apply reset at first edge -> pc_out = 00
        reset = 1'b0;    // deassert after the edge

        // Hold for two cycles (enable=0, load=0)
        @(posedge clk);
        @(posedge clk);

        // 2) Increment for three cycles (enable=1)
        enable = 1'b1;
        @(posedge clk);  // pc_out = 01
        @(posedge clk);  // pc_out = 02
        @(posedge clk);  // pc_out = 03

        // 3) Load has priority over enable
        // Keep enable=1, assert load with target 0x20
        load_value = 8'h20;
        load = 1'b1;
        @(posedge clk);  // pc_out = 20 (load wins over increment)
        load = 1'b0;

        // 4) Continue incrementing two cycles
        @(posedge clk);  // 21
        @(posedge clk);  // 22

        // 5) Jump again to 0x90 while enable=1 to confirm priority
        load_value = 8'h90;
        load = 1'b1;
        @(posedge clk);  // 90
        load = 1'b0;

        // 6) Increment a couple more
        @(posedge clk);  // 91
        @(posedge clk);  // 92

        // 7) Synchronous reset mid-run
        reset = 1'b1;
        @(posedge clk);  // pc_out = 00 (reset)
        reset = 1'b0;

        // 8) Hold for one cycle, then increment once
        enable = 1'b0; @(posedge clk); // hold at 00
        enable = 1'b1; @(posedge clk); // 01

        $finish;
    end
endmodule
