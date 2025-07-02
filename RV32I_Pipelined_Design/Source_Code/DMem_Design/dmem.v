module dmem (
	clk,
	we,
	a,
	wd,
	rd,
	DextControl
);
	input wire clk;
	input wire we;
	input wire [31:0] a;
	input wire [31:0] wd;
	output wire [31:0] rd;
	input wire [2:0] DextControl;
	reg [31:0] RAM [63:0];
	assign rd = RAM[a[31:2]];
	always @(posedge clk)
		if (we)
			case (DextControl)
				3'b000: //sb
				begin
					case (a[1:0])
					2'b00: RAM[a[31:2]][7:0] <= wd[7:0];
					2'b01: RAM[a[31:2]][15:8] <= wd[7:0];
					2'b10: RAM[a[31:2]][23:16] <= wd[7:0];
					2'b11: RAM[a[31:2]][31:24] <= wd[7:0];
					endcase
				end
				
				3'b001: //sh
				begin
				case (a[1:0])
					2'b00: RAM[a[31:2]][15:0] <= wd[15:0];
					2'b01: RAM[a[31:2]][23:8] <= wd[15:0];
					2'b10: RAM[a[31:2]][31:16] <= wd[15:0];
					endcase
				end

				default: RAM[a[31:2]] <= wd;
			endcase	
endmodule
