module Control_Unit (
	input [6:0] funct7, opcode,
	input [2:0] funct3,
	output reg MemReadD, MemWriteD, JumpD, RegWriteD, BranchD, MuxjalrD, WriteBackD,
	output reg [1:0] ALUSrcA_D, ALUSrcB_D,
	output reg [3:0] ALUOpD,
	output reg [2:0] ImmControlD 
);
	localparam R = 7'b0110011;
   localparam I = 7'b0010011;
	localparam LOAD = 7'b0000011;
	localparam JALR = 7'b1100111;
   localparam STORE = 7'b0100011;
   localparam B = 7'b1100011;
	localparam LUI = 7'b0110111;
	localparam AUIPC = 7'b0010111;
   localparam J = 7'b1101111;


	always @(*) begin
		case(opcode)
			R: begin
				MemReadD <= 0; MemWriteD <= 0; JumpD <= 0; RegWriteD <= 1; BranchD <= 0; MuxjalrD <= 0; WriteBackD <= 0;
				ALUSrcA_D <= 2'b00; ALUSrcB_D <= 2'b00; 
			end
			I: begin
				MemReadD <= 0; MemWriteD <= 0; JumpD <= 0; RegWriteD <= 1; BranchD <= 0; MuxjalrD <= 0; WriteBackD <= 0;
				ALUSrcA_D <= 2'b00; ALUSrcB_D <= 2'b01; 
			end
			LOAD: begin
				MemReadD <= 1; MemWriteD <= 0; JumpD <= 0; RegWriteD <= 1; BranchD <= 0; MuxjalrD <= 0; WriteBackD <= 1;
				ALUSrcA_D <= 2'b00; ALUSrcB_D <= 2'b01; 
			end
			STORE: begin
				MemReadD <= 0; MemWriteD <= 1; JumpD <= 0; RegWriteD <= 0; BranchD <= 0; MuxjalrD <= 0; WriteBackD <= 0;
				ALUSrcA_D <= 2'b00; ALUSrcB_D <= 2'b01; 
			end
			JALR: begin
				MemReadD <= 0; MemWriteD <= 0; JumpD <= 1; RegWriteD <= 1; BranchD <= 0; MuxjalrD <= 1; WriteBackD <= 0;
				ALUSrcA_D <= 2'b01; ALUSrcB_D <= 2'b10; 
			end
			B: begin
				MemReadD <= 0; MemWriteD <= 0; JumpD <= 0; RegWriteD <= 0; BranchD <= 1; MuxjalrD <= 0; WriteBackD <= 0;
				ALUSrcA_D <= 2'b00; ALUSrcB_D <= 2'b00; 
			end
			LUI: begin
				MemReadD <= 0; MemWriteD <= 0; JumpD <= 0; RegWriteD <= 1; BranchD <= 0; MuxjalrD <= 0; WriteBackD <= 0;
				ALUSrcA_D <= 2'b10; ALUSrcB_D <= 2'b01; 
			end
			AUIPC: begin
				MemReadD <= 0; MemWriteD <= 0; JumpD <= 0; RegWriteD <= 1; BranchD <= 0; MuxjalrD <= 0; WriteBackD <= 0;
				ALUSrcA_D <= 2'b01; ALUSrcB_D <= 2'b01; 
			end
			J: begin
				MemReadD <= 0; MemWriteD <= 0; JumpD <= 1; RegWriteD <= 1; BranchD <= 0; MuxjalrD <= 0; WriteBackD <= 0;
				ALUSrcA_D <= 2'b01; ALUSrcB_D <= 2'b10; 
			end
			default: begin
				MemReadD <= 0; MemWriteD <= 0; JumpD <= 0; RegWriteD <= 0; BranchD <= 0; MuxjalrD <= 0; WriteBackD <= 0;
				ALUSrcA_D <= 2'b00; ALUSrcB_D <= 2'b00; 
			end
		endcase
		
		//ALU Control
		casex({opcode, funct3, funct7})
			17'b0110011_000_0100000: ALUOpD <= 4'b1000; //sub
			17'b0110011_100_0000000: ALUOpD <= 4'b0100; //xor
			17'b0110011_110_0000000: ALUOpD <= 4'b0110; //or
			17'b0110011_111_0000000: ALUOpD <= 4'b0111; //and
			17'b0110011_001_0000000: ALUOpD <= 4'b0001; //sll
			17'b0110011_101_0000000: ALUOpD <= 4'b0101; //srl
			17'b0110011_101_0100000: ALUOpD <= 4'b1001; //sra
			17'b0110011_010_0000000: ALUOpD <= 4'b0010; //slt
			17'b0110011_011_0000000: ALUOpD <= 4'b0011; //sltu
		
			17'b0010011_100_0000000: ALUOpD <= 4'b0100; //xori
			17'b0010011_110_0000000: ALUOpD <= 4'b0110; //ori
			17'b0010011_111_0000000: ALUOpD <= 4'b0111; //andi
			17'b0010011_001_0000000: ALUOpD <= 4'b0001; //slli
			17'b0010011_101_0000000: ALUOpD <= 4'b0101; //srli
			17'b0010011_101_0100000: ALUOpD <= 4'b1001; //srai
			17'b0010011_010_0000000: ALUOpD <= 4'b0010; //slti
			17'b0010011_011_0000000: ALUOpD <= 4'b0011; //sltui
		
			default: ALUOpD <= 4'b0000;
		endcase
			
		//Imm Control
		casex({opcode, funct3, funct7})
			17'b0010011_011_0000000: ImmControlD <= 3'b001; //sltui
			
			17'b0010011_001_0000000: ImmControlD <= 3'b010;  //slli
			17'b0010011_101_0000000: ImmControlD <= 3'b010;  //srli
			17'b0010011_101_0100000: ImmControlD <= 3'b010;  //srai
			
			17'b0100011_xxx_xxxxxxx: ImmControlD <= 3'b011;  //store
			
			17'b1100011_xxx_xxxxxxx: ImmControlD <= 3'b100;  //branch
			
			17'b0110111_xxx_xxxxxxx: ImmControlD <= 3'b101;  //lui
			17'b0010111_xxx_xxxxxxx: ImmControlD <= 3'b101;  //auiPC
			
			17'b1101111_xxx_xxxxxxx: ImmControlD <= 3'b110;  //jal
			
			default: ImmControlD <= 3'b000;
		endcase
	end
endmodule 
