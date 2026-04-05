`timescale 1ns / 1ps

module dadda_multiplier_seq_tb;

    // Parameters
    parameter N = 4;
    
    // Inputs
    reg clk;
    reg reset;
    reg signed [N-1:0] A;
    reg signed [N-1:0] B;

    // Outputs
    wire signed [(2*N)-1:0] product_reg;

    // Instantiate the Unit Under Test (UUT)
    dadda_multiplier_seq #(.N(N)) uut (
        .clk(clk),
        .reset(reset),
        .A(A),
        .B(B),
        .product_reg(product_reg)
    );

    // VCD Dumping for EPWave/GTKWave
    initial begin
        $dumpfile("dadda_sim.vcd");
        $dumpvars(0, dadda_multiplier_seq_tb);
    end

    // Clock generation: 100MHz (10ns period)
    initial clk = 0;
    always #5 clk = ~clk;

    // Stimulus process
    initial begin
        // 1. Initialize and Reset
        A = 0; B = 0; reset = 1;
        #15 reset = 0; // Release reset after 1.5 clock cycles

        // 2. Test Case: Positive * Positive (3 * 2 = 6)
        @(negedge clk); A = 4'sd3; B = 4'sd2;
        @(posedge clk); #1; // Wait for the register to latch
        $display("Time=%0t | A=%d, B=%d | Product=%d", $time, A, B, product_reg);

        // 3. Test Case: Negative * Positive (-3 * 4 = -12)
        @(negedge clk); A = -4'sd3; B = 4'sd4;
        @(posedge clk); #1;
        $display("Time=%0t | A=%d, B=%d | Product=%d", $time, A, B, product_reg);

        // 4. Test Case: Negative * Negative (-5 * -2 = 10)
        @(negedge clk); A = -4'sd5; B = -4'sd2;
        @(posedge clk); #1;
        $display("Time=%0t | A=%d, B=%d | Product=%d", $time, A, B, product_reg);

        // 5. Test Case: Max Negative * Max Negative (-8 * -8 = 64)
        @(negedge clk); A = -4'sd8; B = -4'sd8;
        @(posedge clk); #1;
        $display("Time=%0t | A=%d, B=%d | Product=%d", $time, A, B, product_reg);

        // 6. Test Case: Zero multiplication
        @(negedge clk); A = 4'sd0; B = -4'sd7;
        @(posedge clk); #1;
        $display("Time=%0t | A=%d, B=%d | Product=%d", $time, A, B, product_reg);

        #20;
        $finish;
    end
      
endmodule
