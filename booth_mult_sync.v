module booth_mult_sync (
    input wire clk,
    input wire rst,
    input wire start,            // Pulse to start multiplication
    input wire [7:0] M_in,       // Unsigned Multiplicand
    input wire [7:0] Q_in,       // Unsigned Multiplier
    output reg [15:0] P,         // Product
    output reg done,             // High when multiplication is complete
    output reg busy              // High during calculation
);

    // Constants
    localparam DATA_WIDTH = 8;
    localparam COUNT_WIDTH = 4;  // Need to count up to 9

    // Internal State Machine
    localparam IDLE = 2'b00;
    localparam CALC = 2'b01;
    localparam FINISH = 2'b10;

    reg [1:0] state;
    
    // Internal Registers (N+1 bits = 9 bits)
    reg signed [DATA_WIDTH:0] A_reg;      
    reg signed [DATA_WIDTH:0] M_reg;      
    reg signed [DATA_WIDTH:0] Q_reg;      
    reg Q_minus_1;                        
    reg [COUNT_WIDTH-1:0] count;          

    // Arithmetic Logic
    reg signed [DATA_WIDTH:0] sum_sub_temp;

    always @(*) begin
        case ({Q_reg[0], Q_minus_1})
            2'b01: sum_sub_temp = A_reg + M_reg; // Add M
            2'b10: sum_sub_temp = A_reg - M_reg; // Subtract M
            default: sum_sub_temp = A_reg;       // No op
        endcase
    end

    // Sequential Logic
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            A_reg <= 0;
            M_reg <= 0;
            Q_reg <= 0;
            Q_minus_1 <= 0;
            count <= 0;
            P <= 0;
            done <= 0;
            busy <= 0;
        end else begin
            case (state)
                IDLE: begin
                    done <= 0;
                    if (start) begin
                        // Load and extend to 9 bits
                        M_reg <= {1'b0, M_in}; 
                        Q_reg <= {1'b0, Q_in};
                        A_reg <= 0;
                        Q_minus_1 <= 0;
                        count <= 0;
                        busy <= 1;
                        state <= CALC;
                    end else begin
                        busy <= 0;
                    end
                end

                CALC: begin
                    if (count < DATA_WIDTH + 1) begin 
                        // Arithmetic Shift Right
                        {A_reg, Q_reg, Q_minus_1} <= $signed({sum_sub_temp, Q_reg, Q_minus_1}) >>> 1;
                        count <= count + 1;
                    end else begin
                        state <= FINISH;
                    end
                end

                FINISH: begin
                    // CORRECTED EXTRACTION:
                    // We need the lower 16 bits.
                    // Q_reg contains the lower 9 bits of the result (including Q[0]).
                    // A_reg contains the upper bits.
                    // We take A[6:0] (7 bits) and Q[8:0] (9 bits) -> 16 bits total.
                    P <= {A_reg[DATA_WIDTH-2:0], Q_reg[DATA_WIDTH:0]};
                    
                    done <= 1;
                    busy <= 0;
                    state <= IDLE;
                end
            endcase
        end
    end

endmodule