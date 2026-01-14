// 8-bit Radix-2 Booth Multiplier (Verilog-2001 Dataflow)
module booth_mult_radix2_dataflow (
    input  signed [7:0]  M, // Multiplicand
    input  signed [7:0]  Q, // Multiplier
    output signed [15:0] P  // Product
);

    // Verilog requires intermediate signals to be declared as wires for dataflow
    // stage[i] stores: [Accumulator(8) | Multiplier(8) | Q_minus_1(1)] = 17 bits
    wire signed [16:0] stage0, stage1, stage2, stage3, stage4, stage5, stage6, stage7, stage8;

    // --- Stage 0: Initialization ---
    assign stage0 = {8'b0, Q, 1'b0};

    // --- Stage 1 ---
    wire signed [7:0] acc1;
    assign acc1 = (stage0[1:0] == 2'b01) ? (stage0[16:9] + M) :
                  (stage0[1:0] == 2'b10) ? (stage0[16:9] - M) :
                   stage0[16:9];
    assign stage1 = $signed({acc1, stage0[8:0]}) >>> 1; // Arithmetic shift

    // --- Stage 2 ---
    wire signed [7:0] acc2;
    assign acc2 = (stage1[1:0] == 2'b01) ? (stage1[16:9] + M) :
                  (stage1[1:0] == 2'b10) ? (stage1[16:9] - M) :
                   stage1[16:9];
    assign stage2 = $signed({acc2, stage1[8:0]}) >>> 1;

    // --- Stage 3 ---
    wire signed [7:0] acc3;
    assign acc3 = (stage2[1:0] == 2'b01) ? (stage2[16:9] + M) :
                  (stage2[1:0] == 2'b10) ? (stage2[16:9] - M) :
                   stage2[16:9];
    assign stage3 = $signed({acc3, stage2[8:0]}) >>> 1;

    // --- Stage 4 ---
    wire signed [7:0] acc4;
    assign acc4 = (stage3[1:0] == 2'b01) ? (stage3[16:9] + M) :
                  (stage3[1:0] == 2'b10) ? (stage3[16:9] - M) :
                   stage3[16:9];
    assign stage4 = $signed({acc4, stage3[8:0]}) >>> 1;

    // --- Stage 5 ---
    wire signed [7:0] acc5;
    assign acc5 = (stage4[1:0] == 2'b01) ? (stage4[16:9] + M) :
                  (stage4[1:0] == 2'b10) ? (stage4[16:9] - M) :
                   stage4[16:9];
    assign stage5 = $signed({acc5, stage4[8:0]}) >>> 1;

    // --- Stage 6 ---
    wire signed [7:0] acc6;
    assign acc6 = (stage5[1:0] == 2'b01) ? (stage5[16:9] + M) :
                  (stage5[1:0] == 2'b10) ? (stage5[16:9] - M) :
                   stage5[16:9];
    assign stage6 = $signed({acc6, stage5[8:0]}) >>> 1;

    // --- Stage 7 ---
    wire signed [7:0] acc7;
    assign acc7 = (stage6[1:0] == 2'b01) ? (stage6[16:9] + M) :
                  (stage6[1:0] == 2'b10) ? (stage6[16:9] - M) :
                   stage6[16:9];
    assign stage7 = $signed({acc7, stage6[8:0]}) >>> 1;

// --- Stage 8 ---
    wire signed [7:0] acc8;
    assign acc8 = (stage7[1:0] == 2'b01) ? (stage7[16:9] + M) :
                  (stage7[1:0] == 2'b10) ? (stage7[16:9] - M) :
                   stage7[16:9];
    assign stage8 = $signed({acc8, stage7[8:0]}) >>> 1;
                  // Final Product: Result is bits 16 down to 1
    assign P = stage8[16:1];

endmodule