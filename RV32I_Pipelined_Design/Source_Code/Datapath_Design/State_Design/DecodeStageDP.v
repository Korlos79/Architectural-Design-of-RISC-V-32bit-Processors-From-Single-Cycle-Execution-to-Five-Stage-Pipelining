module DecodeStageDP(
        clk,
        reset,
        PCF,
        PCPlus4F,
        Instr,
        PCD,
        PCPlus4D,
        InstrD,
        StallD,
        FlushD
    );
    
    input wire clk;
    input wire reset;
    input wire [31:0] PCF;
    input wire [31:0] PCPlus4F;
    input wire StallD;
    input wire FlushD;
    input wire [31:0] Instr;
    output reg [31:0] InstrD;
    output reg [31:0] PCD;
    output reg [31:0] PCPlus4D;
    
    always @ (posedge clk) begin //FETCH
        if(reset) begin
            InstrD = {32{1'b0}};
            PCD = {32{1'b0}};
            PCPlus4D = {32{1'b0}};
        end
        else if(FlushD) begin
            InstrD = {32{1'b0}};
            PCD = {32{1'b0}};
            PCPlus4D = {32{1'b0}};
        end
        else if(StallD) begin
                InstrD <= InstrD;
                PCD <= PCD;
                PCPlus4D <= PCPlus4D;
            end
            else begin
                InstrD <= Instr;
                PCD <= PCF;
	            PCPlus4D <= PCPlus4F;
            end
	end
 
endmodule