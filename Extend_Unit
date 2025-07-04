module Extend_Unit (
    input wire [31:0] InstrD,    // Instruction from ID stage
    input wire [2:0] ImmSrc,     // Immediate Source signal
    output reg [31:0] ImmExtD    // Extended immediate value
);

    // Extract immediate fields based on instruction type
    wire [11:0] immI = InstrD[31:20];                     // I-type immediate
    wire [11:0] immS = {InstrD[31:25], InstrD[11:7]};     // S-type immediate
    wire [12:0] immB = {InstrD[31], InstrD[7], InstrD[30:25], InstrD[11:8], 1'b0}; // B-type immediate
    wire [20:0] immJ = {InstrD[31], InstrD[19:12], InstrD[20], InstrD[30:21], 1'b0}; // J-type immediate

 always @(*) begin
    case (ImmSrc)
        3'b000: ImmExtD = {{20{immI[11]}}, immI}; // I-type
        3'b001: ImmExtD = {{20{immS[11]}}, immS}; // S-type
        3'b010: ImmExtD = {{19{immB[12]}}, immB}; // B-type
        3'b011: ImmExtD = {{11{InstrD[31]}}, InstrD[31], InstrD[19:12], InstrD[20], InstrD[30:21], 1'b0}; // J-type (jal)
        3'b100: ImmExtD = {InstrD[31:12], 12'b0}; // U-type (lui/auipc)
        default: ImmExtD = 32'b0;
    endcase
end

endmodule
