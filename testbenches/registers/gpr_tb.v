`timescale 1ns/1ps

module gpr_tb;
    reg        clk;
    reg        reset;     // synchronous reset (active high)
    reg        load_en;   // load from bus_in on rising edge when 1
    reg        out_en;    // drive bus_out when 1
    reg  [7:0] bus_in;    // stimulus into the GPR
    wire [7:0] bus_out;   // observed output 

    // DUT
    gpr uut (
        .clk(clk),
        .reset(reset),
        .load_en(load_en),
        .out_en(out_en),
        .bus_in(bus_in),
        .bus_out(bus_out)
    );

    // 10 ns clock
    initial begin
        clk = 1'b0;
        forever #5 clk = ~clk;
    end

    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, gpr_tb);
    end

    always @(posedge clk) begin
        $strobe("posedge @ %0t | reset=%b load_en=%b out_en=%b bus_in=%02h -> bus_out=%02h",
                 $time, reset, load_en, out_en, bus_in, bus_out);
    end

    
    initial begin
        
        reset   = 1'b1;   // assert synchronous reset for first edge
        load_en = 1'b0;
        out_en  = 1'b0;
        bus_in  = 8'h00;

        @(posedge clk);          // apply reset at first edge
        reset = 1'b0;

        // 1) Load 0xA5, keep output disabled (bus_out should be 00)
        bus_in  = 8'hA5;
        load_en = 1'b1;
        @(posedge clk);         
        load_en = 1'b0;

        // 2) Change bus_in while holding (register must hold A5)
        bus_in  = 8'hFF;
        @(posedge clk);          // still A5 internally; bus_out still 00 

        // 3) Enable output; bus_out should show A5
        out_en = 1'b1;
        @(posedge clk);

        // 4) Load 0x3C while out_en=1; bus_out should update to 3C after edge
        bus_in  = 8'h3C;
        load_en = 1'b1;
        @(posedge clk);          // Q <- 3C, bus_out=3C
        load_en = 1'b0;

        // 5) Disable output; bus_out should go to 00
        out_en = 1'b0;
        @(posedge clk);

        // 6) One more load to confirm hold/output behavior
        bus_in  = 8'h12;
        load_en = 1'b1;
        @(posedge clk);          // Q <- 12, bus_out still 00
        load_en = 1'b0;

        // 7) Re-enable output; bus_out should be 12
        out_en = 1'b1;
        @(posedge clk);

        $finish;
    end
endmodule
