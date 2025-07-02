module riscvpipeline (
	clk,
	reset,
	PCF,
	Instr,
	MemWriteM,
	ALUResultM,
	WriteDataM,
	ReadDataM,
	DextControlM,
	StallF,
	FlushE,
	StallD,
	FlushD,
	Rs1D,
	Rs2D,
	Rs1E,
	Rs2E,
	RdE,
	PCSrcE,
	ForwardAE,
	ForwardBE,
	resultSrcE_0,
	RdM,
	RegWriteM,
	RdW,
	RegWriteW,
	ledON
);

	input wire clk;
	input wire reset;
	output wire [31:0] PCF;
	input wire [31:0] Instr;
	output wire MemWriteM;
	output wire [31:0] ALUResultM;
	output wire [31:0] WriteDataM;
	input wire [31:0] ReadDataM;
	output wire [2:0] DextControlM;
	output wire ledON;
	reg ledAux;
	
    //FETCH
	//wire StallF;
	input wire StallF;
	
	//DECODE
	wire ALUSrcD;
	wire RegWriteD;
	wire JumpD;
	wire [2:0] ResultSrcD;
	wire [2:0] ImmSrcD;
	wire [3:0] ALUControlD;
	wire PCResultSrcD;
	wire [2:0] DextControlD;
	wire [31:0] InstrD;
	wire MemWriteD;
	wire BranchD;
	input wire StallD;
	input wire FlushD;
	output wire [4:0] Rs1D;
  output wire [4:0] Rs2D;

	
	//EXECUTE
	wire [1:0] opE_65;
	wire [2:0] funct3E;
	wire ALUSrcE;
	wire RegWriteE;
	wire JumpE;
	wire [2:0] ResultSrcE;
	output wire resultSrcE_0;
	wire [3:0] ALUControlE;
	wire PCResultSrcE;
	output wire PCSrcE;
	wire [2:0] DextControlE;
	wire MemWriteE;
	wire BranchE;
	wire RlushE;
	output wire [4:0] Rs1E;
  output wire [4:0] Rs2E;
  output wire [4:0] RdE;
  wire ZeroE;
	input wire FlushE;
	
	//MEMORY
	output wire RegWriteM;
	wire [2:0] ResultSrcM;
	
	//WRITE
	output wire RegWriteW;
	wire [2:0] ResultSrcW;
	
	output wire [4:0] RdM;
	output wire [4:0] RdW;
	input wire [1:0] ForwardAE;
	input wire [1:0] ForwardBE; 	

	controller c(
		.opD(InstrD[6:0]),
		.funct3(InstrD[14:12]),
		.funct7b5(InstrD[30]),
		.ZeroE(ZeroE),
		.ResultSrcD(ResultSrcD),
		.MemWriteD(MemWriteD),
		.PCSrcE(PCSrcE),
		.ALUSrcD(ALUSrcD),
		.RegWriteD(RegWriteD),
		.JumpD(JumpD),
		.ImmSrcD(ImmSrcD),
		.ALUControlD(ALUControlD),
		.DextControlD(DextControlD),
		.PCResultSrcD(PCResultSrcD),
		.BranchE(BranchE),
		.JumpE(JumpE),
		.BranchD(BranchD),
		.opE_65(opE_65),
	    .funct3E(funct3E)
	);
	datapath dp(
		.clk(clk),
        .reset(reset),
        .ResultSrcW(ResultSrcW),
        .PCSrcE(PCSrcE),
        .ALUSrcE(ALUSrcE),
        .RegWriteW(RegWriteW),
        .ImmSrcD(ImmSrcD),
        .ALUControlE(ALUControlE),
        .ZeroE(ZeroE),
        .PCF(PCF),
        .InstrD(InstrD),
        .ALUResultM(ALUResultM),
        .WriteDataM(WriteDataM),
        .ReadDataM(ReadDataM),
        .DextControlE(DextControlE),
        .PCResultSrcE(PCResultSrcE),
        .Rs1D(Rs1D),
        .Rs2D(Rs2D),
        .Rs1E(Rs1E),
        .Rs2E(Rs2E),
        .RdE(RdE),
        .RdM(RdM),
        .RdW(RdW),
        .ForwardAE(ForwardAE),
        .ForwardBE(ForwardBE),
        .FlushE(FlushE),
        .StallF(StallF),
        .StallD(StallD),
        .FlushD(FlushD),
        .Instr(Instr)
	);
	

	
	ExecuteStageCU execute(
        .clk(clk),
        .reset(reset),
        .ALUSrcD(ALUSrcD),
        .RegWriteD(RegWriteD),
        .JumpD(JumpD),
        .ResultSrcD(ResultSrcD),
        .ALUControlD(ALUControlD),
        .PCResultSrcD(PCResultSrcD),
        .DextControlD(DextControlD),
        .MemWriteD(MemWriteD),
        .BranchD(BranchD),
        .ALUSrcE(ALUSrcE),
        .RegWriteE(RegWriteE),
        .JumpE(JumpE),
        .ResultSrcE(ResultSrcE),
        .ALUControlE(ALUControlE),
        .PCResultSrcE(PCResultSrcE),
        .DextControlE(DextControlE),
        .MemWriteE(MemWriteE),
        .BranchE(BranchE),
        .FlushE(FlushE),
        .opE_65(opE_65),
        .funct3E(funct3E),
        .op(InstrD[6:0]),
        .funct3(InstrD[14:12])
    );
    
    MemoryStageCU memory(
        .clk(clk),
        .reset(reset),
        .RegWriteE(RegWriteE),
        .ResultSrcE(ResultSrcE),
        .DextControlE(DextControlE),
        .MemWriteE(MemWriteE),
        .RegWriteM(RegWriteM),
        .ResultSrcM(ResultSrcM),
        .DextControlM(DextControlM),
        .MemWriteM(MemWriteM)
    );
    
    WriteBackStageCU writeback(
        .clk(clk),
        .reset(reset),
        .RegWriteM(RegWriteM),
        .ResultSrcM(ResultSrcM),
        .RegWriteW(RegWriteW),
        .ResultSrcW(ResultSrcW)
    );
  
	always @(*) begin
	
	   if (MemWriteM)
            if ((ALUResultM === 100) & (WriteDataM === 25)) begin
            ledAux = 1'b1;
       end
       else
            ledAux = 0;
   
	end
	
	assign ledON = ledAux;
	assign resultSrcE_0 = ResultSrcE[0];
	
endmodule
