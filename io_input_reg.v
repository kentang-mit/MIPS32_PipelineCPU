module io_input_reg(addr,io_clk,io_read_data,in_port0,in_port1);
//NOTE: lw, io to CPU
	input [31:0] addr;
	input [3:0] in_port0, in_port1;
	input io_clk;
	output wire [31:0] io_read_data;
	reg [31:0] in_reg0, in_reg1;
	initial
	begin
		in_reg0 = 0;
		in_reg1 = 0;
	end
	io_input_mux io_input_mux_2x32(in_reg0,in_reg1,addr[7:2],io_read_data);
	always @(posedge io_clk)
		begin
			in_reg0 <= {28'b0,in_port0};
			in_reg1 <= {28'b0,in_port1};
		end
endmodule