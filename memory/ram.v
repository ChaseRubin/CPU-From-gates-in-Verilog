module ram (
    input  wire        clk,
    input  wire [3:0]  address,
    input  wire        write_en,
    input  wire        read_en,
    input  wire [7:0]  data_in, //byte to store
    output wire [7:0]  data_out //byte to go on bus
);
    wire [15:0] sel, wr_en, rd_en; //write & read enable
    wire [7:0]  reg_out [15:0];

    decoder4to16 dec(.A3(address[3]), .A2(address[2]), .A1(address[1]), .A0(address[0]), .D(sel)); //selects address of ram

    genvar i, b; //generating i and b
    generate
      for (i=0;i<16;i=i+1) begin: mem_block
        and_gate wr_and (.A(write_en), .B(sel[i]), .Y(wr_en[i]));  //outputs high only when requested
        and_gate rd_and (.A(read_en),  .B(sel[i]), .Y(rd_en[i]));

        // write on the real clock, gate with load-enable
        load_reg8 reg_byte ( //load enable register (storage register)
          .clk (clk),
          .load(wr_en[i]), //load enable
          .D   (data_in),
          .Q   (reg_out[i])
        );

        for (b=0;b<8;b=b+1) begin: bit_buf
          tri_buf tbuf (.A(reg_out[i][b]), .EN(rd_en[i]), .Y(data_out[b])); //stored b in mem loc i, enable read, enable, connects to the shared output data bus bit b
        end
      end
    endgenerate
endmodule
