module datapath (
	clk,
	reset,
	ResultSrcW,
	PCSrcE,
	ALUSrcE,
	RegWriteW,
	ImmSrcD,
	ALUControlE,
	ZeroE,
	PCF,
	InstrD,
	ALUResultM,
	WriteDataM,
	ReadDataM,
	DextControlE,
	PCResultSrcE,
	Rs1D,
    Rs2D,
    Rs1E,
    Rs2E,
    RdE,
    RdM,
    RdW,
    ForwardAE,
    ForwardBE,
    FlushE,
    StallF,
    StallD,
    FlushD,
    Instr
);
	input wire clk;
	input wire reset;
	input wire [2:0] ResultSrcW;
	input wire PCSrcE;
	input wire ALUSrcE;
	input wire RegWriteW;
	input wire [2:0] ImmSrcD;
	input wire [3:0] ALUControlE;
	output wire ZeroE;
	output wire [31:0] PCF;
	output wire [31:0] InstrD;
	output wire [31:0] ALUResultM;
	output wire [31:0] WriteDataM;
	input wire [31:0] ReadDataM;
	input wire [2:0] DextControlE;
	input wire PCResultSrcE;
    output reg [4:0] Rs1D;
    output reg [4:0] Rs2D;
    output wire [4:0] Rs1E;
    output wire [4:0] Rs2E;
    output wire [4:0] RdE;
    output wire [4:0] RdM;
    output wire [4:0] RdW;
    input wire [1:0] ForwardAE;
    input wire [1:0] ForwardBE;
    input wire FlushE;
    input wire StallF;
    input wire StallD;
    input wire FlushD;
    input wire [31:0] Instr;
    
	wire [31:0] PCNext;
	wire [31:0] PCPlus4F;
	
	//DECODE
	wire [31:0] RD1D;
	wire [31:0] RD2D;
	wire [31:0] PCD;
	wire [31:0] PCPlus4D;
	wire [31:0] ImmExtD;
    reg [4:0] RdD;
	
	always @(*) begin
        Rs1D = InstrD[19:15];
        Rs2D = InstrD[24:20];
        RdD = InstrD[11:7];
	end
	//EXECUTE
	wire [31:0] RD1E;
	wire [31:0] RD2E;
	wire [31:0] ImmExtE;
	wire [31:0] SrcAE;
	wire [31:0] SrcBE;
	wire [31:0] WriteDataE;
    wire [31:0] PCPlus4E;
    wire [31:0] ALUResultE;
    wire [31:0] PCResultE;
    wire [31:0] PCTargetE;
    wire [31:0] PCE;
    	
    //Memory
    wire [2:0] DextControlM;
    wire [31:0] PCPlus4M;
    wire [31:0] TruncResultM;
    wire [31:0] PCTargetM;
    wire [31:0] ImmExtM;
    
    //WRITE
    wire [31:0] TruncResultW;
    wire [31:0] ResultW;
    wire [31:0] PCPlus4W;
    wire [31:0] ALUResultW;
    wire [31:0] PCTargetW;
    wire [31:0] ImmExtW;
	
	flopr #(32) pcreg(
		clk,
		reset,
		StallF,
		PCNext,
		PCF
	);
	adder pcadd4(
		PCF,
		32'd4,
		PCPlus4F
	);
	adder pcaddbranch(
		PCE,
		ImmExtE,
		PCTargetE
	);
	
	mux2 #(32) pcresultmux(
		PCTargetE,
		ALUResultE,
		PCResultSrcE,
		PCResultE
		);
	
	mux2 #(32) pcmux(
		PCPlus4F,
		PCResultE,
		PCSrcE,
		PCNext
	);
	regfile rf(
		.clk(clk),
		.we3(RegWriteW),
		.a1(InstrD[19:15]),
		.a2(InstrD[24:20]),
		.a3(RdW),
		.wd3(ResultW),
		.rd1(RD1D),
		.rd2(RD2D)
	);
	extend ext(
		.instr(InstrD[31:7]),
		.immsrc(ImmSrcD),
		.immext(ImmExtD)
	);
	
	mux3 #(32) fwamux(
		RD1E,
		ResultW,
		ALUResultM,
		ForwardAE,
		SrcAE
	);
	
	mux3 #(32) fwbmux(
		RD2E,
		ResultW,
		ALUResultM,
		ForwardBE,
		WriteDataE
	);
	
	mux2 #(32) srcbmux(
		WriteDataE,
		ImmExtE,
		ALUSrcE,
		SrcBE
	);
	alu alu(
		.SrcA(SrcAE),
		.SrcB(SrcBE),
		.ALUControl(ALUControlE),
		.ALUResult(ALUResultE),
		.Zero(ZeroE)
	);
	mux5 #(32) resultmux(
		ALUResultW,
		TruncResultW,
		PCPlus4W,
		PCTargetW,
		ImmExtW,
		ResultSrcW,
		ResultW
	);
	truncate trunc(
	   .ReadControl(ALUResultM[1:0]),
	   .src(ReadDataM),
	   .result(TruncResultM),
	   .DextControl(DextControlM)
	);
	
	DecodeStageDP decode(
       .clk(clk),
       .reset(reset),
       .PCF(PCF),
       .PCPlus4F(PCPlus4F),
       .Instr(Instr),
       .PCD(PCD),
       .PCPlus4D(PCPlus4D),
       .InstrD(InstrD),
       .StallD(StallD),
       .FlushD(FlushD)
     );
     
     ExecuteStageDP execute(
        .clk(clk),
        .reset(reset),
        .PCD(PCD),
        .PCPlus4D(PCPlus4D),
        .RD1D(RD1D),
        .RD2D(RD2D),
        .Rs1D(Rs1D),
        .Rs2D(Rs2D),
        .RdD(RdD),
        .ImmExtD(ImmExtD),
        .PCE(PCE),
        .PCPlus4E(PCPlus4E),
        .RD1E(RD1E),
        .RD2E(RD2E),
        .Rs1E(Rs1E),
        .Rs2E(Rs2E),
        .RdE(RdE),
        .ImmExtE(ImmExtE),
        .FlushE(FlushE)
    );
    
    MemoryStageDP memory(
        .clk(clk),
        .reset(reset),
        .DextControlE(DextControlE),
        .RdE(RdE),
        .PCPlus4E(PCPlus4E),
        .PCTargetE(PCTargetE),
        .WriteDataE(WriteDataE),
        .ImmExtE(ImmExtE),
        .ALUResultE(ALUResultE),
        .DextControlM(DextControlM),
        .RdM(RdM),
        .PCPlus4M(PCPlus4M),
        .PCTargetM(PCTargetM),
        .WriteDataM(WriteDataM),
        .ImmExtM(ImmExtM),
        .ALUResultM(ALUResultM)
    );
    
    WriteBackStageDP writeback(
        .clk(clk),
        .reset(reset),
        .TruncResultM(TruncResultM),
        .PCPlus4M(PCPlus4M),
        .PCTargetM(PCTargetM),
        .ImmExtM(ImmExtM),
        .ALUResultM(ALUResultM),
        .RdM(RdM),
        .TruncResultW(TruncResultW),
        .PCPlus4W(PCPlus4W),
        .PCTargetW(PCTargetW),
        .ImmExtW(ImmExtW),
        .ALUResultW(ALUResultW),
        .RdW(RdW)
    );
endmodule
