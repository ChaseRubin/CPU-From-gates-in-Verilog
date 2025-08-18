`timescale 1ns/1ps

module inc8 (
    input  wire [7:0] A,
    output wire [7:0] Y,
    output wire       c_out
);

    wire [7:0] zero = 8'b00000000;

    add8 adder ( //previous input is put into A, B is always zero, carry in is always high to increment
        .A(A),
        .B(zero),
        .c_in(1'b1),     
        .sum(Y),
        .c_out(c_out)
    );

endmodule
