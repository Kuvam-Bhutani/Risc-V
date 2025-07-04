`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Testbench for Top_Level pipeline RISC-V processor
//////////////////////////////////////////////////////////////////////////////////

module tb_top_level;
    reg clk;
    reg reset;

    Top_Level uut (
        .clk(clk),
        .reset(reset)
    );

    integer i;

    // Clock generation: 10ns period
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Memory and register initialization
    initial begin
        reset = 1;
        #20;
        reset = 0;

        // Load memories
        $readmemh("instr_mem.mem", uut.if_stage.IMem);
        $readmemh("data_mem.mem", uut.memory_stage.dataMemory);

        // Ensure x0 is always zero
        uut.reg_file.registers[0] = 32'b0;

        // Show loaded instruction memory (nonzero lines)
        $display("\n=== INSTRUCTION MEMORY STATE (Nonzero Words) ===");
        for (i = 0; i < 64; i = i + 1) begin
            if (uut.if_stage.IMem[i] !== 32'b0) begin
                $display("IMem[%0d] (PC: %0h): %h", i, i*4, uut.if_stage.IMem[i]);
            end
        end
        $display("==============================================\n");
    end

    // Simulation duration
    initial begin
        #1000;
        $finish;
    end

    // Report flushes/stalls
    always @(posedge clk) begin
        if (uut.FlushD) $display("[EVENT] IF/ID FLUSH at %0dns", $time);
        if (uut.FlushE) $display("[EVENT] ID/EX FLUSH at %0dns", $time);
        if (uut.StallD) $display("[EVENT] IF/ID STALL at %0dns", $time);
        if (uut.StallF) $display("[EVENT] IF STALL at %0dns", $time);
        if (uut.PCSrcE) $display("[EVENT] BRANCH TAKEN (PCSrcE) at %0dns", $time);
    end

    // Monitor: PC and key pipeline signals, plus pipeline register debug
    always @(posedge clk) begin
        $display("\n======================== Cycle @ %0dns ========================", $time);

        // IF/ID
        $display("[IF/ID] PCD: %h | InstrD: %h | PCPlus4D: %h", uut.PCD, uut.InstrD, uut.PCPlus4D);

        // ID/EX
        $display("[ID/EX] PCE: %h | InstrE: %h | BranchE: %b | JumpE: %b | funct3E: %b", 
            uut.id_ex_pipeline.PCE, uut.id_ex_pipeline.InstrE, uut.id_ex_pipeline.BranchE, uut.id_ex_pipeline.JumpE, uut.id_ex_pipeline.funct3E);
        $display("[ID/EX] Rs1E: %d | Rs2E: %d | RdE: %d | RegWriteE: %b | MemWriteE: %b | ResultSrcE: %b | ALUControlE: %b",
            uut.id_ex_pipeline.Rs1E, uut.id_ex_pipeline.Rs2E, uut.id_ex_pipeline.RdE,
            uut.id_ex_pipeline.RegWriteE, uut.id_ex_pipeline.MemWriteE, uut.id_ex_pipeline.ResultSrcE,
            uut.id_ex_pipeline.ALUControlE);
        $display("[ID/EX] RD1E: %h | RD2E: %h | ImmExtE: %h", 
            uut.id_ex_pipeline.RD1E, uut.id_ex_pipeline.RD2E, uut.id_ex_pipeline.ImmExtE);

        // EX/MEM
        $display("[EX/MEM] ALUResultM: %h | WriteDataM: %h | PCPlus4M: %h | RdM: %d | RegWriteM: %b | MemWriteM: %b | ResultSrcM: %b",
            uut.ex_mem_pipeline_reg.ALUResultM, uut.ex_mem_pipeline_reg.WriteDataM, uut.ex_mem_pipeline_reg.PCPlus4M,
            uut.ex_mem_pipeline_reg.RdM, uut.ex_mem_pipeline_reg.RegWriteM, uut.ex_mem_pipeline_reg.MemWriteM, uut.ex_mem_pipeline_reg.ResultSrcM);

        // MEM/WB
        $display("[MEM/WB] ALUResultW: %h | ReadDataW: %h | PCPlus4W: %h | RdW: %d | RegWriteW: %b | ResultSrcW: %b",
            uut.memwb_pipeline.ALUResultW, uut.memwb_pipeline.ReadDataW, uut.memwb_pipeline.PCPlus4W,
            uut.memwb_pipeline.RdW, uut.memwb_pipeline.RegWriteW, uut.memwb_pipeline.ResultSrcW);
        $display("[MEM/WB] ResultW: %h", uut.ResultW);

        // PC, IF, etc.
        $display("PC (F): %h | InstrF: %h | PCPlus4F: %h", uut.PCF, uut.InstrF, uut.PCPlus4F);

        // Branch signals
        $display("BranchE: %b | branch_taken: %b | PCSrcE: %b", uut.BranchE, uut.branch_taken, uut.PCSrcE);

        // Show all flush/stall signals
        $display("StallF: %b | StallD: %b | FlushD: %b | FlushE: %b", uut.StallF, uut.StallD, uut.FlushD, uut.FlushE);

        // Register file state (x0-x15)
        $display("=== REGISTER FILE STATE ===");
        for (i = 0; i < 16; i = i + 1) begin
            if (uut.reg_file.registers[i] != 0)
                $display("x%0d: %h (%0d)", i, uut.reg_file.registers[i], $signed(uut.reg_file.registers[i]));
        end

        // Info on RegWrite to x8 at each stage
        if (uut.id_ex_pipeline.RegWriteE && uut.id_ex_pipeline.RdE == 8)
            $display(">>> [E] RegWriteE to x8 at %0dns", $time);
        if (uut.ex_mem_pipeline_reg.RegWriteM && uut.ex_mem_pipeline_reg.RdM == 8)
            $display(">>> [M] RegWriteM to x8 at %0dns", $time);
        if (uut.memwb_pipeline.RegWriteW && uut.memwb_pipeline.RdW == 8)
            $display(">>> [W] RegWriteW to x8, ResultW = %h at %0dns", uut.ResultW, $time);

        $display("===============================================================");
    end
endmodule
