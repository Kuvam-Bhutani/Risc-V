module EX_MEM_Pipeline_Reg (
    input wire clk,
    input wire reset,
    input wire [31:0] ALUResultE,
    input wire [31:0] WriteDataE,
    input wire [31:0] PCPlus4E,
    input wire [4:0] RdE,
    input wire MemWriteE,
    input wire RegWriteE,
    input wire [1:0] ResultSrcE,
    input wire [31:0] ImmExtE,
    input wire [1:0] MemSizeE,
    input wire [2:0] funct3E,
    
    output reg [31:0] ALUResultM,
    output reg [31:0] WriteDataM,
    output reg [31:0] PCPlus4M,
    output reg [4:0] RdM,
    output reg MemWriteM,
    output reg RegWriteM,
    output reg [1:0] ResultSrcM,
    output reg [31:0] ImmExtM,
    output reg [1:0] MemSizeM,
    output reg [2:0] funct3M
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            ALUResultM <= 32'b0;
            WriteDataM <= 32'b0;
            PCPlus4M <= 32'b0;
            RdM <= 5'b0;
            MemWriteM <= 1'b0;
            RegWriteM <= 1'b0;
            ResultSrcM <= 2'b0;
            ImmExtM <= 32'b0;
            MemSizeM <= 2'b10;
            funct3M <= 3'b0;
        end else begin
            ALUResultM <= ALUResultE;
            WriteDataM <= WriteDataE;
            PCPlus4M <= PCPlus4E;
            RdM <= RdE;
            MemWriteM <= MemWriteE;
            RegWriteM <= RegWriteE;
            ResultSrcM <= ResultSrcE;
            ImmExtM <= ImmExtE;
            MemSizeM <= MemSizeE;
            funct3M <= funct3E;
        end
    end
endmodule
