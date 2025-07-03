module Main_Decoder(
    input [6:0] opcode,
    input [2:0] funct3,
    output reg RegWriteD,
    output reg [2:0] ImmSrcD,
    output reg ALUSrcD,
    output reg MemWriteD,
    output reg [1:0] ResultSrcD,
    output reg BranchD,
    output reg [1:0] ALUOpD,
    output reg JumpD,
    output reg UsePCEforA,
    output reg isJalr,
    output reg [1:0] MemSizeD  // 00: byte, 01: halfword, 10: word
);

    always @(*) begin
        // Set safe defaults
        RegWriteD   = 0;
        ImmSrcD     = 3'b000;
        ALUSrcD     = 0;
        MemWriteD   = 0;
        ResultSrcD  = 2'b00;
        BranchD     = 0;
        ALUOpD      = 2'b00;
        JumpD       = 0;
        UsePCEforA  = 0;
        isJalr      = 0;
        MemSizeD    = 2'b10; // Default to word
        
        case(opcode)
            7'b0000011: begin // Load instructions (lw, lh, lb, lhu, lbu)
                RegWriteD   = 1;
                ImmSrcD     = 3'b000;
                ALUSrcD     = 1;
                ResultSrcD  = 2'b01;
                case(funct3)
                    3'b000: MemSizeD = 2'b00; // lb (load byte)
                    3'b001: MemSizeD = 2'b01; // lh (load halfword)
                    3'b010: MemSizeD = 2'b10; // lw (load word)
                    3'b100: MemSizeD = 2'b00; // lbu (load byte unsigned)
                    3'b101: MemSizeD = 2'b01; // lhu (load halfword unsigned)
                    default: MemSizeD = 2'b10;
                endcase
            end
            7'b0100011: begin // Store instructions (sw, sh, sb)
                ImmSrcD     = 3'b001;
                ALUSrcD     = 1;
                MemWriteD   = 1;
                case(funct3)
                    3'b000: MemSizeD = 2'b00; // sb (store byte)
                    3'b001: MemSizeD = 2'b01; // sh (store halfword)
                    3'b010: MemSizeD = 2'b10; // sw (store word)
                    default: MemSizeD = 2'b10;
                endcase
            end
            7'b0110011: begin // R-type
                RegWriteD   = 1;
                ALUOpD      = 2'b10;
            end
            7'b1100011: begin // Branch
                ImmSrcD     = 3'b010;
                BranchD     = 1;
                ALUOpD      = 2'b01;
            end
            7'b0010011: begin // I-type ALU
                RegWriteD   = 1;
                ImmSrcD     = 3'b000;
                ALUSrcD     = 1;
                ALUOpD      = 2'b10;
            end
            7'b1101111: begin // jal
                RegWriteD   = 1;
                ImmSrcD     = 3'b011;
                ResultSrcD  = 2'b10;
                JumpD       = 1;
            end
            7'b1100111: begin // jalr
                RegWriteD   = 1;
                ImmSrcD     = 3'b000;
                ALUSrcD     = 1;
                ResultSrcD  = 2'b10;
                JumpD       = 1;
                isJalr      = 1;
            end
            7'b0110111: begin // lui
                RegWriteD   = 1;
                ImmSrcD     = 3'b100;
                ResultSrcD  = 2'b11;
            end
            7'b0010111: begin // auipc
                RegWriteD   = 1;
                ImmSrcD     = 3'b100;
                ALUSrcD     = 1;
                ResultSrcD  = 2'b00;
                UsePCEforA  = 1;
            end
        endcase
    end

endmodule
