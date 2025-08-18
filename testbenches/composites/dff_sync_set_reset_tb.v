`timescale 1ns/1ps

module dff_sync_set_reset_tb;
    reg D;
    reg clk;
    reg set;
    reg reset;
    wire Q;

    // Internal probe wires
    wire slave_in_probe;

    // Instantiate
    dff_sync_set_reset uut (
        .D(D),
        .clk(clk),
        .set(set),
        .reset(reset),
        .Q(Q)
    );

    assign slave_in_probe = uut.slave_in;

    // Clock generation: 10ns period
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Dumpfile for GTKWave
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, dff_sync_set_reset_tb);
    end

    // Monitor at each posedge
    always @(posedge clk) begin
        $strobe("posedge @ %0t: D=%b set=%b reset=%b -> Q=%b (slave_in=%b)",
                $time, D, set, reset, Q, slave_in_probe);
    end

    // Stimulus
    initial begin
        // Initial values
        D = 0; set = 0; reset = 0;

        // Wait for alignment
        #7;

        // Normal operation
        D = 1; @(posedge clk);
        D = 0; @(posedge clk);

        // Synchronous set
        set = 1; @(posedge clk);
        set = 0; @(posedge clk);

        // Synchronous reset
        D = 1; reset = 1; @(posedge clk);
        reset = 0; @(posedge clk);

        // Both set and reset high (reset should win, Q=0)
        set = 1; reset = 1; @(posedge clk);
        set = 0; reset = 0; @(posedge clk);

        // Back to normal DFF behavior
        D = 1; @(posedge clk);
        D = 0; @(posedge clk);

        $finish;
    end
endmodule
