module ID_EX_register (
	input MemReadD, MemWriteD, JumpD, RegWriteD, BranchD, MuxjalrD, Stall, clk, reset, flush, WriteBackD,
	input [3:0] ALUOpD,
	input [2:0]  funct3D,
	input [31:0] RD1D, RD2D, PCD, 
	input [4:0] RdD, Rs1D, Rs2D,
	input [31:0] ImmExtD,
	input [1:0] ALUSrcAD, ALUSrcBD,
	
	output reg MemReadE, MemWriteE, JumpE, RegWriteE, BranchE, MuxjalrE, WriteBackE,
	output reg [3:0] ALUOpE,
	output reg [2:0] funct3E,
	output reg [31:0] RD1E, RD2E, PCE, 
	output reg [4:0] RdE, Rs1E, Rs2E, 
	output reg [31:0] ImmExtE,
	output reg [1:0] ALUSrcAE, ALUSrcBE
);

	always @(posedge clk or negedge reset) begin
		if (~reset) begin
			MemReadE <= 0; MemWriteE <= 0; JumpE <= 0; RegWriteE <= 0; BranchE <= 0; MuxjalrE <= 0;
			ALUOpE <= 4'b0000; WriteBackE <= 0; RD1E <= 32'd0; RD2E <= 32'd0; PCE <= 32'd0;
			RdE <= 5'd0; ImmExtE <= 32'd0; funct3E <= 3'b000; Rs1E <= 5'd0; Rs2E <= 5'd0; ALUSrcAE = 2'd0; ALUSrcBE = 2'd0;
		end
		else if(flush) begin
			MemReadE <= 0; MemWriteE <= 0; JumpE <= 0; RegWriteE <= 0; BranchE <= 0; MuxjalrE <= 0;
			ALUOpE <= 4'b0000; WriteBackE <= 0; RD1E <= 32'd0; RD2E <= 32'd0; PCE <= 32'd0;
			RdE <= 5'd0; ImmExtE <= 32'd0; funct3E <= 3'b000; Rs1E <= 5'd0; Rs2E <= 5'd0; ALUSrcAE = 2'd0; ALUSrcBE = 2'd0;
		end
		else if(!Stall)begin
			MemReadE <= MemReadD;
			MemWriteE <= MemWriteD;
			JumpE <= JumpD;
			RegWriteE <= RegWriteD;
			BranchE <= BranchD;
			MuxjalrE <= MuxjalrD;
			ALUOpE <= ALUOpD;
			WriteBackE <= WriteBackD;
			RD1E <= RD1D; 
			RD2E <= RD2D;
			PCE <= PCD;
			RdE <= RdD;
			ImmExtE <= ImmExtD;
			ALUSrcAE <= ALUSrcAD; 
			ALUSrcBE <= ALUSrcBD;
			funct3E <= funct3D;
			Rs1E <= Rs1D; Rs2E <= Rs2D; 
		end
		else begin
			RegWriteE <= 0; MemWriteE <= 0;
			MemReadE <= MemReadE;
			JumpE <= JumpE;
			BranchE <= BranchE;
			MuxjalrE <= MuxjalrE;
			ALUOpE <= ALUOpE;
			WriteBackE <= WriteBackE;
			RD1E <= RD1E; 
			RD2E <= RD2E;
			PCE <= PCE;
			RdE <= RdE;
			ImmExtE <= ImmExtE;
			funct3E <= funct3E;
			Rs1E <= Rs1E; Rs2E <= Rs2E;
			ALUSrcAE <= ALUSrcAE;
			ALUSrcBE <= ALUSrcBE;
		end
	end
endmodule 



