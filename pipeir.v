module pipeir (pc4,ins,wpcir,clock,resetn,dpc4,inst);
input wire[31:0] pc4, ins;
input wire wpcir;
input wire clock,resetn;

output reg[31:0] dpc4, inst;

always @(posedge clock)
begin
	if(~resetn)
	begin
		dpc4 <= 0;
		inst <= 0;
	end
	else 
	begin
		if(wpcir)
		begin
		dpc4 <= pc4;
		inst <= ins;
		end
		else begin
			//inst <= ins;
		end
	end
end

endmodule