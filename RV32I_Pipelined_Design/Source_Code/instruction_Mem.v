module instruction_Mem (
    input [31:0] addr,
	 output reg [31:0] inst
);
   reg [31:0] i_mem [63:0]; 
	
	initial begin
		//$readmemb ("TestCase/R_I_type.txt", i_mem);
		//$readmemb ("TestCase/lui_load_store.txt", i_mem);
		//$readmemb ("TestCase/branch.txt", i_mem);
		//$readmemb ("TestCase/auipc_jal_jalr.txt", i_mem);
		//$readmemb ("TestCase/fibo_10.txt", i_mem);
		$readmemb ("TestCase/hazard.txt", i_mem);
   end
	 
	always @(*) begin
		inst = i_mem[addr[31:2]];
	end
	 
endmodule
