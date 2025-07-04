module ID_EX_Pipeline_Reg (
    input wire clk,
    input wire reset,
    input wire FlushE,
    input wire [2:0] funct3D,
    output reg [2:0] funct3E,
    input wire isJalrD,
    output reg isJalrE,
    input wire [1:0] MemSizeD,
    output reg [1:0] MemSizeE,

    // Standard inputs/outputs
    input wire [31:0] RD1,
    input wire [31:0] RD2,
    input wire [31:0] ImmExtD,
    input wire [31:0] PCPlus4D,
    input wire [4:0] Rs1D,
    input wire [4:0] Rs2D,
    input wire [4:0] RdD,
    input wire [3:0] ALUControlD,
    input wire ALUSrcD,
    input wire MemWriteD,
    input wire RegWriteD,
    input wire [1:0] ResultSrcD,
    input wire BranchD,
    input wire JumpD,
    input wire [31:0] PCD,
    input wire UsePCEforA_D,
    input wire [31:0] InstrD,

    output reg [31:0] RD1E,
    output reg [31:0] RD2E,
    output reg [31:0] ImmExtE,
    output reg [31:0] PCPlus4E,
    output reg [4:0] Rs1E,
    output reg [4:0] Rs2E,
    output reg [4:0] RdE,
    output reg [3:0] ALUControlE,
    output reg ALUSrcE,
    output reg MemWriteE,
    output reg RegWriteE,
    output reg [1:0] ResultSrcE,
    output reg BranchE,
    output reg JumpE,
    output reg [31:0] PCE,
    output reg UsePCEforA_E,
    output reg [31:0] InstrE
);

    always @(posedge clk or posedge reset) begin
        if (reset || FlushE) begin
            RD1E <= 32'b0;
            RD2E <= 32'b0;
            ImmExtE <= 32'b0;
            PCPlus4E <= 32'b0;
            PCE <= 32'b0;
            Rs1E <= 5'b0;
            isJalrE <= 1'b0;
            Rs2E <= 5'b0;
            funct3E <= 3'b0;
            RdE <= 5'b0;
            ALUControlE <= 4'b0;
            ALUSrcE <= 1'b0;
            MemWriteE <= 1'b0;
            RegWriteE <= 1'b0;
            UsePCEforA_E <= 1'b0;
            ResultSrcE <= 2'b0;
            BranchE <= 1'b0;
            JumpE <= 1'b0;
            InstrE <= 32'b0;
            MemSizeE <= 2'b10;
        end else begin
            RD1E <= RD1;
            RD2E <= RD2;
            ImmExtE <= ImmExtD;
            PCPlus4E <= PCPlus4D;
            funct3E <= funct3D;
            Rs1E <= Rs1D;
            Rs2E <= Rs2D;
            UsePCEforA_E <= UsePCEforA_D;
            RdE <= RdD;
            ALUControlE <= ALUControlD;
            ALUSrcE <= ALUSrcD;
            MemWriteE <= MemWriteD;
            RegWriteE <= RegWriteD;
            ResultSrcE <= ResultSrcD;
            BranchE <= BranchD;
            isJalrE <= isJalrD;
            JumpE <= JumpD;
            PCE <= PCD;
            InstrE <= InstrD;
            MemSizeE <= MemSizeD;
        end
    end

endmodule
