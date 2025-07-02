module MemoryStageCU(
        clk,
        reset,
        RegWriteE,
        ResultSrcE,
        DextControlE,
        MemWriteE,
        RegWriteM,
        ResultSrcM,
        DextControlM,
        MemWriteM
    );
    
    input wire clk;
    input wire reset;
	input wire RegWriteE;
	input wire [2:0] ResultSrcE;
	input wire [2:0] DextControlE;
	input wire MemWriteE;
	
	output reg RegWriteM;
	output reg [2:0] ResultSrcM;
	output reg [2:0] DextControlM;
	output reg MemWriteM;
    
    always @ (posedge clk) begin //EXECUTE -> MEMORY
       if(reset) begin
           RegWriteM <= 1'b0;
           ResultSrcM <= 3'b000;
           DextControlM <= 3'b000;
           MemWriteM <= 1'b0;
       end else begin
           RegWriteM <= RegWriteE;
           ResultSrcM <= ResultSrcE;
           DextControlM <= DextControlE;
           MemWriteM <= MemWriteE;
        end   
	end
	
endmodule