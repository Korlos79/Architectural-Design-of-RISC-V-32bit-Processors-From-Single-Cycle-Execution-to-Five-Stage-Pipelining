module rv32i_pipeline (
	input clk, reset,
	output [31:0] nextPCF_check, PCF_check, InstrF_check, InstrD_check, ImmExtD_check,
	output [4:0] Rs1D_check, Rs2D_check, RdD_check, RdE_check, RdM_check, RdW_check,
	output [31:0] PCD_check, RD1E_check, RD2E_check, SrcAE_check, SrcBE_check, WriteDataE_check,
	output [31:0] PCTargetE_check, //PCTargetM_check,
	output ResultSrcD_check, ResultSrcE_check, ResultSrcM_check, ResultSrcW_check,
	output RegWriteD_check, RegWriteE_check, RegWriteM_check, RegWriteW_check,
	output MemReadD_check, MemReadE_check, MemReadM_check,
	output MemWriteD_check, MemWriteE_check, MemWriteM_check,
	output BranchD_check, BranchE_check,
	output JumpD_check, JumpE_check,
	output MuxjalrD_check, MuxjalrE_check,
	output [3:0] ALUControlD_check, ALUControlE_check,
	output [1:0] ForwardAE_check, ForwardBE_check,
	output Stall_check, Flush_check,
	output [31:0] ALUResultE_check, ALUResultM_check, ReadDataM_check, ResultW_check,
	output [4:0] Rs1E_check, Rs2E_check,
	output [1:0] ALUSrcAD_check, ALUSrcBD_check, ALUSrcAE_check, ALUSrcBE_check,
	output PCSrcE_check, FlagE_check
);





	wire PCSrcE;
	wire [31:0] nextPCF, PCF, PCPlus4F, InstrD, InstrF, PCTargetE, PCD, PCPlus4D;
	
	wire MemReadD, RegWriteD, MemWriteD, JumpD, BranchD, ALUSrcD, MuxjalrD, RegWriteE;
	wire RegWriteW, ResultSrcD;
	wire [2:0] ImmSrc;
	wire [3:0] ALUControlD;
	wire [31:0] RD1D, RD2D, ImmExtD,  ResultW;
	wire [4:0] RdW;
	wire [1:0] ALUSrcAD, ALUSrcBD, ALUSrcAE, ALUSrcBE;
	
	wire Stall, Flush, MemReadE, MemWriteE, JumpE, BranchE, ALUSrcE, MuxjalrE, ResultSrcE;
	wire [2:0] f3E;
	wire [3:0] ALUControlE;
	wire [31:0] RD1E, RD2E, ImmExtE, PCE;
	wire [4:0] Rs1E, Rs2E, RdE;
	
	wire FlagE;
	wire [31:0] SrcAE, SrcBE, ALUResultE, ALUResultM, WriteDataE;
	wire [31:0] AS1; //output mux forwarding A
	wire [1:0] ForwardAE, ForwardBE;
	wire [31:0] PC_RS1;
	
	wire RegWriteM, MemReadM, MemWriteM;
	wire [2:0] f3M;
	wire [31:0] WriteDataM, ReadDataM;
	wire [4:0] RdM;
	
	wire ResultSrcW, ResultSrcM;
	wire [31:0] ALUResultW, ReadDataW;


	//-----------------------IF Stage-------------------------------------------------------------------------------------------
	PC pc (.clk(clk), .en(~Stall), .rst(reset), .addr_in(nextPCF), .addr_out(PCF));
	assign nextPCF = (PCSrcE) ? PCTargetE : PCPlus4F;
	instruction_Mem imem (.addr(PCF), .inst(InstrF));
	assign PCPlus4F = PCF + 4;
	IF_ID_register if_id (.clk(clk), .stall(Stall), .flush(Flush), .instF(InstrF), .PCF(PCF), .instD(InstrD), .rst(reset), 
	.PCD(PCD));
	
	
	//---------------------ID Stage---------------------------------------------------------------------------------------------
	Control_Unit controlunit(
		.funct7(InstrD[31:25]), .opcode(InstrD[6:0]),
		.funct3(InstrD[14:12]),
		.MemReadD(MemReadD), .MemWriteD(MemWriteD), .JumpD(JumpD), .RegWriteD(RegWriteD), .BranchD(BranchD), .MuxjalrD(MuxjalrD),
		.ALUOpD(ALUControlD), .ImmControlD(ImmSrc), .WriteBackD(ResultSrcD), .ALUSrcA_D(ALUSrcAD), .ALUSrcB_D(ALUSrcBD)
	);
	
	rf_32_32 rf (.clk(clk), .reg_write(RegWriteW), .rst(reset), .data_write(ResultW), .wa(RdW), .ra1(InstrD[19:15]), .ra2(InstrD[24:20]), 
	.rd1(RD1D), .rd2(RD2D));
	
	Sign_Extend sign_extend (.inst(InstrD[31:7]), .control(ImmSrc), .imm(ImmExtD));
	
	ID_EX_register id_ex (
		.MemReadD(MemReadD), .MemWriteD(MemWriteD), .ALUSrcAD(ALUSrcAD), .ALUSrcBD(ALUSrcBD), .JumpD(JumpD), .RegWriteD(RegWriteD), .BranchD(BranchD), 
		.MuxjalrD(MuxjalrD), .Stall(1'b0), .clk(clk), .reset(reset), .flush(Flush),
		.ALUOpD(ALUControlD),
		.WriteBackD(ResultSrcD), .funct3D(InstrD[14:12]),
		.RD1D(RD1D), .RD2D(RD2D), .PCD(PCD), 
		.RdD(InstrD[11:7]), .Rs1D(InstrD[19:15]), .Rs2D(InstrD[24:20]),
		.ImmExtD(ImmExtD),
	
		.MemReadE(MemReadE), .MemWriteE(MemWriteE), .ALUSrcAE(ALUSrcAE), .ALUSrcBE(ALUSrcBE), .JumpE(JumpE), .RegWriteE(RegWriteE), .BranchE(BranchE), 
		.MuxjalrE(MuxjalrE),
		.ALUOpE(ALUControlE),
		.WriteBackE(ResultSrcE), .funct3E(f3E),
		.RD1E(RD1E), .RD2E(RD2E), .PCE(PCE), 
		.RdE(RdE), .Rs1E(Rs1E), .Rs2E(Rs2E), 
		.ImmExtE(ImmExtE)
	);
	
	//---------------------EX Stage---------------------------------------------------------------------------------------------
	
	assign PCSrcE = (FlagE && BranchE) || JumpE;
	alu ALU (.A(SrcAE), .B(SrcBE), .opcode(ALUControlE), .branch(f3E), .result(ALUResultE), .Z(FlagE));
	assign AS1 = (ForwardAE==2'b00) ? RD1E :
					(ForwardAE==2'b01) ? ResultW : ALUResultM;
	assign SrcAE = (ALUSrcAE == 2'b00) ? AS1 :
						(ALUSrcAE == 2'b01) ? PCE : 32'd0;
			
	assign SrcBE = (ALUSrcBE == 2'b00) ? WriteDataE:
						(ALUSrcBE == 2'b01) ? ImmExtE: 32'd4;
						
	assign WriteDataE = (ForwardBE==2'b00) ? RD2E :
							  (ForwardBE==2'b01) ? ResultW : ALUResultM;
	assign PC_RS1 = (MuxjalrE) ? AS1 : PCE;
	assign PCTargetE = PC_RS1 + ImmExtE;
	
	EX_M_register ex_m (
		.clk(clk), .rst_n(reset),
		.regWrite_E(RegWriteE), .memWrite_E(MemWriteE), .memRead_E(MemReadE),
		.resultScr_E(ResultSrcE), 
		.alu_rsl_E(ALUResultE),
		.write_Data_E(WriteDataE),  
		.rd_E(RdE),
		.mode_E(f3E), 

		.regWrite_M(RegWriteM), .memWrite_M(MemWriteM), .memRead_M(MemReadM),
		.resultScr_M(ResultSrcM), //write_back_M,
		.alu_rsl_M(ALUResultM),
		.write_Data_M(WriteDataM), 
		.rd_M(RdM),
		.mode_M(f3M)
		);
	
	
	//---------------------MEM Stage---------------------------------------------------------------------------------------------
	
	dmem DMEM (.clk(clk), .we(MemWriteM), .re(MemReadM),  .mode(f3M), .addr(ALUResultM[9:0]), .write_data(WriteDataM), .mem_out(ReadDataM));
	MEM_WB_register mem_wb (
	.RegWriteM(RegWriteM), .clk(clk), .reset(reset),
	.WriteBackM(ResultSrcM),
	.ALUResultM(ALUResultM), .ReadDataM(ReadDataM),
	.RdM(RdM),
	
	.RegWriteW(RegWriteW),
	.WriteBackW(ResultSrcW),
	.ALUResultW(ALUResultW), .ReadDataW(ReadDataW),
	.RdW (RdW)
	);
	
	//---------------------WB Stage---------------------------------------------------------------------------------------------
	assign ResultW = (!ResultSrcW) ? ALUResultW : ReadDataW;
					
	
	//---------------------Control Hazard---------------------------------------------------------------------------------------------
	hazard_unit controlhazard (
		.regWrite_M(RegWriteM),
		.regWrite_W(RegWriteW),
		.PCSrc_E(PCSrcE),
		.resultSrc_E(ResultSrcE),
		.rd_M(RdM),
		.rd_W(RdW),
		.rs1_D(InstrD[19:15]),
		.rs2_D(InstrD[24:20]),
		.rs1_E(Rs1E),
		.rs2_E(Rs2E),
		.rd_E(RdE),
		.forwardAE(ForwardAE),
		.forwardBE(ForwardBE),
		.stall(Stall),
		.flush(Flush)
		);
	
	//--------------------------------------------------------------------------------------------------------------------------------------
	
	assign nextPCF_check = nextPCF;
	assign PCF_check = PCF;
	assign InstrF_check = InstrF;
	assign InstrD_check = InstrD;
	assign ImmExtD_check = ImmExtD;
	assign Rs1D_check = InstrD[19:15];
	assign Rs2D_check = InstrD[24:20];
	assign RdD_check = InstrD[11:7];
	assign PCD_check = PCD;
	assign RD1E_check = RD1E;
	assign RD2E_check = RD2E;
	assign SrcAE_check = SrcAE;
	assign SrcBE_check = SrcBE;
	assign WriteDataE_check = WriteDataE;
	assign RdE_check = RdE;
	assign RdM_check = RdM;
	assign RdW_check = RdW;
	assign PCTargetE_check = PCTargetE;

	assign ResultSrcD_check = ResultSrcD;
	assign ResultSrcE_check = ResultSrcE;
	assign ResultSrcM_check = ResultSrcM;
	assign ResultSrcW_check = ResultSrcW;

	assign RegWriteD_check = RegWriteD;
	assign RegWriteE_check = RegWriteE;
	assign RegWriteM_check = RegWriteM;
	assign RegWriteW_check = RegWriteW;

	assign MemReadD_check = MemReadD;
	assign MemReadE_check = MemReadE;
	assign MemReadM_check = MemReadM;

	assign MemWriteD_check = MemWriteD;
	assign MemWriteE_check = MemWriteE;
	assign MemWriteM_check = MemWriteM;

	assign BranchD_check = BranchD;
	assign BranchE_check = BranchE;

	assign JumpD_check = JumpD;
	assign JumpE_check = JumpE;

	assign ALUSrcAD_check = ALUSrcAD;
	assign ALUSrcBD_check = ALUSrcBD;
	assign ALUSrcAE_check = ALUSrcAE;
	assign ALUSrcBE_check = ALUSrcBE;

	assign MuxjalrD_check = MuxjalrD;
	assign MuxjalrE_check = MuxjalrE;

	assign ALUControlD_check = ALUControlD;
	assign ALUControlE_check = ALUControlE;

	assign ForwardAE_check = ForwardAE;
	assign ForwardBE_check = ForwardBE;

	assign Stall_check = Stall;
	assign Flush_check = Flush;
	
	assign ALUResultE_check = ALUResultE, ALUResultM_check = ALUResultM, ReadDataM_check = ReadDataM, ResultW_check = ResultW; 
	assign Rs1E_check = Rs1E, Rs2E_check = Rs2E;
	
	assign PCSrcE_check = PCSrcE, FlagE_check = FlagE;

endmodule 
