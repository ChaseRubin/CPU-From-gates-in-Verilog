module flags_reg (
    input  wire clk,
    input  wire ld,     // load enable
    input  wire Z_d, N_d, C_d, V_d,
    output reg  Z_q, N_q, C_q, V_q
);
    always @(posedge clk) begin
        if (ld) begin
            Z_q <= Z_d;
            N_q <= N_d;
            C_q <= C_d;
            V_q <= V_d;
        end
    end
endmodule
