module pipeinstmem(addr,en,clock,mem_ready,mem_out);
input wire[31:0] addr;
input wire en;
input wire clock;
output wire mem_ready;
output reg[255:0] mem_out;
reg[255:0] blockmem[0:63];
wire[5:0] block_addr;
assign block_addr = addr[10:5];//a block is 32B
initial $readmemh("inst_sim.txt",blockmem);
assign mem_ready=(mem_out!=0)|~en;
always @(posedge clock)
begin
	mem_out <= 0;
	if(en)
	begin
		mem_out <= blockmem[block_addr];
	end
end
endmodule
