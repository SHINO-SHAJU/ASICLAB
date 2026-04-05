// Code your design here
module baugh_wooley_seq #(parameter N = 4) (
    input clk,
    input reset,
    input signed [N-1:0] A,
    input signed [N-1:0] B,
    output reg signed [(2*N)-1:0] product_reg
);

    wire [(2*N)-1:0] p_wire;
    reg [N-1:0] pp [N-1:0]; // Partial Products array
    integer i, j;

    // Combinatorial Baugh-Wooley Logic
    always @(*) begin
        for (i = 0; i < N; i = i + 1) begin
            for (j = 0; j < N; j = j + 1) begin
                if ((i == N-1 && j < N-1) || (j == N-1 && i < N-1)) begin
                    // Invert partial products involving one sign bit
                    pp[i][j] = ~(A[j] & B[i]);
                end else begin
                    // Normal partial product for others (including sign * sign)
                    pp[i][j] = (A[j] & B[i]);
                end
            end
        end
    end

    // Summing the partial products with the Baugh-Wooley constants
    // Constant: 2^(2N-1) + 2^N (Effectively adding 1 to specific columns)
    assign p_wire = (sum_partial_products(pp)) + (1 << (2*N-1)) + (1 << N);

    // Sequential Logic: Store the result in a register
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            product_reg <= 0;
        end else begin
            product_reg <= p_wire;
        end
    end

    // Helper function to sum partial products (simplified for readability)
    function [(2*N)-1:0] sum_partial_products;
        input [N-1:0] partials [N-1:0];
        integer k;
        begin
            sum_partial_products = 0;
            for (k = 0; k < N; k = k + 1) begin
                sum_partial_products = sum_partial_products + (partials[k] << k);
            end
        end
    endfunction

endmodule
