module MemoryStage(
    input wire clk,
    input wire MemWriteM,
    input wire [31:0] ALUResultM,
    input wire [31:0] WriteDataM,
    input wire [1:0] MemSizeM,    // 00: byte, 01: halfword, 10: word
    input wire [2:0] funct3M,     // For signed/unsigned loads
    output reg [31:0] ReadDataM
);

    parameter MEM_SIZE = 16384;
    reg [7:0] dataMemory [0:MEM_SIZE*4-1]; // Byte-addressable memory
    wire [31:0] byteAddress = ALUResultM;
    
    // Initialize memory
    integer i;
    initial begin
        for (i = 0; i < MEM_SIZE*4; i = i + 1) begin
            dataMemory[i] = 8'b0;
        end
    end

    // Read logic - FIXED
    always @(*) begin
        case (MemSizeM)
            2'b00: begin // Byte operations
                case (funct3M)
                    3'b000: // lb (signed byte)
                        ReadDataM = {{24{dataMemory[byteAddress][7]}}, dataMemory[byteAddress]};
                    3'b100: // lbu (unsigned byte)
                        ReadDataM = {24'b0, dataMemory[byteAddress]};
                    default:
                        ReadDataM = {24'b0, dataMemory[byteAddress]};
                endcase
            end
            2'b01: begin // Halfword operations - FIXED
                // Proper little-endian halfword read
                case (funct3M)
                    3'b001: begin // lh (signed halfword)
                        ReadDataM = {{16{dataMemory[byteAddress+1][7]}}, 
                                   dataMemory[byteAddress+1], dataMemory[byteAddress]};
                    end
                    3'b101: begin // lhu (unsigned halfword)  
                        ReadDataM = {16'b0, dataMemory[byteAddress+1], dataMemory[byteAddress]};
                    end
                    default: begin
                        ReadDataM = {16'b0, dataMemory[byteAddress+1], dataMemory[byteAddress]};
                    end
                endcase
            end
            2'b10: begin // Word operations
                // Little-endian word read
                ReadDataM = {dataMemory[byteAddress+3], dataMemory[byteAddress+2], 
                           dataMemory[byteAddress+1], dataMemory[byteAddress]};
            end
            default: ReadDataM = 32'b0;
        endcase
    end

    // Write logic - FIXED
    always @(posedge clk) begin
        if (MemWriteM) begin
            case (MemSizeM)
                2'b00: begin // sb (store byte)
                    dataMemory[byteAddress] <= WriteDataM[7:0];
                end
                2'b01: begin // sh (store halfword) - FIXED
                    // Little-endian halfword write
                    dataMemory[byteAddress] <= WriteDataM[7:0];
                    dataMemory[byteAddress+1] <= WriteDataM[15:8];
                end
                2'b10: begin // sw (store word)
                    // Little-endian word write
                    dataMemory[byteAddress] <= WriteDataM[7:0];
                    dataMemory[byteAddress+1] <= WriteDataM[15:8];
                    dataMemory[byteAddress+2] <= WriteDataM[23:16];
                    dataMemory[byteAddress+3] <= WriteDataM[31:24];
                end
            endcase
        end
    end

endmodule
