module ALU_Decoder(
    input  wire [1:0] ALUOpD,
    input  wire [2:0] funct3,
    input  wire [6:0] funct7,
    output reg  [3:0] ALUControlD
);
// ALUControlD[3:0] mapping
// 4'b0000: ADD/ADDI
// 4'b0001: SUB
// 4'b0010: XOR/XORI
// 4'b0011: AND/ANDI
// 4'b0100: OR/ORI
// 4'b0101: SLL/SLLI
// 4'b0110: SRL/SRLI
// 4'b0111: SRA/SRAI
// 4'b1000: SLT/SLTI
// 4'b1001: SLTU/SLTIU

    always @(*) begin
        case(ALUOpD)
            2'b00: ALUControlD = 4'b0000; // add for lw/sw
            2'b01: ALUControlD = 4'b0001; // sub for branches
            2'b10: begin
                case(funct3)
                    3'b000: begin // ADD/ADDI, SUB
                        if (funct7 == 7'b0100000)
                            ALUControlD = 4'b0001; // SUB
                        else
                            ALUControlD = 4'b0000; // ADD/ADDI
                    end
                    3'b001: ALUControlD = 4'b0101; // SLL/SLLI
                    3'b010: ALUControlD = 4'b1000; // SLT/SLTI
                    3'b011: ALUControlD = 4'b1001; // SLTU/SLTIU
                    3'b100: ALUControlD = 4'b0010; // XOR/XORI
                    3'b101: begin // SRL/SRLI/SRA/SRAI
                        if (funct7 == 7'b0100000)
                            ALUControlD = 4'b0111; // SRA/SRAI
                        else
                            ALUControlD = 4'b0110; // SRL/SRLI
                    end
                    3'b110: ALUControlD = 4'b0100; // OR/ORI
                    3'b111: ALUControlD = 4'b0011; // AND/ANDI
                    default: ALUControlD = 4'b0000;
                endcase
            end
            default: ALUControlD = 4'b0000;
        endcase
    end
endmodule
