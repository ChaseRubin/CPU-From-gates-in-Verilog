`timescale 1ns/1ps

module dff (
    input wire D,
    input wire clk,
    output wire Q
);

    wire clk_not;
    wire master_out;

    // Invert clk
    not_gate inv_clk (
        .A(clk),
        .Y(clk_not)
    );

    // Master latch: enabled on clk_not
    dLatch master (
        .D(D),
        .E(clk_not),
        .Q(master_out)
    );

    // Slave latch: enabled on clk
    dLatch slave (
        .D(master_out),
        .E(clk),
        .Q(Q)
    );

endmodule
