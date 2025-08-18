`timescale 1ns/1ps

module reg8 (
    input  wire [7:0] D,     // 8-bit data input
    input  wire clk,         // clock input
    input  wire set,         // synchronous set
    input  wire reset,       // synchronous reset
    output wire [7:0] Q      // 8-bit data output
);
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : reg_bits
            dff_sync_set_reset dff_inst (
                .D(D[i]),
                .clk(clk),
                .set(set),
                .reset(reset),
                .Q(Q[i])
            );
        end
    endgenerate
endmodule


