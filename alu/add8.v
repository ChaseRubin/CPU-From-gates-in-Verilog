`timescale 1ns/1ps

//8 bit adder
//each carry out goes to the next carry in
//will output carry out if final bits are both high

module add8 (
    input  wire [7:0] A,
    input  wire [7:0] B,
    input  wire       c_in,
    output wire [7:0] sum,
    output wire       c_out
);

    wire [6:0] carry; // Internal carry wires between stages

    // Instantiate 8 full adders (from LSB to MSB)
    bAdd fa0 (.A(A[0]), .B(B[0]), .c_in(c_in),     .sum(sum[0]), .c_out(carry[0]));
    bAdd fa1 (.A(A[1]), .B(B[1]), .c_in(carry[0]), .sum(sum[1]), .c_out(carry[1]));
    bAdd fa2 (.A(A[2]), .B(B[2]), .c_in(carry[1]), .sum(sum[2]), .c_out(carry[2]));
    bAdd fa3 (.A(A[3]), .B(B[3]), .c_in(carry[2]), .sum(sum[3]), .c_out(carry[3]));
    bAdd fa4 (.A(A[4]), .B(B[4]), .c_in(carry[3]), .sum(sum[4]), .c_out(carry[4]));
    bAdd fa5 (.A(A[5]), .B(B[5]), .c_in(carry[4]), .sum(sum[5]), .c_out(carry[5]));
    bAdd fa6 (.A(A[6]), .B(B[6]), .c_in(carry[5]), .sum(sum[6]), .c_out(carry[6]));
    bAdd fa7 (.A(A[7]), .B(B[7]), .c_in(carry[6]), .sum(sum[7]), .c_out(c_out));

endmodule
