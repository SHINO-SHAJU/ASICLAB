`timescale 1ns/1ps

module tb_booth_dataflow;
    reg  signed [7:0]  M, Q;
    wire signed [15:0] P;

    // Instantiate DUT
    booth_mult_radix2_dataflow dut (
        .M(M),
        .Q(Q),
        .P(P)
    );

    initial begin
        $monitor("Time=%0t | M=%d, Q=%d | P=%d", $time, M, Q, P);

        // Test 1: Positive * Positive (10 * 5 = 50)
        M = 8'sd10; Q = 8'sd5; #10;
        
        // Test 2: Negative * Positive (-12 * 3 = -36)
        M = -8'sd12; Q = 8'sd3; #10;
        
        // Test 3: Positive * Negative (7 * -4 = -28)
        M = 8'sd7; Q = -8'sd4; #10;
        
        // Test 4: Negative * Negative (-8 * -8 = 64)
        M = -8'sd8; Q = -8'sd8; #10;

        $finish;
    end
endmodule