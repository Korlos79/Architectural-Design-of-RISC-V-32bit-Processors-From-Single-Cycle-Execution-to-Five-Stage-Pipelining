module maindec (
	op,
	ResultSrcD,
	MemWriteD,
	BranchD,
	ALUSrcD,
	RegWriteD,
	JumpD,
	ImmSrcD,
	ALUOpD,
	PCResultSrcD
);
	input wire [6:0] op;
	output wire [2:0] ResultSrcD;
	output wire MemWriteD;
	output wire BranchD;
	output wire ALUSrcD;
	output wire RegWriteD;
	output wire JumpD;
	output wire [2:0] ImmSrcD;
	output wire [1:0] ALUOpD;
	output wire PCResultSrcD;
	reg [13:0] controls;
	assign {RegWriteD, ImmSrcD, ALUSrcD, MemWriteD, ResultSrcD, BranchD, ALUOpD, JumpD, PCResultSrcD} = controls;
	always @(*)
		case (op)
			7'b0000011: controls = 14'b10001000100000; //load
			7'b0100011: controls = 14'b00011100000000; //store
			7'b0110011: controls = 14'b1xxx0000001000; //R-Type
			7'b1100011: controls = 14'b00100000010100; //branch
			7'b0010011: controls = 14'b10001000001000; //I-Type
			7'b1101111: controls = 14'b10110001000010; //jal
			7'b1100111: controls = 14'b10001001000011; //jalr
			7'b0010111: controls = 14'b1100x00110xx00; //auip
			7'b0110111: controls = 14'b1100x01000xx00; //lui
			default: controls = 14'bxxxxxxxxxxxxxx;
		endcase
endmodule
