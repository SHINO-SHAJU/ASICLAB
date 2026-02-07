`timescale 1ns / 1ps

module tb_booth_mult_sync();

    // Inputs
    reg clk;
    reg rst;
    reg start;
    reg [7:0] M;
    reg [7:0] Q;

    // Outputs
    wire [15:0] P;
    wire done;
    wire busy;

    // Validation
    reg [15:0] expected_P;

    // Instantiate the Unit Under Test (UUT)
    booth_mult_sync uut (
        .clk(clk), 
        .rst(rst), 
        .start(start), 
        .M_in(M), 
        .Q_in(Q), 
        .P(P), 
        .done(done), 
        .busy(busy)
    );

    // Clock Generation (10ns period -> 100MHz)
    always #5 clk = ~clk;

    // --------------------------------------------------------
    // NEW: Timestamp Monitor
    // This block runs automatically whenever 'P' changes value
    // --------------------------------------------------------
    always @(P) begin
        // %t prints simulation time, %0t removes leading zeros
        $display("[Time: %0t ns] Output P updated to: %d", $time, P);
    end

    // Task to perform a single test case
    task run_test;
        input [7:0] in_M;
        input [7:0] in_Q;
        begin
            // 1. Setup Data
            M = in_M;
            Q = in_Q;
            expected_P = M * Q;
            
            // 2. Trigger Start
            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;

            // 3. Wait for Done
            wait(done);
            
            // 4. Check Result
            @(posedge clk); // Wait one cycle to stabilize
            if (P === expected_P) begin
                 $display("RESULT: PASS: %d * %d = %d", M, Q, P);
            end else begin
                 $display("RESULT: FAIL: %d * %d = %d (Expected: %d)", M, Q, P, expected_P);
            end
            $display("------------------------------------------------------------");
        end
    endtask

    initial begin
        // GTKWave Dump (Optional)
        $dumpfile("booth_waveform.vcd");
        $dumpvars(0, tb_booth_mult_sync);

        // Initialize Inputs
        clk = 0;
        rst = 1;
        start = 0;
        M = 0;
        Q = 0;

        // Reset the system
        #20;
        rst = 0;
        #20;

        $display("------------------------------------------------------------");
        $display("Testing Synchronous Booth Multiplier");
        $display("------------------------------------------------------------");

        // --- Test Cases ---
        // Note: P is 0 initially. It will update when calculation finishes.
        
        run_test(8'd10, 8'd20);        
        run_test(8'd127, 8'd127);      
        run_test(8'd255, 8'd1);  
        run_test(8'd15, 8'd100);       

        $display("Simulation Finished");
        $finish;
    end
      
endmodule