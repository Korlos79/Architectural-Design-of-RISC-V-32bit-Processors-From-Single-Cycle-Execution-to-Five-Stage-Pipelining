    module mux5 (
	d0,
	d1,
	d2,
	d3,
	d4,
	s,
	y
);
	parameter WIDTH = 32;
	input wire [WIDTH - 1:0] d0;
	input wire [WIDTH - 1:0] d1;
	input wire [WIDTH - 1:0] d2;
	input wire [WIDTH - 1:0] d3;
	input wire [WIDTH - 1:0] d4;
	input wire [2:0] s;
	output wire [WIDTH - 1:0] y;
	assign y = (s[2] ? d4 : ( s[1] ? (s[0] ? d3 : d2) : (s[0] ? d1 : d0)));
endmodule
