module MemoryStageDP(
        clk,
        reset,
        DextControlE,
        RdE,
        PCPlus4E,
        PCTargetE,
        WriteDataE,
        ImmExtE,
        ALUResultE,
        DextControlM,
        RdM,
        PCPlus4M,
        PCTargetM,
        WriteDataM,
        ImmExtM,
        ALUResultM
    );
   input wire clk;
   input wire reset;
   input wire [2:0] DextControlE;
   input wire [4:0] RdE;
   input wire [31:0] PCPlus4E;
   input wire [31:0] PCTargetE;
   input wire [31:0] WriteDataE;
   input wire [31:0] ImmExtE;
   input wire [31:0] ALUResultE; 
    
   output reg [2:0] DextControlM;
   output reg [4:0] RdM;
   output reg [31:0] PCPlus4M;
   output reg [31:0] PCTargetM;
   output reg [31:0] WriteDataM;
   output reg [31:0] ImmExtM;
   output reg [31:0] ALUResultM;
    
	always @ (posedge clk) begin //EXECUTE -> MEMORY
	   if(reset) begin
	       DextControlM = {3{1'b0}};
           RdM = {5{1'b0}};
           PCPlus4M = {32{1'b0}};
           PCTargetM = {32{1'b0}};
           WriteDataM = {32{1'b0}};
           ImmExtM = {32{1'b0}};
           ALUResultM = {32{1'b0}};
	   end
	   else begin
           DextControlM = DextControlE;
           RdM = RdE;
           PCPlus4M = PCPlus4E;
           PCTargetM = PCTargetE;
           WriteDataM = WriteDataE;
           ImmExtM = ImmExtE;
           ALUResultM = ALUResultE;
       end
	end
 
endmodule