module EX_M_register (
    input clk,rst_n,
    input regWrite_E, memWrite_E, memRead_E, resultScr_E, // write_back_E,
    input [31:0] alu_rsl_E,
    input [31:0] write_Data_E, // 
    input [4:0]  rd_E,
    input [2:0] mode_E, // ch?n ch? ?? ??c ghi dmem

    output reg regWrite_M, memWrite_M, memRead_M, resultScr_M, //write_back_M,
    output reg [31:0] alu_rsl_M,
    output reg [31:0] write_Data_M,
    output reg [4:0] rd_M,
    output reg [2:0] mode_M
);
    always @(posedge clk) begin
        if (!rst_n) begin
            regWrite_M <= 0;
            memWrite_M <= 0;
		memRead_M <= 0;
            resultScr_M <= 0;
            alu_rsl_M <= 0;
            write_Data_M <= 0;
            rd_M <= 0;
            mode_M <= 0;
        end
        else 
				regWrite_M <= regWrite_E;
            memWrite_M <= memWrite_E;
            memRead_M <= memRead_E;
            resultScr_M <= resultScr_E;
            alu_rsl_M <= alu_rsl_E;
            write_Data_M <= write_Data_E;
            rd_M <= rd_E;
				mode_M <= mode_E;
    end
endmodule 