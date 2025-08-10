`timescale 1ns/1ps

module sub8 (
    input  wire [7:0] A,
    input  wire [7:0] B,
    output wire [7:0] diff,
    output wire       c_out
);

    wire [7:0] B_inverted;

    // Bitwise NOT of B
    not8 not_b (.A(B), .Y(B_inverted));  // You must have a not8 module made from not_gate

    // Perform A + (~B + 1)
    add8 adder (
        .A(A),
        .B(B_inverted),
        .c_in(1'b1),       // Add 1 to complete 2's complement
        .sum(diff),
        .c_out(c_out)
    );

endmodule
