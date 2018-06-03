module io_input_mux(in_reg0, in_reg1, addr, io_read_data);
input [31:0] in_reg0, in_reg1;
input [5:0] addr;
output reg [31:0] io_read_data;
initial
	begin
		io_read_data = 0;
	end
	
always @(*)
	case(addr)
	6'b110000: io_read_data = in_reg0;
	6'b110001: io_read_data = in_reg1;
	endcase

endmodule