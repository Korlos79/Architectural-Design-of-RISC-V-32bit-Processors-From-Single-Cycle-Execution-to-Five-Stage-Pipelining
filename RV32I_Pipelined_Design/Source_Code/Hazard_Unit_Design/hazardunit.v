module hazardunit(
    stallF,
    stallD,
    flushD,
    Rs1D,
    Rs2D,
    flushE,
    Rs1E,
    Rs2E,
    RdE,
    PcSrcE,
    forwardAE,
    forwardBE,
    resultSrcE_0,
    RdM,
    RegWriteM,
    RdW,
    RegWriteW
);

output reg stallF;
output reg stallD;
output reg flushD;
input wire [4:0] Rs1D;
input wire [4:0] Rs2D;
output reg flushE;
input wire [4:0] Rs1E;
input wire [4:0] Rs2E;
input wire [4:0] RdE;
input wire PcSrcE;
output reg [1:0] forwardAE;
output reg [1:0] forwardBE;
input wire resultSrcE_0;
input wire [4:0] RdM;
input wire RegWriteM;
input wire [4:0] RdW;
input wire RegWriteW;

reg lwStall;

//Data Forward Implementation

always @(*) begin

    if (((Rs1E == RdM) && RegWriteM) && (Rs1E != 0)) // Forward from Memory stage
        forwardAE = 2'b10;
    else if (((Rs1E == RdW) && RegWriteW) && (Rs1E != 0)) // Forward from Writeback stage
        forwardAE = 2'b01;
    else
        forwardAE = 2'b00;

end

always @(*) begin

    if (((Rs2E == RdM) && RegWriteM) && (Rs2E != 0)) // Forward from Memory stage
        forwardBE = 2'b10;
    else if (((Rs2E == RdW) && RegWriteW) && (Rs2E != 0)) // Forward from Writeback stage
        forwardBE = 2'b01;
    else
        forwardBE = 2'b00;  

end

//Stall Implementation when a load hazard occurs
always @(*) begin
  lwStall = (resultSrcE_0 & ((Rs1D == RdE) | (Rs2D == RdE)));
	stallF = lwStall;
	stallD = lwStall;

  //Flush when a branch is taken or a load introduces a bubble:
  flushD = PcSrcE;
	flushE = lwStall | PcSrcE;

end

endmodule
