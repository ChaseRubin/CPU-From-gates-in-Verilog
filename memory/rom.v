`timescale 1ns/1ps

module rom (
    input  wire [3:0] address,
    input  wire       read_en,
    output wire [7:0] data_out
);
    wire [15:0] sel;
    wire [7:0]  rom_data [0:15];
    wire [15:0] rd_en;

    decoder4to16 dec (
        .A3(address[3]), .A2(address[2]),
        .A1(address[1]), .A0(address[0]),
        .D(sel)
    );

    // 0: A=5; R1=5; A=2; A=A+R1 (=7); JMP -> 0x0A
assign rom_data[0]  = 8'b10100000; // [00] 0x15 : LDI   A,#5        ; A = 5
assign rom_data[1]  = 8'b10100000; // [01] 0x71 : MOV   R1,A        ; R1 = 5
assign rom_data[2]  = 8'b10100000; // [02] 0xB0 : LDI8  A,#imm8     ; two-byte: next byte is imm8
assign rom_data[3]  = 8'b10100000; // [03] 0x0A : (imm8)            ; A = 10
assign rom_data[4]  = 8'b10100000; // [04] 0x21 : ADD   A,R1        ; A = 10 + 5 = 15
assign rom_data[5]  = 8'b10100000; // [05] 0xC0 : JMP   #imm8       ; jump to address in next byte
assign rom_data[6]  = 8'b10100000; // [06] 0x0A : (target)          ; PC <- 0x0A

// 7–9: these will be SKIPPED by the jump (filler / not executed)
assign rom_data[7]  = 8'b10100000; // [07] 0x41 : AND   A,R1        ; (skipped)
assign rom_data[8]  = 8'b10100000; // [08] 0x51 : OR    A,R1        ; (skipped)
assign rom_data[9]  = 8'b10100000; // [09] 0x80 : NOT   A           ; (skipped)

// 10+: land here after JMP
assign rom_data[10] = 8'b10100000; // [0A] 0x72 : MOV   R2,A        ; R2 = A (=15)
assign rom_data[11] = 8'b10100000; // [0B] 0xA0 : INC   A           ; A = A + 1 = 16
assign rom_data[12] = 8'b10100000; // [0C] 0x62 : XOR   A,R2        ; A = 16 ^ 15 = 31
assign rom_data[13] = 8'b10100000; // [0D] 0x91 : PASSB A,R1        ; A = R1 = 5
assign rom_data[14] = 8'b10100000; // [0E] 0x17 : LDI   A,#7        ; A = 7
assign rom_data[15] = 8'hF0; // [0F] 0xF0 : HLT               ; stop

    genvar i,b;
    generate
        for (i=0; i<16; i=i+1) begin : rom_addr
            and_gate rd_and (.A(read_en), .B(sel[i]), .Y(rd_en[i]));
            for (b=0; b<8; b=b+1) begin : rom_bit
                bufif1 tbuf (data_out[b], rom_data[i][b], rd_en[i]);
            end
        end
    endgenerate
endmodule
