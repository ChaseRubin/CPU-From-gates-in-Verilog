`timescale 1ns/1ps

//a 2 to 4 decoder takes in two bits and outputs the selected bit

module decoder2to4 (
    input  wire A1, A0,   // 2-bit input
    output wire D0, D1, D2, D3 // selects only one
);
    wire nA1, nA0;

    not_gate u0 (.A(A1), .Y(nA1));
    not_gate u1 (.A(A0), .Y(nA0));

    and_gate a0 (.A(nA1), .B(nA0), .Y(D0)); // 00
    and_gate a1 (.A(nA1), .B(A0),  .Y(D1)); // 01
    and_gate a2 (.A(A1),  .B(nA0), .Y(D2)); // 10
    and_gate a3 (.A(A1),  .B(A0),  .Y(D3)); // 11
endmodule
