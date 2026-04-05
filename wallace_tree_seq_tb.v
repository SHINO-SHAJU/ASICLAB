// Code your testbench here
// or browse Examples
`timescale 1ns / 1ps

module wallace_tree_seq_tb;

    reg clk;
    reg reset;
    reg signed [3:0] A;
    reg signed [3:0] B;
    wire signed [7:0] product_reg;

    wallace_tree_seq #(.N(4)) uut (
        .clk(clk),
        .reset(reset),
        .A(A),
        .B(B),
        .product_reg(product_reg)
    );

    // VCD Dump
    initial begin
        $dumpfile("wallace_tree_sim.vcd");
        $dumpvars(0, wallace_tree_seq_tb);
    end

    // Clock
    always #5 clk = (clk === 1'b0) ? 1'b1 : 1'b0;

    initial begin
        clk = 0; reset = 1; A = 0; B = 0;
        #20 reset = 0;

        // Test cases
        @(negedge clk); A = 4'sd3;  B = 4'sd4;  // 12
        @(negedge clk); A = -4'sd3; B = 4'sd4;  // -12
        @(negedge clk); A = -4'sd5; B = -4'sd2; // 10
        
        @(posedge clk); #1;
        $display("Final Check: A=%d, B=%d, Product=%d", A, B, product_reg);

        #50 $finish;
    end
endmodule
