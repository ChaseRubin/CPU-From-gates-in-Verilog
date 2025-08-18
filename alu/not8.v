`timescale 1ns/1ps

module not8 ( //bitwise not, takes one input
    input  wire [7:0] A,
    output wire [7:0] Y
);
    not_gate n0 (.A(A[0]), .Y(Y[0]));
    not_gate n1 (.A(A[1]), .Y(Y[1]));
    not_gate n2 (.A(A[2]), .Y(Y[2]));
    not_gate n3 (.A(A[3]), .Y(Y[3]));
    not_gate n4 (.A(A[4]), .Y(Y[4]));
    not_gate n5 (.A(A[5]), .Y(Y[5]));
    not_gate n6 (.A(A[6]), .Y(Y[6]));
    not_gate n7 (.A(A[7]), .Y(Y[7]));
endmodule
