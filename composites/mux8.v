`timescale 1ns/1ps

module mux8 (
    input  wire in0,
    input  wire in1,
    input  wire in2,
    input  wire in3,
    input  wire in4,
    input  wire in5,
    input  wire in6,
    input  wire in7,
    input  wire [2:0] sel,
    output wire y
);

    wire m1, m2, m3, m4; // outputs of first stage
    wire m5, m6;         // outputs of second stage

    // First stage: select between each pair
    mux2 u0 (.A(in0), .B(in1), .S(sel[0]), .Y(m1));
    mux2 u1 (.A(in2), .B(in3), .S(sel[0]), .Y(m2));
    mux2 u2 (.A(in4), .B(in5), .S(sel[0]), .Y(m3));
    mux2 u3 (.A(in6), .B(in7), .S(sel[0]), .Y(m4));

    // Second stage: select between first-stage results
    mux2 u4 (.A(m1), .B(m2), .S(sel[1]), .Y(m5));
    mux2 u5 (.A(m3), .B(m4), .S(sel[1]), .Y(m6));

    // Third stage: select final output
    mux2 u6 (.A(m5), .B(m6), .S(sel[2]), .Y(y));

endmodule
