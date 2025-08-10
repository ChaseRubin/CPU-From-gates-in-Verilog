`timescale 1ns/1ps

module and_gate (
    input wire A,
    input wire B,
    output wire Y
);
    assign Y = A & B;
endmodule

