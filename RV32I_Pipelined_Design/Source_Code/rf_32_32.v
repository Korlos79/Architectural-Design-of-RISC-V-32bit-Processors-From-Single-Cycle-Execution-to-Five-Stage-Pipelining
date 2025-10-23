module rf_32_32 (
	input clk, reg_write, rst,
	input [31:0] data_write,
	input [4:0] wa, ra1, ra2,
	output reg [31:0] rd1, rd2
);

	reg [31:0] rf [31:0];
	integer i;
	always @(negedge clk or negedge rst) begin
		if(!rst) begin
			  rf[0]  <= 32'd0;
			  rf[1]  <= 32'd0;
			  rf[2]  <= 32'd0;
			  rf[3]  <= 32'd0;
			  rf[4]  <= 32'd0;
			  rf[5]  <= 32'd0;
			  rf[6]  <= 32'd0;
			  rf[7]  <= 32'd0;
			  rf[8]  <= 32'd0;
			  rf[9]  <= 32'd0;
			  rf[10] <= 32'd0;
			  rf[11] <= 32'd0;
			  rf[12] <= 32'd0;
			  rf[13] <= 32'd0;
			  rf[14] <= 32'd0;
			  rf[15] <= 32'd0;
			  rf[16] <= 32'd0;
			  rf[17] <= 32'd0;
			  rf[18] <= 32'd0;
			  rf[19] <= 32'd0;
			  rf[20] <= 32'd0;
			  rf[21] <= 32'd0;
			  rf[22] <= 32'd0;
			  rf[23] <= 32'd0;
			  rf[24] <= 32'd0;
			  rf[25] <= 32'd0;
			  rf[26] <= 32'd0;
			  rf[27] <= 32'd0;
			  rf[28] <= 32'd0;
			  rf[29] <= 32'd0;
			  rf[30] <= 32'd0;
			  rf[31] <= 32'd0;
		end
		else if (reg_write == 1) begin
			if (wa != 0)
				rf[wa] <= data_write;
		end 
	end
	
	always @(*) begin
		rd1 = rf[ra1];
		rd2 = rf[ra2];
	end
endmodule
