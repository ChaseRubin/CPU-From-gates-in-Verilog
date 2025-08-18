`timescale 1ns/1ps

module alu_8bit (
    input  wire [7:0] a,
    input  wire [7:0] b,
    input  wire [2:0] op,      // 000 ADD,001 SUB,010 AND,011 OR,100 XOR,101 NOT,110 PASSB,111 INC
    output wire [7:0] result
);
    // Wires for each operation's outputs
    wire [7:0] add_sum;  wire add_cout;
    wire [7:0] sub_out;  wire sub_cout;
    wire [7:0] inc_out;  wire inc_cout;
    wire [7:0] and_out;
    wire [7:0] or_out;
    wire [7:0] xor_out;
    wire [7:0] not_out;
    wire [7:0] passb;

    // ADD
    add8 u_add8 (
        .A(a),
        .B(b),
        .c_in(1'b0),
        .sum(add_sum),
        .c_out(add_cout)
    );

    // SUB
    sub8 u_sub8 (
        .A(a),
        .B(b),
        .diff(sub_out),
        .c_out(sub_cout)
    );

    // AND
    and8 u_and8 (
        .a(a),
        .b(b),
        .y(and_out)
    );

    // OR
    or8 u_or8 (
        .a(a),
        .b(b),
        .y(or_out)
    );

    // XOR
    xor8 u_xor8 (
        .a(a),
        .b(b),
        .y(xor_out)
    );

    // NOT (on A)
    not8 u_not8 (
        .A(a),
        .Y(not_out)
    );

    // INC (A + 1)
    inc8 u_inc8 (
        .A(a),
        .Y(inc_out),
        .c_out(inc_cout)
    );

    // PASSB
    assign passb = b;

    // 8 parallel mux8s, one for each bit
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : mux_per_bit
            mux8 u_mux8 (
                .in0(add_sum[i]),  // 000 → ADD
                .in1(sub_out[i]),  // 001 → SUB
                .in2(and_out[i]),  // 010 → AND
                .in3(or_out[i]),   // 011 → OR
                .in4(xor_out[i]),  // 100 → XOR
                .in5(not_out[i]),  // 101 → NOT(A)
                .in6(passb[i]),    // 110 → PASSB
                .in7(inc_out[i]),  // 111 → INC(A)
                .sel(op),
                .y(result[i])
            );
        end
    endgenerate
endmodule
