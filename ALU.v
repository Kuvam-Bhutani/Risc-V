module ALU (
    input wire [31:0] A,           // ALU operand A
    input wire [31:0] B,           // ALU operand B
    input wire [3:0] ALUControl,   // ALU control signals

    output reg [31:0] Result,      // ALU result
    output reg Zero                // Zero flag
);

    always @(*) begin
        case (ALUControl)
            4'b0000: Result = A + B;                    // ADD/ADDI
            4'b0001: Result = A - B;                    // SUB
            4'b0010: Result = A ^ B;                    // XOR/XORI
            4'b0011: Result = A & B;                    // AND/ANDI
            4'b0100: Result = A | B;                    // OR/ORI
            4'b0101: Result = A << B[4:0];              // SLL/SLLI
            4'b0110: Result = A >> B[4:0];              // SRL/SRLI (logical right)
            4'b0111: Result = $signed(A) >>> B[4:0];    // SRA/SRAI (arithmetic right)
            4'b1000: Result = ($signed(A) < $signed(B)) ? 32'b1 : 32'b0; // SLT/SLTI
            4'b1001: Result = (A < B) ? 32'b1 : 32'b0;                 // SLTU/SLTIU
            default: Result = 32'b0;
        endcase

        Zero = (Result == 32'b0); // Set Zero flag if result is 0
    end

endmodule
