`timescale 1ns/1ps

module mux2 ( // a mux two selects the output of A or B depended on status of selction bit
    input wire A,
    input wire B,
    input wire S,
    output wire Y
);

    wire not_S; 
    wire A_and_notS;
    wire B_and_S;

    // Instantiate NOT gate
    not_gate u1 (.A(S), .Y(not_S));

    // A AND ~S
    and_gate u2 (.A(A), .B(not_S), .Y(A_and_notS));

    // B AND S
    and_gate u3 (.A(B), .B(S), .Y(B_and_S));

    // Final OR
    or_gate u4 (.A(A_and_notS), .B(B_and_S), .Y(Y));

endmodule

