module pipemem(mwmem,malu,mb,clock,mem_clock,mmo);
input wire mwmem;
input wire[31:0] malu,mb;
input wire clock, mem_clock;
output wire[31:0] mmo;
//malu: address mb: data

ram  dram(malu[6:2],mem_clk,mb,mwmem,mmo);

endmodule