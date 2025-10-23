//data memory _ byte addressing _ little endian
module dmem (
	input clk, we, re, 
	input [2:0] mode,
	input [9:0] addr,
	input [31:0] write_data,
	output reg [31:0] mem_out
);

	localparam b = 3'b000;
	localparam h = 3'b001;
	localparam w = 3'b010;
	localparam bu = 3'b100;
	localparam hu = 3'b101;
	
	reg [7:0] mem [1023:0];
	
	always @(posedge clk) begin
		//store
		if(we) begin
			case(mode)
				b: mem[addr] <= write_data[7:0];
				h: begin
					mem[addr] <= write_data[7:0];
					mem[addr+1] <= write_data[15:8];
				end
				w: begin
					mem[addr] <= write_data[7:0];
					mem[addr+1] <= write_data[15:8];
					mem[addr+2] <= write_data[23:16];
					mem[addr+3] <= write_data[31:24];
				end
			endcase 
		end
	end
	
	always@(*) begin
		//load
		if(re) begin
			case(mode)
				b: mem_out <= {{24{mem[addr][7]}}, mem[addr]};
				h: mem_out <= {{16{mem[addr+1][7]}}, mem[addr+1], mem[addr]};
				w: mem_out <= {mem[addr+3], mem[addr+2], mem[addr+1], mem[addr]};
				bu: mem_out <= {24'b0, mem[addr]};
				hu: mem_out <= {16'b0, mem[addr+1], mem[addr]};
				default: mem_out <= 32'b0;
			endcase
		end
		else
			mem_out <= 32'b0;
	end
	
endmodule 
