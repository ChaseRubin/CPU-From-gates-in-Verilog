`timescale 1ns/1ps

module dff_sync_set_reset (
    input wire D,
    input wire clk,
    input wire set,    // synchronous set
    input wire reset,  // synchronous reset
    output wire Q
);
    wire clk_not;
    wire master_out;
    wire slave_in;
    wire not_reset;

    // Invert clock
    not_gate u_not_clk (.A(clk), .Y(clk_not));

    // Invert reset
    not_gate u_not_reset (.A(reset), .Y(not_reset));

    // Master latch (enabled on clk_not)
    dLatch master (
        .D(D),
        .E(clk_not),
        .Q(master_out)
    );

    // --- Reset priority logic ---
    // If reset=1, force slave_in=0
    // Else if set=1, force slave_in=1
    // Else pass master_out

    // Pass master_out only when reset=0 and set=0
    wire normal_path;
    and_gate u_and_normal (.A(not_reset), .B(master_out), .Y(normal_path));

    // Set path: set AND not_reset (reset disables set)
    wire set_term;
    and_gate u_and_set (.A(set), .B(not_reset), .Y(set_term));

    // Combine: set term OR normal path
    or_gate u_or_final (.A(set_term), .B(normal_path), .Y(slave_in));

    // Slave latch (enabled on clk)
    dLatch slave (
        .D(slave_in),
        .E(clk),
        .Q(Q)
    );

endmodule
