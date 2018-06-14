module pipeif(pcsource,pc,bpc,da,jpc,npc,pc4,ins,mem_clock,imem_ready);
input wire[1:0] pcsource;
input wire[31:0] pc,bpc,da,jpc;
output wire[31:0] npc,pc4,ins;
input wire mem_clock;
output wire imem_ready;
//use negedge of original clock, read when signals are stable.
wire[31:0] fetched_ins, nop;
assign nop = 0;
//wire[255:0] mem_in;

wire [31:0] m_a, cache_ins;
//use clock for irom. maybe problematic
rom irom(m_a[7:2],~mem_clock,fetched_ins);
wire p_ready, m_strobe;
reg m_ready;
assign imem_ready = p_ready;

pipeicache icache(pc,cache_ins,p_ready,
	~mem_clock,m_a,fetched_ins,m_strobe,m_ready);

assign ins = pcsource[0]?32'h0:cache_ins;
assign pc4 = pc+32'h4;
mux4x32 new_pc(pc4,bpc,da,jpc,pcsource,npc); //pc+4,branch,da:jr(forwarding),j.
//da will not have data hazards, it will be propagated back directly from ID or EX.

reg[2:0] wait_cnt;

initial
begin
	m_ready = 0;
	wait_cnt = 0;
end
always @(posedge mem_clock)
begin
	if(wait_cnt == 5)
	begin
		wait_cnt <= 0;
		m_ready <= 1;
	end
	else begin
		wait_cnt <= wait_cnt + 1;
		m_ready <= 0;
	end
end

endmodule