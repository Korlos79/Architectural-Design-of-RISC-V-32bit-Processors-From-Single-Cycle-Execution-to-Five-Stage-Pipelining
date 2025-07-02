module truncate(
    ReadControl,
    src,
    result,
    DextControl
    );
    input wire [1:0] ReadControl;
    input wire [31:0] src;
    output reg [31:0] result;
    input wire [2:0] DextControl;
    
    always @(*) begin
        case (DextControl)
             3'b000: 
             begin
                case (ReadControl)
                2'b00: result = {{24 {src[7]}}, src[7:0]};
                2'b01: result = {{24 {src[15]}}, src[15:8]};
                2'b10: result = {{24 {src[23]}}, src[23:16]};
                2'b11: result = {{24 {src[31]}}, src[31:24]};
                default: result = {32{1'bx}};
                endcase
             end
             
             3'b001: 
             begin
               case (ReadControl)
                2'b00: result = {{16 {src[15]}}, src[15:0]};
                2'b01: result = {{16 {src[23]}}, src[23:8]};
                2'b10: result = {{16 {src[31]}}, src[31:16]};
                default: result = {32{1'bx}};
                endcase
             end

             3'b010: result = src;
             
             3'b100:
             begin
                case (ReadControl)
                2'b00: result = {{24 {1'b0}}, src[7:0]};
                2'b01: result = {{24 {1'b0}}, src[15:8]};
                2'b10: result = {{24 {1'b0}}, src[23:16]};
                2'b11: result = {{24 {1'b0}}, src[31:24]};
                default: result = {32{1'bx}};
                endcase
             end
             
             3'b101:
             begin
               case (ReadControl)
                2'b00: result = {{16 {1'b0}}, src[15:0]};
                2'b01: result = {{16 {1'b0}}, src[23:8]};
                2'b10: result = {{16 {1'b0}}, src[31:16]};
                default: result = {32{1'bx}};
                endcase
             end
             
           default: result = src;
         endcase
    end
        
    endmodule
