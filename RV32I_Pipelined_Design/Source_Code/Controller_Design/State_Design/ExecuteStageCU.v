module ExecuteStageCU(
        clk,
        reset,
        ALUSrcD,
        RegWriteD,
        JumpD,
        ResultSrcD,
        ALUControlD,
        PCResultSrcD,
        DextControlD,
        MemWriteD,
        BranchD,
        ALUSrcE,
        RegWriteE,
        JumpE,
        ResultSrcE,
        ALUControlE,
        PCResultSrcE,
        DextControlE,
        MemWriteE,
        BranchE,
        FlushE,
        opE_65,
        funct3E,
        op,
        funct3
    );
    
    input wire clk;
    input wire reset;
    input wire ALUSrcD;
	input wire RegWriteD;
	input wire JumpD;
	input wire [2:0] ResultSrcD;
	input wire [3:0] ALUControlD;
	input wire PCResultSrcD;
	input wire [2:0] DextControlD;
	input wire MemWriteD;
	input wire BranchD;
	input wire FlushE;
	input wire [6:0] op;
	input wire [2:0] funct3;
	
	output reg [1:0] opE_65;
	output reg [2:0] funct3E;
	output reg ALUSrcE;
	output reg RegWriteE;
	output reg JumpE;
	output reg [2:0] ResultSrcE;
	output reg [3:0] ALUControlE;
	output reg PCResultSrcE;
	output reg [2:0] DextControlE;
	output reg MemWriteE;
	output reg BranchE;
    
    always @ (posedge clk) begin //DECODE -> EXECUTE
    
        if(reset) begin
           opE_65 <= 2'b00;
           funct3E <= 3'b000;
           ALUSrcE <= 1'b0;
           RegWriteE <= 1'b0;
           JumpE <= 1'b0;
           ResultSrcE <= 3'b000;
           ALUControlE <= 4'b0000;
           PCResultSrcE <= 1'b0;
           DextControlE <= 3'b000;
           MemWriteE <= 1'b0;	
           BranchE <= 1'b0; 
        end
        else if(FlushE) begin
           opE_65 <= 2'b00;
           funct3E <= 3'b000;
           ALUSrcE <= 1'b0;
           RegWriteE <= 1'b0;
           JumpE <= 1'b0;
           ResultSrcE <= 3'b000;
           ALUControlE <= 4'b0000;
           PCResultSrcE <= 1'b0;
           DextControlE <= 3'b000;
           MemWriteE <= 1'b0;	
           BranchE <= 1'b0; 
        end 
        else begin
           opE_65 <= op[6:5];
           funct3E <= funct3;
           ALUSrcE <= ALUSrcD;
           RegWriteE <= RegWriteD;
           JumpE <= JumpD;
           ResultSrcE <= ResultSrcD;
           ALUControlE <= ALUControlD;
           PCResultSrcE <= PCResultSrcD;
           DextControlE <= DextControlD;
           MemWriteE <= MemWriteD;	
           BranchE <= BranchD;
         end  
	end 
endmodule
