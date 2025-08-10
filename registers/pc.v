`timescale 1ns/1ps

module pc (
    input  wire        clk,          // Clock
    input  wire        reset,        // Synchronous reset to 0
    input  wire        load,         // Load jump/branch address
    input  wire        enable,       // Increment when high (else hold)
    input  wire [7:0]  load_value,   // Jump/branch target
    output wire [7:0]  pc_out        // Current PC
);
    wire [7:0] pc_plus1;
    wire [7:0] pc_inc_or_hold;
    wire [7:0] pc_next;

    // Incrementer: pc_out + 1
    inc8 pc_incrementer (
        .A(pc_out),
        .Y(pc_plus1),
        .c_out()      // carry not used
    );

    // ---- Hold vs Increment (2:1 mux built from 8x mux2) ----
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : g_hold_inc
            mux2 u_hold_inc (
                .A(pc_out[i]),     // hold
                .B(pc_plus1[i]),   // incremented
                .S(enable),
                .Y(pc_inc_or_hold[i])
            );
        end
    endgenerate

    // ---- Load vs (Hold/Inc) (2:1 mux built from 8x mux2) ----
    generate
        for (i = 0; i < 8; i = i + 1) begin : g_load
            mux2 u_load_mux (
                .A(pc_inc_or_hold[i]), // normal path
                .B(load_value[i]),     // load target
                .S(load),
                .Y(pc_next[i])
            );
        end
    endgenerate

    // PC register (synchronous reset inside reg8)
    reg8 pc_register (
        .D(pc_next),
        .clk(clk),
        .set(1'b0),     // not used for PC
        .reset(reset),
        .Q(pc_out)
    );
endmodule
