`timescale 1ns/1ps

module gpr (
    input  wire       clk,
    input  wire       reset,     // sync reset
    input  wire       load_en,   // load from bus_in when high
    input  wire       out_en,    // drive onto bus when high
    input  wire [7:0] bus_in,
    output wire [7:0] bus_out
);

    wire [7:0] reg_q;       // stored value in reg
    wire [7:0] load_mux;    // mux out going into reg8
    wire [7:0] bus_drv;     // gated output to bus before tri-state


    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin: load_path
            // mux2: A = current reg_q[i], B = bus_in[i], S = load_en
            mux2 u_mux (
                .A(reg_q[i]),
                .B(bus_in[i]),
                .S(load_en),
                .Y(load_mux[i])
            );
        end
    endgenerate

    reg8 u_reg8 (
        .D(load_mux),
        .clk(clk),
        .set(1'b0),   // no synchronous set here
        .reset(reset),
        .Q(reg_q)
    );

    
    generate
        for (i = 0; i < 8; i = i + 1) begin: out_path
            bufif1 u_buf (bus_out[i], reg_q[i], out_en); //connects reg_q[i] to bus_out[i] if out_en = 1, else drives high-Z
        
        end
    endgenerate

endmodule
