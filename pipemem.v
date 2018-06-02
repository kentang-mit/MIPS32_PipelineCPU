module pipemem(mwmem,malu,mb,wmo,wm2reg,clock,mem_clock,mmo);
input wire mwmem,wm2reg;
input wire[31:0] malu,mb,wmo;
input wire clock, mem_clock;
output wire[31:0] mmo;
//malu: address mb: data
wire [31:0] datain;
assign datain = wm2reg?wmo:mb;
ram  dram(malu[6:2],mem_clock,datain,mwmem,mmo);

endmodule