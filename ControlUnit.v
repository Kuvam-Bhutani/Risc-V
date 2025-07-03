module ControlUnit(
    input wire [31:0] InstrD,
    output reg RegWriteD,
    output reg MemWriteD,
    output reg [1:0] ResultSrcD,
    output reg [3:0] ALUControlD,
    output reg ALUSrcD,
    output reg BranchD,
    output reg JumpD,
    output reg [2:0] ImmSrcD,
    output reg UsePCEforA,
    output reg isJalr,
    output reg [1:0] MemSizeD    // New: Memory operation size
);

    wire [6:0] opcode = InstrD[6:0];
    wire [2:0] funct3 = InstrD[14:12];
    wire [6:0] funct7 = InstrD[31:25];
    wire [1:0] ALUOpD;

    wire isJalr_internal;
    wire RegWriteD_internal;
    wire [2:0] ImmSrcD_internal;
    wire ALUSrcD_internal;
    wire MemWriteD_internal;
    wire [1:0] ResultSrcD_internal;
    wire BranchD_internal;
    wire JumpD_internal;
    wire [3:0] ALUControlD_internal;
    wire UsePCEforA_internal;
    wire [1:0] MemSizeD_internal;

    Main_Decoder main_decoder (
        .opcode(opcode),
        .funct3(funct3),  // Added funct3 for memory size detection
        .RegWriteD(RegWriteD_internal),
        .ImmSrcD(ImmSrcD_internal),
        .ALUSrcD(ALUSrcD_internal),
        .MemWriteD(MemWriteD_internal),
        .ResultSrcD(ResultSrcD_internal),
        .BranchD(BranchD_internal),
        .ALUOpD(ALUOpD),
        .JumpD(JumpD_internal),
        .UsePCEforA(UsePCEforA_internal),
        .isJalr(isJalr_internal),
        .MemSizeD(MemSizeD_internal)
    );

    ALU_Decoder alu_decoder (
        .ALUOpD(ALUOpD),
        .funct3(funct3),
        .funct7(funct7),
        .ALUControlD(ALUControlD_internal)
    );

    always @(*) begin
        RegWriteD = RegWriteD_internal;
        ImmSrcD = ImmSrcD_internal;
        ALUSrcD = ALUSrcD_internal;
        MemWriteD = MemWriteD_internal;
        ResultSrcD = ResultSrcD_internal;
        BranchD = BranchD_internal;
        JumpD = JumpD_internal;
        ALUControlD = ALUControlD_internal;
        UsePCEforA = UsePCEforA_internal;
        isJalr = isJalr_internal;
        MemSizeD = MemSizeD_internal;
    end

endmodule
