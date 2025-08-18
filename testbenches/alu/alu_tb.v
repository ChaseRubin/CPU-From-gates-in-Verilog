`timescale 1ns/1ps

module alu_tb;

    reg  [7:0] a;
    reg  [7:0] b;
    reg  [2:0] op;
    wire [7:0] result;

    // Instantiate ALU
    alu_8bit uut (
        .a(a),
        .b(b),
        .op(op),
        .result(result)
    );

    integer i;

    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, alu_tb);

        
        a = 8'h0F;  // 00001111
        b = 8'h03;  // 00000011

        $display(" time |   a     b   op  | result");
        $display("------+--------------+--------");

        for (i = 0; i < 8; i = i + 1) begin
            op = i[2:0];
            #10; 
            $display("%4t | %b %b %03b | %b", $time, a, b, op, result);
        end

       
        a = 8'hAA;  // 10101010
        b = 8'h55;  // 01010101

        for (i = 0; i < 8; i = i + 1) begin
            op = i[2:0];
            #10;
            $display("%4t | %b %b %03b | %b", $time, a, b, op, result);
        end

        $finish;
    end

endmodule
