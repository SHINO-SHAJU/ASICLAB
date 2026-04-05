module wallace_tree_seq #(parameter N = 4) (
    input clk,
    input reset,
    input signed [N-1:0] A,
    input signed [N-1:0] B,
    output reg signed [(2*N)-1:0] product_reg
);

    // Partial Products: We use 1D wires to avoid "unpacked dimension" errors
    wire [N-1:0] p0, p1, p2, p3;
    wire [7:0] p_comb;

    // 1. Generate Partial Products (Baugh-Wooley Signed Logic)
    // p[row][col]
    assign p0 = {(~(A[3] & B[0])), (A[2] & B[0]), (A[1] & B[0]), (A[0] & B[0])};
    assign p1 = {(~(A[3] & B[1])), (A[2] & B[1]), (A[1] & B[1]), (A[0] & B[1])};
    assign p2 = {(~(A[3] & B[2])), (A[2] & B[2]), (A[1] & B[2]), (A[0] & B[2])};
    assign p3 = {(A[3] & B[3]), (~(A[2] & B[3])), (~(A[1] & B[3])), (~(A[0] & B[3]))};

// 2. Wallace Tree Reduction (Explicit Bit-Level Addition)
    // We add the partial products (p0-p3) with their proper shifts
    // Plus the Baugh-Wooley constants: 
    // An extra '1' at the MSB (2^7) and an extra '1' at position 2^4.
    
    wire [7:0] term0 = {4'b0000, p0};        // p0 << 0
    wire [7:0] term1 = {3'b000, p1, 1'b0};   // p1 << 1
    wire [7:0] term2 = {2'b00, p2, 2'b00};   // p2 << 2
    wire [7:0] term3 = {1'b0, p3, 3'b000};   // p3 << 3
    wire [7:0] constant = 8'b10010000;       // 2^7 + 2^4

    assign p_comb = term0 + term1 + term2 + term3 + constant;

    // 3. Sequential Output Register
    always @(posedge clk or posedge reset) begin
        if (reset)
            product_reg <= 8'd0;
        else
            product_reg <= p_comb;
    end

endmodule
