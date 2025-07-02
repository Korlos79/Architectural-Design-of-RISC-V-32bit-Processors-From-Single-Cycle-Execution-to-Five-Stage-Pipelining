module aludec (
	opb5,
	funct3,
	funct7b5,
	ALUOpD,
	ALUControlD,
	DextControlD
);
	input wire opb5;
	input wire [2:0] funct3;
	input wire funct7b5;
	input wire [1:0] ALUOpD;
	output reg [3:0] ALUControlD;
	output reg [2:0] DextControlD;
	wire RtypeSub;
	assign RtypeSub = funct7b5 & opb5;
	always @(*)
		case (ALUOpD)
			2'b00:
			begin 
			     ALUControlD = 4'b0000; //addition
			     case (funct3)
			         3'b000: DextControlD = 3'b000; //lb, sb
			         3'b001: DextControlD = 3'b001; //lh, sh
			         3'b010: DextControlD = 3'b010; //lw, sw
			         3'b100: DextControlD = 3'b100; //lbu
			         3'b101: DextControlD = 3'b101; //lhu
			         default: DextControlD = 3'bxxx;
			     endcase
			end  

			2'b01: //Braches
				case (funct3)
					3'b000: ALUControlD = 4'b0001; //subtraction
					3'b001: ALUControlD = 4'b0001; //subtraction
					3'b100: ALUControlD = 4'b0110; //set less than
					3'b101: ALUControlD = 4'b0110; //set less than
					3'b110: ALUControlD = 4'b0101; //set less than unsigned
					3'b111: ALUControlD = 4'b0101; //set less than unsigned
					default: ALUControlD = 4'bxxxx;
				endcase
				
			default:
				case (funct3) //R-Type or I-Type
					3'b000:
						if (RtypeSub)
							ALUControlD = 4'b0001; //sub
						else
							ALUControlD = 4'b0000; //add, addi
					3'b001: ALUControlD = 4'b0111; //sll, slli
					3'b010: ALUControlD = 4'b0110; //slt, slti
					3'b011: ALUControlD = 4'b0101; //sltu, sltiu
					3'b100: ALUControlD = 4'b0100; //xor, xori
					3'b101: if(funct7b5) 
								ALUControlD = 4'b1000; //srl, srli
							else
								ALUControlD = 4'b1001; //sra, srai
					3'b110: ALUControlD = 4'b0011; //or, ori
					3'b111: ALUControlD = 4'b0010; //and, andi
					default: ALUControlD = 4'bxxxx; //??
				endcase
		endcase
endmodule
