module WriteBackStageDP(
        clk,
        reset,
        TruncResultM,
        PCPlus4M,
        PCTargetM,
        ImmExtM,
        ALUResultM,
        RdM,
        TruncResultW,
        PCPlus4W,
        PCTargetW,
        ImmExtW,
        ALUResultW,
        RdW
    );
   input wire clk;
   input wire reset;
   input wire [31:0] TruncResultM;
   input wire [31:0] PCPlus4M;
   input wire [31:0] PCTargetM;
   input wire [31:0] ImmExtM;
   input wire [31:0] ALUResultM;
   input wire [4:0] RdM;
    
   output reg [31:0] TruncResultW;
   output reg [31:0] PCPlus4W;
   output reg [31:0] PCTargetW;
   output reg [31:0] ImmExtW;
   output reg [31:0] ALUResultW;
   output reg [4:0] RdW;
    
	always @ (posedge clk) begin //MEMORY -> Write
	   if(reset) begin
	       TruncResultW = {32{1'b0}};
           PCPlus4W = {32{1'b0}};
           PCTargetW = {32{1'b0}};
           ImmExtW = {32{1'b0}};
           ALUResultW = {32{1'b0}};
           RdW = {5{1'b0}};
	   end
	   else begin
           TruncResultW = TruncResultM;
           PCPlus4W = PCPlus4M;
           PCTargetW = PCTargetM;
           ImmExtW = ImmExtM;
           ALUResultW = ALUResultM;
           RdW = RdM;
       end
	end
 
endmodule