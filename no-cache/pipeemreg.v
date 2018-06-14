module pipeemreg(ewreg,em2reg,ewmem,ealu,eb,ern,clock,resetn,mwreg,mm2reg,mwmem,malu,mb,mrn);
input wire ewreg, em2reg, ewmem;
input wire[31:0] ealu,eb;
input wire[4:0] ern;
input wire clock, resetn;

output reg mwreg, mm2reg, mwmem;
output reg[31:0] malu,mb;
output reg[4:0] mrn;

always @(posedge clock)
begin
	if(~resetn)
	begin
		mwreg <= 0;
		mm2reg <= 0;
		mwmem <= 0;
		malu <= 0;
		mb <= 0;
		mrn <= 0;
	end
	else begin
		mwreg <= ewreg;
		mm2reg <= em2reg;
		mwmem <= ewmem;
		malu <= ealu;
		mb <= eb;
		mrn <= ern;
	end
end

endmodule