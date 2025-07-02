module ExecuteStageDP(
        clk,
        reset,
        PCD,
        PCPlus4D,
        RD1D,
        RD2D,
        Rs1D,
        Rs2D,
        RdD,
        ImmExtD,
        PCE,
        PCPlus4E,
        RD1E,
        RD2E,
        Rs1E,
        Rs2E,
        RdE,
        ImmExtE,
        FlushE
    );
    
    input wire clk;
    input wire reset;
    input wire [31:0] PCD;
    input wire [31:0] PCPlus4D;
    input wire [31:0] RD1D;
	input wire [31:0] RD2D;
    input wire [4:0] Rs1D;
    input wire [4:0] Rs2D;
    input wire [4:0] RdD;
    input wire [31:0] ImmExtD;
    input wire FlushE;

    output reg [31:0]PCE;
    output reg [31:0] PCPlus4E;
    output reg [31:0] RD1E;
	output reg [31:0] RD2E;
    output reg [4:0] Rs1E;
    output reg [4:0] Rs2E;
    output reg [4:0] RdE;
    output reg [31:0] ImmExtE;

   always @ (posedge clk) begin //DECODE -> EXECUTE
       if(reset) begin
           PCE = {32{1'b0}};
           PCPlus4E = {32{1'b0}};
           RD1E = {32{1'b0}};
           RD2E = {32{1'b0}};
           Rs1E = {5{1'b0}};
           Rs2E = {5{1'b0}};
           RdE = {5{1'b0}};
           ImmExtE = {32{1'b0}}; 
       end
       else if(FlushE) begin
           PCE = {32{1'b0}};
           PCPlus4E = {32{1'b0}};
           RD1E = {32{1'b0}};
           RD2E = {32{1'b0}};
           Rs1E = {5{1'b0}};
           Rs2E = {5{1'b0}};
           RdE = {5{1'b0}};
           ImmExtE = {32{1'b0}}; 
       end
       else begin
           PCE = PCD;
           PCPlus4E = PCPlus4D;
           RD1E = RD1D;
           RD2E = RD2D;
           Rs1E = Rs1D;
           Rs2E = Rs2D;
           RdE = RdD;
           ImmExtE = ImmExtD; 
	   end
	end
	
endmodule	