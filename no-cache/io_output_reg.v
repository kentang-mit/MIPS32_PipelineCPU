module io_output_reg(addr,datain,write_io_enable,io_clk,clrn,out_port0,out_port1,out_port2);
//NOTE: sw
	input [31:0] addr, datain;
	input write_io_enable, io_clk, clrn;
	output reg [31:0] out_port0, out_port1, out_port2;
	
	always @(posedge io_clk or negedge clrn)
		begin
		if(!clrn)
		begin
			out_port0 <= 0;
			out_port1 <= 0;
			out_port2 <= 0;
		end
		else
		begin
			if(write_io_enable)
			case(addr[7:2])
			6'b100000: out_port0 <= datain;
			6'b100001: out_port1 <= datain;
			6'b100010: out_port2 <= datain;
			endcase
		end
		end
endmodule
	