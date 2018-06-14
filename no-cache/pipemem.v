module pipemem(mwmem,malu,mb,wmo,wm2reg,in_port0,in_port1,clock,mem_clock,resetn,mmo,out_port0,out_port1,out_port2);
input wire mwmem,wm2reg;
input wire[31:0] malu,mb,wmo;
input wire[3:0] in_port0, in_port1;
output wire[31:0] out_port0, out_port1, out_port2;
input wire clock, mem_clock, resetn;
output wire[31:0] mmo;
wire write_mem_enable, write_io_enable;
wire [31:0] mem_dataout;
wire [31:0] io_dataout;
assign write_mem_enable = mwmem & ~malu[7];
assign write_io_enable = mwmem & malu[7];
//malu: maluess mb: data
wire [31:0] datain;
assign datain = wm2reg?wmo:mb;
io_input_reg io_input_regx2(malu,mem_clock,io_dataout,in_port0,in_port1);
io_output_reg io_output_regx3(malu,datain,write_io_enable,mem_clock,resetn,out_port0,out_port1,out_port2);
ram  dram(malu[6:2],mem_clock,datain,mwmem,mem_dataout);
mux2x32 mem_out_mux(mem_dataout,io_dataout,malu[7],mmo);
endmodule