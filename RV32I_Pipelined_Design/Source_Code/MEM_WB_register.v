module MEM_WB_register (
	input RegWriteM, clk, reset,
	input  WriteBackM,
	input [31:0] ALUResultM, ReadDataM,
	input [4:0] RdM,
	
	output reg RegWriteW,
	output reg WriteBackW,
	output reg [31:0] ALUResultW, ReadDataW,
	output reg [4:0] RdW
);

always @(posedge clk or negedge reset) begin
	if (~reset) begin
		RegWriteW <= 0;
		WriteBackW <= 3'd0; ALUResultW <= 32'd0; ReadDataW <= 32'd0;
		RdW <= 5'd0;
	end
	else begin
		RegWriteW <= RegWriteM;
		WriteBackW <= WriteBackM;
		ALUResultW <= ALUResultM; ReadDataW <= ReadDataM;
		RdW <= RdM;
	end
end
endmodule 