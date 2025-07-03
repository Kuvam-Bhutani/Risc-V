module EX_Stage (
    input wire [31:0] RD1E,        // Read Data 1 from Register File
    input wire [31:0] RD2E,        // Read Data 2 from Register File
    input wire [31:0] PCE,         // Program Counter (PC) at Execute Stage
    input wire [31:0] ImmExtE,     // Immediate value extended
    input wire [3:0] ALUControlE,  // ALU Control Signals
    input wire ALUSrcE,            // ALU Source Select (0: Register, 1: Immediate)
    input wire UsePCEforA_E,
    input wire [1:0] ForwardAE,    // Forwarding control signal for ALU operand A
    input wire [1:0] ForwardBE,    // Forwarding control signal for ALU operand B
    input wire [31:0] ResultW,     // Write-back stage result for forwarding
    input wire [31:0] ALUResultM,  // ALU result from Memory stage for forwarding
    input wire [2:0] funct3E,
    input wire [1:0] ResultSrcE,   // Added to detect LUI
    output wire branch_taken,
    output wire [31:0] ALUResultE, // ALU result for Execute Stage
    output wire ZeroE,             // Zero flag output
    input wire isJalrE,
    output wire [31:0] PCTargetE,  // Computed target PC for branches
    output reg [31:0] WriteDataE   // Forwarded Write Data
);

    // Internal registers
    reg [31:0] SrcAE; // ALU operand A
    reg [31:0] SrcBE; // ALU operand B

    // Forwarding logic for ALU operand A
    always @(*) begin
        if (UsePCEforA_E)
            SrcAE = PCE;           // For AUIPC, use PC as operand A
        else begin
            case (ForwardAE)
                2'b00: SrcAE = RD1E;
                2'b01: SrcAE = ResultW;
                2'b10: SrcAE = ALUResultM;
                default: SrcAE = 32'b0;
            endcase
        end
    end

    // Forwarding logic for WriteDataE (ALU operand B, for stores)
    always @(*) begin
        case (ForwardBE)
            2'b00: WriteDataE = RD2E;
            2'b01: WriteDataE = ResultW;
            2'b10: WriteDataE = ALUResultM;
            default: WriteDataE = 32'b0;
        endcase
    end

    // ALU Source B selection logic
    always @(*) begin
        case (ALUSrcE)
            1'b0: SrcBE = WriteDataE;
            1'b1: SrcBE = ImmExtE;
            default: SrcBE = 32'b0;
        endcase
    end

    // === BEGIN: Branch comparator forwarding fix ===
    reg [31:0] BranchSrcAE, BranchSrcBE;
    always @(*) begin
        case (ForwardAE)
            2'b00: BranchSrcAE = RD1E;
            2'b01: BranchSrcAE = ResultW;
            2'b10: BranchSrcAE = ALUResultM;
            default: BranchSrcAE = RD1E;
        endcase
        case (ForwardBE)
            2'b00: BranchSrcBE = RD2E;
            2'b01: BranchSrcBE = ResultW;
            2'b10: BranchSrcBE = ALUResultM;
            default: BranchSrcBE = RD2E;
        endcase
    end

    BranchComparator branchcmp(
        .funct3(funct3E),
        .src1(BranchSrcAE), // <-- forwarded
        .src2(BranchSrcBE), // <-- forwarded
        .branch_taken(branch_taken)
    );
    // === END: Branch comparator forwarding fix ===

    // Instantiate ALU
    wire [31:0] ALUResultE_internal;
    ALU alu (
        .A(SrcAE),
        .B(SrcBE),
        .ALUControl(ALUControlE),
        .Result(ALUResultE_internal),
        .Zero(ZeroE)
    );

    // For LUI, we bypass the ALU completely and use the immediate value
    // LUI has ResultSrcE = 2'b11 (immediate source)
    assign ALUResultE = (ResultSrcE == 2'b11) ? ImmExtE : ALUResultE_internal;

    assign PCTargetE = isJalrE ? ((SrcAE + ImmExtE) & ~32'b1) : (PCE + ImmExtE);

endmodule
