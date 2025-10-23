module Sign_Extend (
	input [24:0] inst,
	input [2:0] control,
	output reg [31:0] imm
);

	always @(*) begin
		case(control)
			0: imm <= {{20{inst[24]}}, inst[24:13]}; 											//I_type
			1: imm <= {{20{1'b0}}, inst[24:13]}; 												//zero_extend "sltiu"
			2: imm <= {{27{inst[17]}}, inst[17:13]}; 											//"slli, srli, srai"
			3: imm <= {{20{inst[24]}}, inst[24:18], inst[4:0]};	 						//S-type
			4: imm <= {{20{inst[24]}}, inst[0], inst[23:18], inst[4:1], 1'b0}; 		//B-type
			5: imm <= {inst[24:5], 12'd0}; 														//U_type
			6: imm <= {{12{inst[24]}}, inst[12:5], inst[13], inst[23:14], 1'b0}; 	//J_type
			default: imm <= 32'd0;
		endcase
	end
endmodule
