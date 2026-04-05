module vedic_multiplier_4x4_seq (
    input clk,
    input reset,
    input [3:0] A,
    input [3:0] B,
    output reg [7:0] product_reg
);

    wire [3:0] q0, q1, q2, q3;
    wire [7:0] p_comb;
    
    // 1. Four 2x2 Vedic Multipliers (Unsigned)
    assign q0 = A[1:0] * B[1:0]; 
    assign q1 = A[3:2] * B[1:0]; 
    assign q2 = A[1:0] * B[3:2]; 
    assign q3 = A[3:2] * B[3:2]; 

    // 2. Corrected Vedic Addition Stages
    // We must zero-extend everything to 8 bits before adding to prevent overflow.
    wire [7:0] term0 = {4'b0000, q0};           // q0 at LSB
    wire [7:0] term1 = {2'b00, q1, 2'b00};      // q1 shifted left by 2
    wire [7:0] term2 = {2'b00, q2, 2'b00};      // q2 shifted left by 2
    wire [7:0] term3 = {q3, 4'b0000};           // q3 shifted left by 4

    // Final sum of all four quadrants
    assign p_comb = term0 + term1 + term2 + term3;

    // 3. Sequential Register
    always @(posedge clk or posedge reset) begin
        if (reset)
            product_reg <= 8'b0;
        else
            product_reg <= p_comb;
    end

endmodule
