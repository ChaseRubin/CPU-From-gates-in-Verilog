`timescale 1ns/1ps

module tri_buf (
    input  wire A,    // data in
    input  wire EN,   // enable
    output wire Y     // data out or high-Z
);
    wire nEN;
    wire and_out;

    // Invert enable
    not_gate inv0 (.A(EN), .Y(nEN));

    // Gate the signal when EN is high
    and_gate and0 (.A(A), .B(EN), .Y(and_out));

    // When EN is low, output is high-Z
    bufif1 (Y, A, EN); //primitive for tri-state 
endmodule
