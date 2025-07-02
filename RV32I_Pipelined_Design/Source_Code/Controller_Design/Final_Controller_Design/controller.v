module controller (
	opD,
	funct3,
	funct7b5,
	ZeroE,
	ResultSrcD,
	MemWriteD,
	PCSrcE,
	ALUSrcD,
	RegWriteD,
	JumpD,
	ImmSrcD,
	ALUControlD,
	DextControlD,
	PCResultSrcD,
	BranchE,
	JumpE,
	BranchD,
	opE_65,
	funct3E
);
	input wire [6:0] opD;
	input wire [1:0] opE_65;
	input wire [2:0] funct3;
	input wire [2:0] funct3E;
	input wire funct7b5;
	input wire ZeroE;
	output wire [2:0] ResultSrcD;
	output wire MemWriteD;
	output reg PCSrcE;
	output wire ALUSrcD;
	output wire RegWriteD;
	output wire JumpD;
	output wire PCResultSrcD;
	output wire [2:0] ImmSrcD;
	output wire [3:0] ALUControlD;
	output wire [2:0] DextControlD;
	input wire BranchE;
	input wire JumpE;
	output wire BranchD;
	
	wire [1:0] ALUOpD;
	maindec md(
		.op(opD),
		.ResultSrcD(ResultSrcD),
		.MemWriteD(MemWriteD),
		.BranchD(BranchD),
		.ALUSrcD(ALUSrcD),
		.RegWriteD(RegWriteD),
		.JumpD(JumpD),
		.ImmSrcD(ImmSrcD),
		.ALUOpD(ALUOpD),
		.PCResultSrcD(PCResultSrcD)
	);
	aludec ad(
		.opb5(opD[5]),
		.funct3(funct3),
		.funct7b5(funct7b5),
		.ALUOpD(ALUOpD),
		.ALUControlD(ALUControlD),
		.DextControlD(DextControlD)
	);

	always @(*) begin
	   	if(opE_65 == 2'b11)
	   	begin
            case (funct3E)
            3'b000: PCSrcE = (BranchE & ZeroE) | JumpE; // Equal
			3'b001: PCSrcE = (BranchE & ~ZeroE) | JumpE; //Not Equal
			3'b100: PCSrcE = (BranchE & ~ZeroE) | JumpE; // Set less than
			3'b110: PCSrcE = (BranchE & ~ZeroE) | JumpE; // Set less than Unsigned
			3'b101: PCSrcE = (BranchE & ZeroE) | JumpE; //set greater than
			3'b111: PCSrcE = (BranchE & ZeroE) | JumpE; //set greater than  
			default: PCSrcE = 0;
            endcase
       	end
       else
            PCSrcE = 0;
	end
	
endmodule
