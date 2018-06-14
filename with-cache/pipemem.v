module pipemem(mm2reg,mwmem,malu,mb,wmo,wm2reg,in_port0,in_port1,clock,mem_clock,resetn,mmo,mem_ready,out_port0,out_port1,out_port2);
input wire mm2reg,mwmem,wm2reg;
input wire[31:0] malu,mb,wmo;
input wire[3:0] in_port0, in_port1;
output wire[31:0] out_port0, out_port1, out_port2;
input wire clock, mem_clock, resetn;
output wire[31:0] mmo;
output wire mem_ready;

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

wire [31:0] cache_dout,m_a,m_din;
wire p_ready,m_rw;
wire m_strobe;
reg m_ready;
assign mem_ready = p_ready|~m_strobe;

pipedcache dcache(malu,datain,cache_dout,mm2reg|mwmem,mwmem,malu[7],p_ready,
	clock,resetn,m_a,mem_dataout,m_din,m_strobe,m_rw,m_ready);

mux2x32 mem_out_mux(cache_dout,io_dataout,malu[7],mmo);

reg[2:0] wait_cnt;
always @(posedge clock or negedge resetn)
begin
	if(~resetn)
	begin
		wait_cnt <= 0;
		m_ready <= 0;
	end
	if(m_strobe)
	begin
		if(wait_cnt == 5)
		begin
			m_ready <= 1;
			wait_cnt <= 0;
		end
		else begin
			m_ready <= 0;
			wait_cnt <= wait_cnt + 1;
		end
	end
end

endmodule