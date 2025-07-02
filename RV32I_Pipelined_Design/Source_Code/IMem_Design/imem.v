module imem (
	a,
	rd
);
	input wire [31:0] a;
	output wire [31:0] rd;
	reg [31:0] RAM [0:63];
	
	initial $readmemh("riscmem.mem",RAM);
	
	assign rd = RAM[a[31:2]];
endmodule
