module WriteBackStageCU(
        clk,
        reset,
        RegWriteM,
        ResultSrcM,
        RegWriteW,
        ResultSrcW
    );
    
    input wire clk;
    input wire reset;
    input wire RegWriteM;
    input wire [2:0] ResultSrcM;
    
    output reg RegWriteW;
    output reg [2:0] ResultSrcW;
    
    always @ (posedge clk) begin //MEMORY -> WRITE
       if(reset) begin
           RegWriteW <= 1'b0;
           ResultSrcW <= 3'b000;
       end else begin
           RegWriteW <= RegWriteM;
           ResultSrcW <= ResultSrcM;
	   end
	end   
	
endmodule