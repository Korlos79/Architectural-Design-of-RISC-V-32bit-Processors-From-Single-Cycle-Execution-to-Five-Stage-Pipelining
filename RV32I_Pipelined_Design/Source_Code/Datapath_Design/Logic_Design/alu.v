module alu (
	SrcA,
	SrcB,
	ALUControl,
	ALUResult,
	Zero
);
	input wire [31:0] SrcA;
	input wire [31:0] SrcB;
	input wire [3:0] ALUControl;
	output reg [31:0] ALUResult;
	output wire Zero;
	assign Zero = ALUResult == 32'b00000000000000000000000000000000;
	always @(*)
		case (ALUControl)
			4'b0000: ALUResult = SrcA + SrcB; //add, addi
			4'b0001: ALUResult = SrcA - SrcB; //sub, subi
			4'b0010: ALUResult = SrcA & SrcB; //and, andi
			4'b0011: ALUResult = SrcA | SrcB; //or, ori
			4'b0100: ALUResult = SrcA ^ SrcB; // xor, xori
			4'b0101: ALUResult = SrcA < SrcB; // sltu, sltiu
			4'b0110: begin					 //slt, slti
				if(SrcA[31] == 1 && SrcB[31] == 0)
					ALUResult = 32'b00000000000000000000000000000001;
				else if (SrcA[31] == 0 && SrcB[31] == 1)
					ALUResult = 32'b00000000000000000000000000000000;
				else
					ALUResult = SrcA[30:0] < SrcB[30:0];
			end 
			4'b0111: ALUResult = SrcA << SrcB; //sll, slli
			4'b1000: ALUResult = SrcA >> SrcB; //srl, srli
			4'b1001: ALUResult = SrcA >>> SrcB; //sra, srai
			default: ALUResult = ALUResult;
		endcase
endmodule
