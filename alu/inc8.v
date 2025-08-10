`timescale 1ns/1ps

module inc8 (
    input  wire [7:0] A,
    output wire [7:0] Y,
    output wire       c_out
);

    wire [7:0] zero = 8'b00000000;

    add8 adder (
        .A(A),
        .B(zero),
        .c_in(1'b1),     // Add 1 to A
        .sum(Y),
        .c_out(c_out)
    );

endmodule
