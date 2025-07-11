`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 22.05.2025 00:13:20
// Design Name: 
// Module Name: top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Top_Level(
    input wire clk,             
    input wire reset            
);

    // IF Stage Signals
    wire [31:0] PCF, InstrF, PCPlus4F;
    wire StallF;

    // ID Stage Signals
    wire [31:0] PCD, InstrD, PCPlus4D, ImmExtD, RD1D, RD2D;
    wire StallD, FlushD;
    wire [4:0] Rs1D, Rs2D, RdD;
    wire RegWriteD, MemWriteD, ALUSrcD, BranchD, JumpD;
    wire [3:0] ALUControlD;
    wire [1:0] ResultSrcD;
    wire [2:0] ImmSrcD;
    wire isJalrD;
    wire [1:0] MemSizeD;

    // EX Stage Signals
    wire [31:0] PCE, PCPlus4E, RD1E, RD2E, ImmExtE, PCTargetE, ALUResultE, WriteDataE;
    wire [4:0] Rs1E, Rs2E, RdE;
    wire RegWriteE, MemWriteE, ALUSrcE, BranchE, JumpE, ZeroE, PCSrcE;
    wire [3:0] ALUControlE;
    wire [1:0] ResultSrcE, ForwardAE, ForwardBE;
    wire FlushE;
    wire isJalrE;
    wire [1:0] MemSizeE;

    // MEM Stage Signals
    wire [31:0] PCPlus4M, ALUResultM, WriteDataM, ReadDataM;
    wire [4:0] RdM;
    wire RegWriteM, MemWriteM;
    wire [1:0] ResultSrcM;
    wire [1:0] MemSizeM;
    wire [2:0] funct3M;

    // WB Stage Signals
    wire [31:0] PCPlus4W, ALUResultW, ReadDataW, ResultW;
    wire [4:0] RdW;
    wire RegWriteW;
    wire [1:0] ResultSrcW;
    wire [31:0] ImmExtM, ImmExtW;

    wire UsePCEforA_D, UsePCEforA_E;
    wire [2:0] funct3D, funct3E;
    assign funct3D = InstrD[14:12];
    wire branch_taken;
    
    // IF Stage
    IF_Stage if_stage (
        .clk(clk),
        .reset(reset),
        .StallF(StallF),
        .PCSrcE(PCSrcE),
        .PCTargetE(PCTargetE),
        .InstrF(InstrF),
        .PCF(PCF),
        .PCPlus4F(PCPlus4F)
    );

    // IF/ID Pipeline Register
    IF_ID_Pipeline_Reg if_id_reg (
        .clk(clk),
        .reset(reset),
        .FlushD(FlushD),
        .StallD(StallD),
        .PCF(PCF),
        .InstrF(InstrF),
        .PCPlus4F(PCPlus4F),
        .PCD(PCD),
        .InstrD(InstrD),
        .PCPlus4D(PCPlus4D)
    );

    // Control Unit
 ControlUnit control_unit (
        .InstrD(InstrD),
        .RegWriteD(RegWriteD),
        .MemWriteD(MemWriteD),
        .ResultSrcD(ResultSrcD),
        .ALUControlD(ALUControlD),
        .UsePCEforA(UsePCEforA_D),
        .ALUSrcD(ALUSrcD),
        .BranchD(BranchD),
        .JumpD(JumpD),
        .isJalr(isJalrD),
        .ImmSrcD(ImmSrcD),
        .MemSizeD(MemSizeD)
    );
    // Extract register addresses
    assign Rs1D = InstrD[19:15];
    assign Rs2D = InstrD[24:20];
    assign RdD  = InstrD[11:7];

    // Extend Unit
    Extend_Unit extend_unit (
        .InstrD(InstrD),
        .ImmSrc(ImmSrcD),
        .ImmExtD(ImmExtD)
    );

    // Register File
    Register_File reg_file (
        .clk(clk),
        .reset(reset),
        .RegWriteW(RegWriteW),
        .rs1(Rs1D),
        .rs2(Rs2D),
        .rd(RdW),
        .ResultW(ResultW),
        .RD1(RD1D),
        .RD2(RD2D)
    );

    // Hazard Unit
    Hazard_Unit hazard_unit (
        .Rs1D(Rs1D),
        .Rs2D(Rs2D),
        .Rs1E(Rs1E),
        .Rs2E(Rs2E),
        .RdE(RdE),
        .RdM(RdM),
        .RdW(RdW),
        .RegWriteM(RegWriteM),
        .RegWriteW(RegWriteW),
        .RegWriteE(RegWriteE),
        .ResultSrcE(ResultSrcE),
        .PCSrcE(PCSrcE),
        .StallF(StallF),
        .StallD(StallD),
        .FlushD(FlushD),
        .FlushE(FlushE),
        .ForwardAE(ForwardAE),
        .ForwardBE(ForwardBE)
    );

    // ID/EX Pipeline Register - FIXED: Added missing connections
    ID_EX_Pipeline_Reg id_ex_pipeline (
        .clk(clk),
        .reset(reset),
        .FlushE(FlushE),          
        .RD1(RD1D),
        .RD2(RD2D),
        .PCD(PCD),
        .isJalrD(isJalrD),
        .isJalrE(isJalrE),
        .funct3D(funct3D),
        .funct3E(funct3E),
        .ImmExtD(ImmExtD),
        .PCPlus4D(PCPlus4D),
        .UsePCEforA_D(UsePCEforA_D),
        .UsePCEforA_E(UsePCEforA_E),
        .Rs1D(Rs1D),
        .Rs2D(Rs2D),
        .RdD(RdD),
        .ALUControlD(ALUControlD),
        .ALUSrcD(ALUSrcD),
        .MemWriteD(MemWriteD),
        .RegWriteD(RegWriteD),
        .ResultSrcD(ResultSrcD),
        .BranchD(BranchD),
        .JumpD(JumpD),
        .InstrD(InstrD),
        .MemSizeD(MemSizeD),
        .RD1E(RD1E),
        .RD2E(RD2E),
        .PCE(PCE),
        .ImmExtE(ImmExtE),
        .PCPlus4E(PCPlus4E),
        .Rs1E(Rs1E),
        .Rs2E(Rs2E),
        .RdE(RdE),
        .ALUControlE(ALUControlE),
        .ALUSrcE(ALUSrcE),
        .MemWriteE(MemWriteE),
        .RegWriteE(RegWriteE),
        .ResultSrcE(ResultSrcE),
        .BranchE(BranchE),
        .JumpE(JumpE),
        .MemSizeE(MemSizeE)
    );

    // EX Stage - FIXED: Added missing ResultSrcE connection
    EX_Stage ex_stage (
        .RD1E(RD1E),
        .RD2E(RD2E),
        .PCE(PCE),
        .isJalrE(isJalrE),
        .ImmExtE(ImmExtE),
        .ALUControlE(ALUControlE),
        .ALUSrcE(ALUSrcE),
        .ForwardAE(ForwardAE),
        .ForwardBE(ForwardBE),
        .funct3E(funct3E),
        .ResultSrcE(ResultSrcE), // FIXED: Added missing connection for LUI detection
        .ResultW(ResultW),
        .ALUResultM(ALUResultM),
        .ALUResultE(ALUResultE),
        .ZeroE(ZeroE),
        .PCTargetE(PCTargetE),
        .WriteDataE(WriteDataE),
        .UsePCEforA_E(UsePCEforA_E),
        .branch_taken(branch_taken)
    );

    assign PCSrcE = (BranchE & branch_taken) | JumpE;
 
    // EX/MEM Pipeline Register - FIXED
   EX_MEM_Pipeline_Reg ex_mem_pipeline_reg (
        .clk(clk),
        .reset(reset),
        .ALUResultE(ALUResultE),
        .WriteDataE(WriteDataE),
        .PCPlus4E(PCPlus4E),
        .RdE(RdE),
        .MemWriteE(MemWriteE),
        .RegWriteE(RegWriteE),
        .ResultSrcE(ResultSrcE),
        .ALUResultM(ALUResultM),
        .WriteDataM(WriteDataM),
        .PCPlus4M(PCPlus4M),
        .RdM(RdM),
        .MemWriteM(MemWriteM),
        .RegWriteM(RegWriteM),
        .ResultSrcM(ResultSrcM),
        .ImmExtE(ImmExtE),
        .ImmExtM(ImmExtM),
        .MemSizeE(MemSizeE),
        .MemSizeM(MemSizeM),
        .funct3E(funct3E),
        .funct3M(funct3M)
    );
    // MEM Stage
     MemoryStage memory_stage (
        .clk(clk),
        .MemWriteM(MemWriteM),
        .ALUResultM(ALUResultM),
        .WriteDataM(WriteDataM),
        .MemSizeM(MemSizeM),
        .funct3M(funct3M),
        .ReadDataM(ReadDataM)
    );
    // MEM/WB Pipeline Register
    MEM_WB_Pipeline memwb_pipeline (
        .clk(clk),
        .reset(reset),
        .RegWriteM(RegWriteM),
        .ResultSrcM(ResultSrcM),
        .ReadDataM(ReadDataM),
        .ALUResultM(ALUResultM),
        .PCPlus4M(PCPlus4M),
        .RdM(RdM),
        .RegWriteW(RegWriteW),
        .ResultSrcW(ResultSrcW),
        .ReadDataW(ReadDataW),
        .ALUResultW(ALUResultW),
        .PCPlus4W(PCPlus4W),
        .RdW(RdW),
        .ImmExtM(ImmExtM),
        .ImmExtW(ImmExtW)
    );

    // WB Stage
    WBStage wb_stage (
        .ResultSrcW(ResultSrcW),
        .ReadDataW(ReadDataW),
        .ALUResultW(ALUResultW),
        .PCPlus4W(PCPlus4W),
        .ResultW(ResultW),
        .ImmExtW(ImmExtW)
    );

endmodule
