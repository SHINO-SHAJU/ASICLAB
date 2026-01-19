`timescale 1ns / 1ps

module tb_booth_mult_radix2_unsigned();

    // Inputs
    reg [7:0] M;
    reg [7:0] Q;

    // Outputs
    wire [15:0] P;
    
    // Expected Result for Verification
    reg [15:0] expected_P;

    // Instantiate the Unit Under Test (UUT)
    booth_mult_radix2_unsigned uut (
        .M_in(M), 
        .Q_in(Q), 
        .P(P)
    );

    initial begin
        $display("------------------------------------------------------------");
        $display("Testing Unsigned Booth Multiplier");
        $display("M\tQ\t|\tProduct\tExpected\tStatus");
        $display("------------------------------------------------------------");

        // --- Case 1: 0, 0 ---
        M = 8'd0; Q = 8'd0;
        expected_P = M * Q;
        #10;
        $display("%d\t%d\t|\t%d\t%d\t\t%s", M, Q, P, expected_P, (P == expected_P) ? "PASS" : "FAIL");

        // --- Case 2: 127, 127 ---
        // (The boundary of signed 8-bit positive range)
        M = 8'd127; Q = 8'd127;
        expected_P = M * Q;
        #10;
        $display("%d\t%d\t|\t%d\t%d\t\t%s", M, Q, P, expected_P, (P == expected_P) ? "PASS" : "FAIL");

        // --- Case 3: Something in between (e.g., 150, 50) ---
        M = 8'd150; Q = 8'd50;
        expected_P = M * Q;
        #10;
        $display("%d\t%d\t|\t%d\t%d\t\t%s", M, Q, P, expected_P, (P == expected_P) ? "PASS" : "FAIL");

        // --- Case 4: 255, 255 ---
        // (The absolute maximum for 8-bit unsigned)
        M = 8'd255; Q = 8'd255;
        expected_P = M * Q;
        #10;
        $display("%d\t%d\t|\t%d\t%d\t\t%s", M, Q, P, expected_P, (P == expected_P) ? "PASS" : "FAIL");

        $display("------------------------------------------------------------");
        $display("Simulation Finished");
        $finish;
    end
      
endmodule