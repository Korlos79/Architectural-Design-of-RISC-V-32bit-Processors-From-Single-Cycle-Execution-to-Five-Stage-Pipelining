module alu (
    input	[31:0] 	A,
	 input	[31:0]	B,
	 input	[3:0]		opcode,
	 input	[2:0]		branch,
	 output	reg 	[31:0]	result,
	 output	reg	Z
);

	 localparam beq = 3'b000 ;
    localparam bne = 3'b001 ;
    localparam blt = 3'b100 ;
    localparam bge = 3'b101 ;
    localparam bltu = 3'b110 ;
    localparam bgeu = 3'b111 ;
    
	 always @(*) begin
		case(opcode)
			0: result <= A + B;
			1: result <= A << B[4:0];
			2: result <= ($signed(A) < $signed(B));
			3: result <= ($unsigned(A) < $unsigned(B));
			4: result <= A ^ B;
			5: result <= A >> B[4:0];
			6: result <= A | B ;
			7: result <= A & B;
			8: result <= A - B;
			9: result <= $signed(A) >>> B[4:0];
			default: result <= 0;
		endcase
		
		case (branch)
            beq:    Z = (A == B) ;
            bne:    Z = (A != B);
            blt:    Z = ($signed(A) < $signed(B));
            bge:    Z = ~($signed(A) < $signed(B));
            bltu:   Z =  $unsigned(A) < $unsigned(B) ;
            bgeu:   Z = ~($unsigned(A) < $unsigned(B));
            default: Z = 0;
       endcase
	end
	
endmodule 