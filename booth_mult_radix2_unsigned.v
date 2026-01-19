// 8-bit Unsigned Radix-2 Booth Multiplier (Dataflow)
module booth_mult_radix2_unsigned (
    input  [7:0] M_in, // Unsigned Multiplicand
    input  [7:0] Q_in, // Unsigned Multiplier
    output [15:0] P    // Product
);

    // Internal signals extended to 9 bits to handle unsigned as signed
    wire signed [8:0] M = {1'b0, M_in};
    wire signed [8:0] Q = {1'b0, Q_in};

    // stage[i] stores: [Accumulator(9) | Multiplier(9) | Q_minus_1(1)] = 19 bits
    wire signed [18:0] stage [0:9];

    // --- Stage 0: Initialization ---
    assign stage[0] = {9'b0, Q, 1'b0};

    // --- Generate Stages 1 through 9 ---
    // Using a generate loop for cleaner dataflow (functionally identical to your manual stages)
    genvar i;
    generate
        for (i = 0; i < 9; i = i + 1) begin : multiplier_stages
            wire [8:0] current_acc;
            assign current_acc = (stage[i][1:0] == 2'b01) ? (stage[i][18:10] + M) :
                                 (stage[i][1:0] == 2'b10) ? (stage[i][18:10] - M) :
                                  stage[i][18:10];
            
            // Arithmetic shift right (>>>) maintains the logic for Booth
            assign stage[i+1] = $signed({current_acc, stage[i][9:0]}) >>> 1;
        end
    endgenerate

    // Final Product: Result is extracted from the final stage
    // For 8x8 unsigned, the result fits in 16 bits.
    assign P = stage[9][16:1];

endmodule