`timescale 1ns/1ps

module decoder4to16 (
    input  wire A3, A2, A1, A0,   // 4-bit address
    output wire [15:0] D          // 16 decoder outputs
);
    wire [3:0] high; // output of high 2-to-4
    wire [3:0] low;  // output of low 2-to-4

    // High bits select which 4 group of outputs
    decoder2to4 dec_high (
        .A1(A3), .A0(A2),
        .D0(high[0]), .D1(high[1]), .D2(high[2]), .D3(high[3])
    );

    // Low bits select within each group
    decoder2to4 dec_low (
        .A1(A1), .A0(A0),
        .D0(low[0]), .D1(low[1]), .D2(low[2]), .D3(low[3])
    );

    // Combine high and low outputs
    assign D[0]  = high[0] & low[0];
    assign D[1]  = high[0] & low[1];
    assign D[2]  = high[0] & low[2];
    assign D[3]  = high[0] & low[3];

    assign D[4]  = high[1] & low[0];
    assign D[5]  = high[1] & low[1];
    assign D[6]  = high[1] & low[2];
    assign D[7]  = high[1] & low[3];

    assign D[8]  = high[2] & low[0];
    assign D[9]  = high[2] & low[1];
    assign D[10] = high[2] & low[2];
    assign D[11] = high[2] & low[3];

    assign D[12] = high[3] & low[0];
    assign D[13] = high[3] & low[1];
    assign D[14] = high[3] & low[2];
    assign D[15] = high[3] & low[3];
endmodule
