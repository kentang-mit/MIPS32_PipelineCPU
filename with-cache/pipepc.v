module pipepc(npc,wpcir,imem_ready,mem_ready,clock,resetn,pc);
//npc:new pc
input wire[31:0] npc;
input wpcir;
input clock,resetn;
input imem_ready,mem_ready;
output reg[31:0] pc;

always @(posedge clock)
begin
	if(~resetn)
	begin
		pc <= 0; //not -4
	end
	else
	begin
		if(wpcir&imem_ready&mem_ready)
		begin
			pc <= npc;
		end
	end
end

endmodule