
`timescale 1ns/1ps
module dff_sync_set_reset ( 
    input  wire D,
    input  wire clk,
    input  wire set,    // sync set to 1
    input  wire reset,  // sync reset to 0
    output reg  Q
);
    always @(posedge clk) begin //set during clock makes it high, reset during clock makes low
        if (reset)      Q <= 1'b0;
        else if (set)   Q <= 1'b1;
        else            Q <= D;
    end
endmodule
