module load_reg8 (
    input  wire       clk,
    input  wire       load,
    input  wire [7:0] D,
    output wire [7:0] Q
);
    reg [7:0] d_hold = 8'h00;
    always @(*) begin
        d_hold = D; // combinational pass-through
    end

    reg gated_clk;
    always @(*) gated_clk = clk & load;

    reg8 u_reg8 (
        .D    (d_hold),
        .clk  (gated_clk),
        .set  (1'b0),
        .reset(1'b0),
        .Q    (Q)
    );
endmodule