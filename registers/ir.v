`timescale 1ns/1ps

// IR: loads instr_in when load=1 on clk edge; holds when load=0
module ir (
    input  wire        clk,
    input  wire        reset,         // synchronous reset to 0
    input  wire        load,          // load enable (fetch)
    input  wire [7:0]  instr_in,      // from instruction memory
    output wire [7:0]  instr_out      // to control unit
);
    wire [7:0] next_instr;

    // Per-bit 2:1 mux: hold current (instr_out) vs load new (instr_in)
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : g_mux
            mux2 u_mux (
                .A(instr_out[i]),     // hold current instruction
                .B(instr_in[i]),      // new instruction
                .S(load),
                .Y(next_instr[i])
            );
        end
    endgenerate

    // Storage
    reg8 u_reg (
        .D(next_instr),
        .clk(clk),
        .set(1'b0),
        .reset(reset),                // synchronous
        .Q(instr_out)
    );
endmodule
