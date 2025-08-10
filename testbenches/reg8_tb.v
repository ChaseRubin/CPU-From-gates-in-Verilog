`timescale 1ns/1ps

module reg8_tb;
    reg  [7:0] D;
    reg        clk;
    reg        set;
    reg        reset;
    wire [7:0] Q;

    // Instantiate the DUT
    reg8 uut (
        .D(D),
        .clk(clk),
        .set(set),
        .reset(reset),
        .Q(Q)
    );

    // Clock generation: 10ns period
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Dumpfile for GTKWave
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, reg8_tb);
    end

    // Monitor output at each rising edge
    always @(posedge clk) begin
        $strobe("posedge @ %0t | D=%b set=%b reset=%b -> Q=%b",
                $time, D, set, reset, Q);
    end

    // Stimulus
    initial begin
        // Initial state
        D = 8'b00000000; set = 0; reset = 0;

        #7; // offset from posedge so assignments happen before the next clock

        // Normal load sequence
        D = 8'b10101010; @(posedge clk);
        D = 8'b11001100; @(posedge clk);

        // Synchronous set (all bits to 1)
        set = 1; @(posedge clk);
        set = 0; @(posedge clk);

        // Synchronous reset (all bits to 0)
        D = 8'b11110000;
        reset = 1; @(posedge clk);
        reset = 0; @(posedge clk);

        // Both set and reset high (reset should win, Q=0)
        set = 1; reset = 1; @(posedge clk);
        set = 0; reset = 0; @(posedge clk);

        // Back to normal operation
        D = 8'b00001111; @(posedge clk);
        D = 8'b11111111; @(posedge clk);

        $finish;
    end
endmodule
