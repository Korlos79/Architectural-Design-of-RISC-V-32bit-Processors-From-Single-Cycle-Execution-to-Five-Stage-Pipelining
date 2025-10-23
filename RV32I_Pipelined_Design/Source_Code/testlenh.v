`timescale 1ns/1ps

module testlenh ();
    reg clk, reset;
	wire [31:0] nextPCF_check, PCF_check, InstrF_check, InstrD_check, ImmExtD_check;
	wire [4:0] Rs1D_check, Rs2D_check, RdD_check, RdE_check, RdM_check, RdW_check;
	wire [31:0] PCD_check, RD1E_check, RD2E_check, SrcAE_check, SrcBE_check, WriteDataE_check;
	wire [31:0] PCTargetE_check;
	wire ResultSrcD_check, ResultSrcE_check, ResultSrcM_check, ResultSrcW_check;
	wire RegWriteD_check, RegWriteE_check, RegWriteM_check, RegWriteW_check;
	wire MemReadD_check, MemReadE_check, MemReadM_check;
	wire MemWriteD_check, MemWriteE_check, MemWriteM_check;
	wire BranchD_check, BranchE_check;
	wire JumpD_check, JumpE_check;
	wire MuxjalrD_check, MuxjalrE_check;
	wire [3:0] ALUControlD_check, ALUControlE_check;
	wire [1:0] ForwardAE_check, ForwardBE_check;
	wire Stall_check, Flush_check;
	wire [31:0] ALUResultE_check, ALUResultM_check, ReadDataM_check, ResultW_check;
	wire [4:0] Rs1E_check, Rs2E_check;
	wire [1:0] ALUSrcAD_check, ALUSrcBD_check, ALUSrcAE_check, ALUSrcBE_check;
	wire PCSrcE_check, FlagE_check;

    integer f, i;

    rv32i_pipeline rvp (
		 clk, reset,
	   nextPCF_check, PCF_check, InstrF_check, InstrD_check, ImmExtD_check,
	   Rs1D_check, Rs2D_check, RdD_check, RdE_check, RdM_check, RdW_check,
	   PCD_check, RD1E_check, RD2E_check, SrcAE_check, SrcBE_check, WriteDataE_check,
	   PCTargetE_check, //PCTargetM_check,
	   ResultSrcD_check, ResultSrcE_check, ResultSrcM_check, ResultSrcW_check,
	   RegWriteD_check, RegWriteE_check, RegWriteM_check, RegWriteW_check,
	   MemReadD_check, MemReadE_check, MemReadM_check,
	   MemWriteD_check, MemWriteE_check, MemWriteM_check,
	   BranchD_check, BranchE_check,
	   JumpD_check, JumpE_check,
	   MuxjalrD_check, MuxjalrE_check,
	   ALUControlD_check, ALUControlE_check,
	   ForwardAE_check, ForwardBE_check,
	   Stall_check, Flush_check,
	   ALUResultE_check, ALUResultM_check, ReadDataM_check, ResultW_check,
	   Rs1E_check, Rs2E_check,
	   ALUSrcAD_check, ALUSrcBD_check, ALUSrcAE_check, ALUSrcBE_check,
	   PCSrcE_check, FlagE_check 
    );

    always #50 clk = ~clk;


    initial begin
        clk = 1;
        reset = 0;

        #50 reset = 1;

        #1000;
        f = $fopen("regfile_output.txt", "w");
        for (i = 0; i < 32; i = i + 1)
            $fdisplay(f, "x%0d = 0x%08h", i, rvp.rf.rf[i]);
        $fclose(f);

        #10 $stop;
    end
endmodule