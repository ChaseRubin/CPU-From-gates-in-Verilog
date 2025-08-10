`timescale 1ns/1ps

module not_gate (
    input wire A,
    output wire Y
);
    assign Y = ~A;
endmodule

