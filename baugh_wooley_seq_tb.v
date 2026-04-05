// Code your testbench here
// or browse Examples
`timescale 1ns / 1ps

module baugh_wooley_seq_tb;

    parameter N = 4;
    
    reg clk;
    reg reset;
    reg signed [N-1:0] A;
    reg signed [N-1:0] B;
    wire signed [(2*N)-1:0] product_reg;

    // Instantiate the Unit Under Test (UUT)
    baugh_wooley_seq #(.N(N)) uut (
        .clk(clk),
        .reset(reset),
        .A(A),
        .B(B),
        .product_reg(product_reg)
    );

    // VCD Generation Block
    initial begin
        $dumpfile("baugh_wooley_test.vcd"); // Name of the output file
        $dumpvars(0, baugh_wooley_seq_tb);  // Dump all variables in this module and below
    end

    // Clock generation (10ns period)
    always #5 clk = (clk === 1'b0) ? 1'b1 : 1'b0;

    initial begin
        // Initialize
        clk = 0;
        reset = 1;
        A = 0;
        B = 0;

        // Release reset after two cycles
        #20 reset = 0;

        // Test Case 1: 3 * 2 = 6
        @(negedge clk); A = 4'sd3; B = 4'sd2;
        @(posedge clk); #1; // Wait for register update
        $display("Time=%0t | A=%d, B=%d | Product=%d", $time, A, B, product_reg);

        // Test Case 2: 5 * -3 = -15
        @(negedge clk); A = 4'sd5; B = -4'sd3;
        @(posedge clk); #1;
        $display("Time=%0t | A=%d, B=%d | Product=%d", $time, A, B, product_reg);

        // Test Case 3: -4 * 2 = -8
        @(negedge clk); A = -4'sd4; B = 4'sd2;
        @(posedge clk); #1;
        $display("Time=%0t | A=%d, B=%d | Product=%d", $time, A, B, product_reg);

        // Test Case 4: -2 * -2 = 4
        @(negedge clk); A = -4'sd2; B = -4'sd2;
        @(posedge clk); #1;
        $display("Time=%0t | A=%d, B=%d | Product=%d", $time, A, B, product_reg);

        #20;
        $finish;
    end
      
endmodule
