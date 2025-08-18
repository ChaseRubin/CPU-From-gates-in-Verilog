`timescale 1ns/1ps

module ram_tb;
    reg  [3:0] address;
    reg        write_en;
    reg        read_en;
    reg  [7:0] data_in;
    wire [7:0] data_out;

    integer i;

    // Instantiate
    ram uut (
        .address(address),
        .write_en(write_en),
        .read_en(read_en),
        .data_in(data_in),
        .data_out(data_out)
    );

    initial begin
        $dumpfile("wave.vcd"); 
        $dumpvars(0, ram_tb);

        write_en = 0;
        read_en  = 0;
        address  = 4'b0000;
        data_in  = 8'b00000000;

        // --- Write Phase ---
        $display("=== Writing to RAM ===");
        for (i = 0; i < 16; i = i + 1) begin
            address  = i[3:0];
            data_in  = i + 8'hA0;  
            write_en = 1;
            #10;
            write_en = 0;
            #5;
        end

        // Read Phase 
        $display("\n=== Reading from RAM ===");
        for (i = 0; i < 16; i = i + 1) begin
            address = i[3:0];
            read_en = 1;
            #10;
            $display("Addr %0d -> Data: %h", i, data_out);
            read_en = 0;
            #5;
        end

        $finish;
    end
endmodule
