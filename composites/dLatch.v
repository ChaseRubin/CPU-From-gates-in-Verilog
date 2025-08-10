`timescale 1ns/1ps

module dLatch (
    input wire D,
    input wire E,
    output wire Q
);

    wire D_not;
    wire S, R;
    wire Q_internal, Q_bar_internal;

    // Invert D
    not_gate u1 (.A(D), .Y(D_not));

    // Generate S and R
    and_gate u2 (.A(D),     .B(E), .Y(S));  // S = D & E
    and_gate u3 (.A(D_not), .B(E), .Y(R));  // R = ~D & E

    // Cross-coupled NOR gates (correct orientation!)
    nor_gate u4 (.A(S), .B(Q_internal), .Y(Q_bar_internal)); // Q = ~(S + Q̄)
    nor_gate u5 (.A(R), .B(Q_bar_internal),     .Y(Q_internal)); // Q̄ = ~(R + Q)

    assign Q = Q_internal;

endmodule
