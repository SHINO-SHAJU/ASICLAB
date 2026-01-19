`timescale 1ns / 1ps

module tb_array_multiplier_8bit();

    // Inputs
    reg [7:0] A;
    reg [7:0] B;

    // Outputs
    wire [15:0] Z;

    // Instantiate the Unit Under Test (UUT)
    array_multiplier_8bit uut (
        .A(A),
        .B(B),
        .Z(Z)
    );

    initial begin
        $display("------------------------------------------------------------");
        $display("Testing Array Multiplier - Unsigned Output Only");
        $display("Time\t\tA\tB\t|\tZ (Product)");
        $display("------------------------------------------------------------");

        // Case 1: 0, 0
        A = 8'd0; B = 8'd0;
        #10;
        $display("%0t\t%d\t%d\t|\t%d", $time, A, B, Z);

        // Case 2: 127, 127
        A = 8'd127; B = 8'd127;
        #10;
        $display("%0t\t%d\t%d\t|\t%d", $time, A, B, Z);

        // Case 3: 150, 50
        A = 8'd150; B = 8'd50;
        #10;
        $display("%0t\t%d\t%d\t|\t%d", $time, A, B, Z);

        // Case 4: 255, 255
        A = 8'd255; B = 8'd255;
        #10;
        $display("%0t\t%d\t%d\t|\t%d", $time, A, B, Z);

        $display("------------------------------------------------------------");
        $display("Simulation Finished");
        $finish;
    end
      
endmodule