`timescale 1ns/1ps

module bAdd (
    input wire A,
    input wire B,
    input wire c_in,
    output wire sum,
    output wire c_out
);

    wire xor_AB;
    wire sum_temp;
    wire and1_out, and2_out;

    // sum = A ^ B ^ c_in
    xor_gate u1 (.A(A),      .B(B),     .Y(xor_AB));
    xor_gate u2 (.A(xor_AB), .B(c_in),  .Y(sum));

    // c_out = (A & B) | (c_in & (A ^ B))
    and_gate u3 (.A(A),      .B(B),     .Y(and1_out));
    and_gate u4 (.A(c_in),   .B(xor_AB),.Y(and2_out));
    or_gate  u5 (.A(and1_out), .B(and2_out), .Y(c_out));

endmodule
