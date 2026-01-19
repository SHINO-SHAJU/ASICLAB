`timescale 1ns / 1ps

module array_multiplier_8bit (
    input  [7:0] A,
    input  [7:0] B,
    output [15:0] Z
);
    // Flattened wires: 8 rows * 8 columns = 64 bits total
    wire [63:0] p;    // Partial products
    wire [63:0] s;    // Intermediate Sums
    wire [63:0] c;    // Intermediate Carries

    genvar i, j;

    // --- Step 1: Generate all Partial Products (Flattened) ---
    generate
        for (i = 0; i < 8; i = i + 1) begin: row_gen
            for (j = 0; j < 8; j = j + 1) begin: col_gen
                assign p[i*8 + j] = A[j] & B[i];
            end
        end
    endgenerate

    // --- Step 2: Row 0 Logic ---
    assign Z[0] = p[0]; // p[0*8 + 0]
    
    // Initialize first row of sums/carries
    generate
        for (j = 0; j < 8; j = j + 1) begin: row0_init
            assign s[j] = p[j];    // s[0*8 + j]
            assign c[j] = 1'b0;    // c[0*8 + j]
        end
    endgenerate

    // --- Step 3: The Adder Grid (Rows 1 to 7) ---
    generate
        for (i = 1; i < 8; i = i + 1) begin: adder_rows
            for (j = 0; j < 8; j = j + 1) begin: adder_cols
                
                // Indexing math:
                // current bit: [i*8 + j]
                // bit from row above: [(i-1)*8 + j]
                
                wire a_in = p[i*8 + j];
                wire b_in = (j == 7) ? c[(i-1)*8 + j] : s[(i-1)*8 + (j+1)];
                wire cin  = (j == 0) ? 1'b0           : c[i*8 + (j-1)];

                if (j == 0) begin : ha_inst
                    half_adder ha (
                        .a(a_in), 
                        .b(b_in), 
                        .sum(s[i*8 + j]), 
                        .carry(c[i*8 + j])
                    );
                end else begin : fa_inst
                    full_adder fa (
                        .a(a_in), 
                        .b(b_in), 
                        .cin(cin), 
                        .sum(s[i*8 + j]), 
                        .cout(c[i*8 + j])
                    );
                end
            end
            // Output one bit of the product per row
            assign Z[i] = s[i*8 + 0];
        end
    endgenerate

    // --- Step 4: Final Product Bits (MSBs) ---
    // Extracting bits from the final row (row 7)
    generate
        for (j = 1; j < 8; j = j + 1) begin: msb_bits
            assign Z[j+7] = s[7*8 + j];
        end
    endgenerate
    assign Z[15] = c[7*8 + 7];

endmodule

// Helper Modules
module half_adder (input a, b, output sum, carry);
    assign sum = a ^ b;
    assign carry = a & b;
endmodule

module full_adder (input a, b, cin, output sum, cout);
    assign sum = a ^ b ^ cin;
    assign cout = (a & b) | (b & cin) | (a & cin);
endmodule