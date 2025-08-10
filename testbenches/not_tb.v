module tb_not_gate;

    reg A;
    wire Y;

    // Instantiate the NOT gate
    not_gate uut (
        .A(A),
        .Y(Y)
    );

    initial begin
        
        $monitor("Time=%0t A=%b -> Y=%b", $time, A, Y);

        A = 0;
        #10;
        A = 1;
        #10;
    
    end

endmodule