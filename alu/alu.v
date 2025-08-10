`timescale 1ns/1ps

module alu_8bit (
    input  wire [7:0] a,
    input  wire [7:0] b,
    input  wire [2:0] op,      // 3-bit operation selector
    output wire [7:0] result
);

    // Wires for each operation's outputs
    wire [7:0] add_sum;
    wire       add_cout;

    wire [7:0] sub_out;
    wire       sub_cout;

    wire [7:0] inc_out;
    wire       inc_cout;

    wire [7:0] and_out;
    wire [7:0] or_out;
    wire [7:0] xor_out;
    wire [7:0] not_out;
    wire [7:0] zero_out;
    


    // ADD operation
    add8 u_add8 (
        .A(a),
        .B(b),
        .c_in(1'b0),     // no carry-in
        .sum(add_sum),
        .c_out(add_cout)
    );

    // SUB operation
    sub8 u_sub8 (
    .A(a),
    .B(b),
    .diff(sub_out),
    .c_out(sub_cout)
    );

    // AND operation
    and8 u_and8 (
    .a(a),
    .b(b),
    .y(and_out)

    );

    // XOR operation
    xor8 u_xor8(
    .a(a),
    .b(b),
    .y(xor_out)
    );


    // OR operation
    or8 u_or8(
    .a(a),
    .b(b),
    .y(or_out));

    // Not operation
    not8 u_not8(
    .A(a),
    .Y(not_out)

    );

    // Zero operation
    zero8 u_zero8(
      .a(a),
      .y(zero_out)
    );

    //increment operation
    inc8 u_inc8 (
    .A(a),
    .Y(inc_out),
    .c_out(inc_cout)
);



    // 8 parallel mux8s, one for each bit
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : mux_per_bit
            mux8 u_mux8 (
                .in0(add_sum[i]),  // op = 000 → ADD
                .in1(sub_out[i]),  // op = 001 → SUB
                .in2(and_out[i]),  // op = 010 → AND
                .in3(or_out[i]),   // op = 011 → OR
                .in4(xor_out[i]),  // op = 100 → XOR
                .in5(not_out[i]),  // op = 101 → NOT
                .in6(zero_out[i]), // op = 110 → ZERO
                .in7(inc_out[i]),   // op = 111 → INCREMENT A
                .sel(op),
                .y(result[i])
            );
        end
    endgenerate

endmodule
