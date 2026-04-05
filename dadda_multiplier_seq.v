module dadda_multiplier_seq #(parameter N = 4) (
    input clk,
    input reset,
    input signed [N-1:0] A,
    input signed [N-1:0] B,
    output reg signed [(2*N)-1:0] product_reg
);

    wire [N-1:0] p0, p1, p2, p3;
    wire [7:0] p_comb;

    // 1. Partial Product Generation (Baugh-Wooley for Signed)
    assign p0 = {(~(A[3] & B[0])), (A[2] & B[0]), (A[1] & B[0]), (A[0] & B[0])};
    assign p1 = {(~(A[3] & B[1])), (A[2] & B[1]), (A[1] & B[1]), (A[0] & B[1])};
    assign p2 = {(~(A[3] & B[2])), (A[2] & B[2]), (A[1] & B[2]), (A[0] & B[2])};
    assign p3 = {(A[3] & B[3]), (~(A[2] & B[3])), (~(A[1] & B[3])), (~(A[0] & B[3]))};

    // 2. Dadda Reduction Strategy
    // For 4x4, the Dadda sequence is 2, 3, 4. 
    // Since we have 4 rows, we reduce to 3 rows first, then 2 rows.
    
    // Explicitly extending to 8-bits to prevent the "EPWave -6 error"
    wire [7:0] row0 = {4'b0000, p0};
    wire [7:0] row1 = {3'b000, p1, 1'b0};
    wire [7:0] row2 = {2'b00, p2, 2'b00};
    wire [7:0] row3 = {1'b0, p3, 3'b000};
    wire [7:0] bw_const = 8'b10010000; // 2^7 + 2^4

    // In a structural Dadda, you'd use HAs and FAs here. 
    // Behavioral sum for simulation:
    assign p_comb = row0 + row1 + row2 + row3 + bw_const;

    // 3. Sequential Logic
    always @(posedge clk or posedge reset) begin
        if (reset)
            product_reg <= 8'sd0;
        else
            product_reg <= p_comb;
    end

endmodule
