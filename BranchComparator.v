module BranchComparator(
    input [2:0] funct3,
    input [31:0] src1, src2,
    output reg branch_taken
);
    always @(*) begin
        case (funct3)
            3'b000: branch_taken = (src1 == src2);                  // beq
            3'b001: branch_taken = (src1 != src2);                  // bne
            3'b100: branch_taken = ($signed(src1) < $signed(src2)); // blt
            3'b101: branch_taken = ($signed(src1) >= $signed(src2)); // bge
            3'b110: branch_taken = (src1 < src2);                   // bltu
            3'b111: branch_taken = (src1 >= src2);                  // bgeu
            default: branch_taken = 1'b0;
        endcase
    end
endmodule
