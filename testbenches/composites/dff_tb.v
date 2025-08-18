`timescale 1ns/1ps

module dff_tb;

    reg D;
    reg clk;
    wire Q;

    dff uut (
        .D(D),
        .clk(clk),
        .Q(Q)
    );

    // Clock gen
    always #5 clk = ~clk;

    initial begin
        // Initialize
        $dumpfile("wave.vcd");
        $dumpvars(0, dff_tb);

        clk = 0;
        D = 0;

        
        #7  D = 1;  // Change D before rising edge
        #10 D = 0;  // Change D before next rising edge
        #10 D = 1;  // Change D again
        #10 D = 0;
        #10 D = 1;
        #10 D = 0;

        #10 $finish;
    end

endmodule
