`timescale 1ns/1ps

module rom_tb;
    reg  [3:0] address;
    reg        read_en;
    wire [7:0] data_out;

    integer i, errors;

    // DEVICE UNDER TEST
    rom uut (
        .address(address),
        .read_en(read_en),
        .data_out(data_out)
    );

    
    reg [7:0] exp [0:15];
    initial begin
        exp[ 0]=8'h10; exp[ 1]=8'h2A; exp[ 2]=8'hA0; exp[ 3]=8'h40;
        exp[ 4]=8'h10; exp[ 5]=8'hF0; exp[ 6]=8'h00; exp[ 7]=8'h00;
        exp[ 8]=8'h00; exp[ 9]=8'h00; exp[10]=8'h00; exp[11]=8'h00;
        exp[12]=8'h00; exp[13]=8'h00; exp[14]=8'h00; exp[15]=8'h00;
    end

    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, rom_tb);

        errors  = 0;
        address = 4'h0;
        read_en = 1'b0;

        // Check tri-state when read_en=0
        #5;
        if (data_out !== 8'bz) begin
            $display("WARN: data_out not Z when read_en=0 at t=%0t: %b", $time, data_out);
        end

        // Read/verify all addresses
        $display("=== ROM Readout ===");
        read_en = 1'b1;
        for (i = 0; i < 16; i = i + 1) begin
            address = i[3:0];
            #5; // allow settle
            $display("addr=%02d (0x%0h) -> got=0x%02h  exp=0x%02h",
                      i, i[3:0], data_out, exp[i]);
            if (data_out !== exp[i]) begin
                errors = errors + 1;
                $display("  FAIL at addr %0d: got 0x%02h exp 0x%02h", i, data_out, exp[i]);
            end
            #5;
        end

        // Back to Z when disabled
        read_en = 1'b0; address = 4'h0; #5;
        if (data_out !== 8'bz) begin
            $display("WARN: data_out not Z after disabling read_en at t=%0t: %b", $time, data_out);
        end

        if (errors == 0) $display("=== PASS: all ROM bytes matched. ===");
        else             $display("=== FAIL: %0d mismatches. ===", errors);

        $finish;
    end
endmodule
