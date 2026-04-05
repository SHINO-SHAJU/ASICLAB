`timescale 1ns / 1ps

module vedic_tb;
    reg clk, reset;
    reg [3:0] A, B;
    wire [7:0] product_reg;

    vedic_multiplier_4x4_seq uut (
        .clk(clk), .reset(reset), .A(A), .B(B), .product_reg(product_reg)
    );

    initial begin
        $dumpfile("vedic_sim.vcd");
        $dumpvars(0, vedic_tb);
        clk = 0; reset = 1; A = 0; B = 0;
        #15 reset = 0;

        // Test 1: 5 * 3 = 15
        @(negedge clk); A = 4'd5; B = 4'd3;
        @(posedge clk); #1;
        $display("A=%d, B=%d, Product=%d", A, B, product_reg);

        // Test 2: 12 * 10 = 120
        @(negedge clk); A = 4'd12; B = 4'd10;
        @(posedge clk); #1;
        $display("A=%d, B=%d, Product=%d", A, B, product_reg);

        #20 $finish;
    end

    always #5 clk = ~clk;
endmodule
