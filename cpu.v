`timescale 1ns/1ps

module cpu (
    input  wire clk,
    input  wire reset
);
    // bus connected to everything, bus can only be driven by one thing at a time
    wire [7:0] bus;

    // PC + ROM + IR
    wire [7:0] pc_out;
    wire [7:0] rom_dout;
    wire       rom_read;

    wire       pc_enable;
    wire       pc_load  = (is_JMP & T1);    // load PC at T1
    wire [7:0] pc_load_value = bus;         // new address comes from bus


    //program counter
    pc u_pc (
        .clk(clk),
        .reset(reset),
        .load(pc_load),
        .enable(pc_enable),
        .load_value(pc_load_value),
        .pc_out(pc_out)
    );

    //read only memory
    rom u_rom (
        .address(pc_out[3:0]),
        .read_en(rom_read),
        .data_out(rom_dout)
    );

    wire       ir_load;
    wire [7:0] IR;

    //instruction register
    ir u_ir (
        .clk(clk),
        .reset(reset),
        .load(ir_load),
        .instr_in(rom_dout),
        .instr_out(IR)
    );


    // Microstep counter T (00->11)
    reg [1:0] T;
    wire T0 = (T == 2'b00);
    wire T1 = (T == 2'b01);
    wire T2 = (T == 2'b10);
    wire T3 = (T == 2'b11);

    always @(posedge clk) begin //ever positive edge checks if reset is high, if not increment T
        if (reset) T <= 2'b00;
        else       T <= T + 2'b01;
    end

    wire [3:0] opcode = IR[7:4]; //the fetched instruction is split into opcode and low nibble
    wire [3:0] low    = IR[3:0];

    // Opcodes
    localparam [3:0] OP_LDI = 4'h1; // 4-bit imm
    localparam [3:0] OP_ADD = 4'h2; //add
    localparam [3:0] OP_SUB = 4'h3; //subtract
    localparam [3:0] OP_AND = 4'h4; //and  
    localparam [3:0] OP_OR  = 4'h5; //or
    localparam [3:0] OP_XOR = 4'h6; //xor
    localparam [3:0] OP_MOV = 4'h7; // move A
    localparam [3:0] OP_NOT = 4'h8; // not (A only)
    localparam [3:0] OP_PSB = 4'h9; // A<=Rn
    localparam [3:0] OP_INC = 4'hA; // increment (A only)
    localparam [3:0] OP_LD8 = 4'hB; // immediate 8
    localparam [3:0] OP_JMP = 4'hC; // jump
    localparam [3:0] OP_HLT = 4'hF; //halt

    //checks if each opcode is recieved and will set that instruction high
    wire is_LDI = (opcode == OP_LDI); 
    wire is_ADD = (opcode == OP_ADD);
    wire is_SUB = (opcode == OP_SUB);
    wire is_AND = (opcode == OP_AND);
    wire is_OR  = (opcode == OP_OR );
    wire is_XOR = (opcode == OP_XOR);
    wire is_MOV = (opcode == OP_MOV);
    wire is_NOT = (opcode == OP_NOT);
    wire is_PSB = (opcode == OP_PSB);
    wire is_INC = (opcode == OP_INC);
    wire is_LD8 = (opcode == OP_LD8);
    wire is_JMP = (opcode == OP_JMP);
    wire is_HLT = (opcode == OP_HLT);
    

    // One-hot decode for R1 to R7
    wire [2:0] n3 = low[2:0];
    wire [7:1] n_oh;
    //one hot outputs:  comparison outputs 1 if the operand selects that register, else 0 
    assign n_oh[1] = (n3 == 3'd1);
    assign n_oh[2] = (n3 == 3'd2);
    assign n_oh[3] = (n3 == 3'd3);
    assign n_oh[4] = (n3 == 3'd4);
    assign n_oh[5] = (n3 == 3'd5);
    assign n_oh[6] = (n3 == 3'd6);
    assign n_oh[7] = (n3 == 3'd7);


    // Accumulator bus A
    wire        acc_load_en; //load from A bus
    wire        acc_out_en; //drive A on to bus
    wire [7:0]  acc_q; //current A value
    wire [7:0]  acc_hold_or_bus; //next value line that will be fed into accumulator

    genvar ai;
    generate
        for (ai = 0; ai < 8; ai = ai + 1) begin : g_acc_mux
            mux2 u_acc_mux (
            .A(acc_q[ai]), //current A bit 
            .B(bus[ai]), // the bit on bus
            .S(acc_load_en), //selcts load from bus or hold
            .Y(acc_hold_or_bus[ai])); //output of each mux
        end
    endgenerate

    reg8 u_acc_reg (
        .D   (acc_hold_or_bus), //this is the A reg 
        .clk (clk),
        .set (1'b0),
        .reset(reset),
        .Q   (acc_q)
    );

    // A drive bus
    genvar ao; 
    generate
        for (ao = 0; ao < 8; ao = ao + 1) begin : g_acc_drive
            bufif1 u_acc_buf (
            bus[ao], //output
            acc_q[ao], //input
            acc_out_en); //enable
        end
    endgenerate

    // GPRs R1->R7 shard bus
    wire [7:1] r_out_en, r_load_en; //drive to / load from the bus enables

    genvar ri;
    generate //generate all 7 general purpose registers
        for (ri = 1; ri <= 7; ri = ri + 1) begin : g_gprs 
            gpr u_gpr (
                .clk     (clk),
                .reset   (reset),
                .load_en (r_load_en[ri]),
                .out_en  (r_out_en[ri]),
                .bus_in  (bus),
                .bus_out (bus)
            );
        end
    endgenerate

    // ALU + B-latch
    wire       b_load = (is_ADD | is_SUB | is_AND | is_OR | is_XOR | is_PSB) & T1;
    wire [7:0] b_q, b_next;

    genvar bi;
    generate
        for (bi = 0; bi < 8; bi = bi + 1) begin : g_bmux
            mux2 u_bmux (
                .A(b_q[bi]),
                .B(bus[bi]), 
                .S(b_load), 
                .Y(b_next[bi]));
        end
    endgenerate

    reg8 u_breg (.D(b_next), .clk(clk), .set(1'b0), .reset(reset), .Q(b_q));

    wire [7:0] alu_a = acc_q;
    wire [7:0] alu_b = b_q;
    wire [2:0] alu_op;
    wire [7:0] alu_y;
    wire       alu_out_en;

    alu_8bit u_alu (.a(alu_a), .b(alu_b), .op(alu_op), .result(alu_y));

    genvar yi;
    generate
        for (yi = 0; yi < 8; yi = yi + 1) begin : g_alu_drive
            bufif1 u_alu_buf (
                bus[yi],
                alu_y[yi],
                alu_out_en);
        end
    endgenerate

    // Immediate drivers

    // LDI imm4 at T1
    wire       imm4_out_en = (is_LDI & T1); //enable for imm val driver
    wire [7:0] imm4_val    = {4'b0000, low}; //concatonate 0000 with low nibble

    genvar ii;
    generate
        for (ii = 0; ii < 8; ii = ii + 1) begin : g_imm4_drive
            bufif1 u_imm4_buf (
            bus[ii], //drive output to shared bus
            imm4_val[ii], //bit to be driven 
            imm4_out_en); //enable bit of the tri state buff
        end
    endgenerate

    // loading full byte
    wire rom_bus_en = ((is_LD8 | is_JMP) & T1); //LD8 or jump is called 

    genvar irb; //index for rom bus
    generate
        for (irb = 0; irb < 8; irb = irb + 1) begin : g_rom_bus_drive
            bufif1 u_rom_buf (
                bus[irb], //drive to shared bus
                rom_dout[irb], //where data is coming from
                rom_bus_en //enable drive
                );
        end
    endgenerate

    // RAM 
    wire [7:0] ram_dout; //read from ram
    ram u_ram (
        .clk      (clk),
        .address  (pc_out[3:0]), //address of instrcuon being fetched
        .write_en (1'b0), //disabled
        .read_en  (1'b0), //disabled
        .data_in  (bus), //data to be written
        .data_out (ram_dout) //data read from ram
    );

    // Control timing: fetch and enable
 
    assign rom_read  = T0 | ((is_LD8 | is_JMP) & T1);

    assign ir_load   = T0; // IR loads only on opcode fetch

    
    assign pc_enable = (T0 & ~is_HLT) | (is_LD8 & T1); // PC increments each T0 and also at T1 for LDI8 to skip the immediate byte

    // Phase flags
    wire bin_t1_driveRn = ((is_ADD | is_SUB | is_AND | is_OR | is_XOR | is_PSB) & T1); //used to set r_out_en[n]

    //result written back into A (binary ops)
    wire add_t2_writeA  = (is_ADD & T2);
    wire sub_t2_writeA  = (is_SUB & T2);
    wire and_t2_writeA  = (is_AND & T2);
    wire or__t2_writeA  = (is_OR  & T2);
    wire xor_t2_writeA  = (is_XOR & T2);
    wire psb_t2_writeA  = (is_PSB & T2);

    //alu result islatched at T2, so A loads then (unary ops)
    wire not_t2_writeA  = (is_NOT & T2); 
    wire inc_t2_writeA  = (is_INC & T2); 

    //same deal at T1
    wire ldi4_t1_writeA = (is_LDI & T1);
    wire ldi8_t1_writeA = (is_LD8 & T1);

    // Rn drives bus at T1 for all binary ops
    assign r_out_en[1] = bin_t1_driveRn & n_oh[1];
    assign r_out_en[2] = bin_t1_driveRn & n_oh[2];
    assign r_out_en[3] = bin_t1_driveRn & n_oh[3];
    assign r_out_en[4] = bin_t1_driveRn & n_oh[4];
    assign r_out_en[5] = bin_t1_driveRn & n_oh[5];
    assign r_out_en[6] = bin_t1_driveRn & n_oh[6];
    assign r_out_en[7] = bin_t1_driveRn & n_oh[7];

    // MOV: A drives bus across T1 & T2; Rn loads at T2
    //copy A’s value into register Rn
    wire mov_t1_driveA  = (is_MOV & T1); //put a value on shared bus
    wire mov_t2_writeRn = (is_MOV & T2); //takes bus value and stores it in rn
    assign acc_out_en   = mov_t1_driveA | mov_t2_writeRn;

    // Rn loads from bus at MOV T2
    assign r_load_en[1] = mov_t2_writeRn & n_oh[1];
    assign r_load_en[2] = mov_t2_writeRn & n_oh[2];
    assign r_load_en[3] = mov_t2_writeRn & n_oh[3];
    assign r_load_en[4] = mov_t2_writeRn & n_oh[4];
    assign r_load_en[5] = mov_t2_writeRn & n_oh[5];
    assign r_load_en[6] = mov_t2_writeRn & n_oh[6];
    assign r_load_en[7] = mov_t2_writeRn & n_oh[7];

    // A writebacks: executing op and at T2
    wire t2_writeA_any = add_t2_writeA | sub_t2_writeA | and_t2_writeA | or__t2_writeA
                       | xor_t2_writeA | psb_t2_writeA | not_t2_writeA | inc_t2_writeA;


    // ALU result is on the bus at T2 or cnst is on bus for T1
    assign acc_load_en = t2_writeA_any | ldi4_t1_writeA | ldi8_t1_writeA; 

    // ALU op select / enable
    localparam [2:0] ALU_ADD  = 3'b000,
                     ALU_SUB  = 3'b001,
                     ALU_AND  = 3'b010,
                     ALU_OR   = 3'b011,
                     ALU_XOR  = 3'b100,
                     ALU_NOT  = 3'b101,
                     ALU_PASSB= 3'b110,
                     ALU_INC  = 3'b111;

    //instruction type flag (unary or binary)
    wire is_bin = (is_ADD | is_SUB | is_AND | is_OR | is_XOR | is_PSB);
    wire is_un  = (is_NOT | is_INC);

    //assigning the alu operation
    assign alu_op =
          is_SUB ? ALU_SUB   :
          is_AND ? ALU_AND   :
          is_OR  ? ALU_OR    :
          is_XOR ? ALU_XOR   :
          is_NOT ? ALU_NOT   :
          is_PSB ? ALU_PASSB :
          is_INC ? ALU_INC   :
                   ALU_ADD;

    assign alu_out_en = ((is_bin | is_un) & T2); //
endmodule
