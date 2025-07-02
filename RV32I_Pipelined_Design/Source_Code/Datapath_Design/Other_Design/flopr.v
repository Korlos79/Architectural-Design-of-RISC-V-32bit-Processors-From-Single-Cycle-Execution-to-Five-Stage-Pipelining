module flopr (
	clk,
	reset,
	StallF,
	d,
	q
);
	parameter WIDTH = 8;
	input wire clk;
	input wire reset;
	input wire StallF;
	input wire [WIDTH - 1:0] d;
	output reg [WIDTH - 1:0] q;
	always @(posedge clk or posedge reset)
		if (reset)
			q <= 0;
		else if(StallF)
		     q <= q; 	
		else
			q <= d;
endmodule
