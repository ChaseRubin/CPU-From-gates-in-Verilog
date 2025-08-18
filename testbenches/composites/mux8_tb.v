`timescale 1ns/1ps

module mux8_tb;

    reg  in0, in1, in2, in3, in4, in5, in6, in7;
    reg  [2:0] sel;
    wire y;
    reg  expected;

    mux8 uut (
        .in0(in0),
        .in1(in1),
        .in2(in2),
        .in3(in3),
        .in4(in4),
        .in5(in5),
        .in6(in6),
        .in7(in7),
        .sel(sel),
        .y(y)
    );

    always @(*) begin
        case (sel)
            3'b000: expected = in0;
            3'b001: expected = in1;
            3'b010: expected = in2;
            3'b011: expected = in3;
            3'b100: expected = in4;
            3'b101: expected = in5;
            3'b110: expected = in6;
            3'b111: expected = in7;
            default: expected = 1'bx;
        endcase
    end

    integer i;
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, mux8_tb);

        in0 = 1'b0;
        in1 = 1'b1;
        in2 = 1'b0;
        in3 = 1'b1;
        in4 = 1'b0;
        in5 = 1'b1;
        in6 = 1'b0;
        in7 = 1'b1;

        $display("sel | y | expected | pass/fail");
        for (i = 0; i < 8; i = i + 1) begin
            sel = i[2:0];
            #10;
            if (y === expected)
                $display("%b   | %b | %b       | PASS", sel, y, expected);
            else
                $display("%b   | %b | %b       | FAIL", sel, y, expected);
        end

        $finish;
    end

endmodule
