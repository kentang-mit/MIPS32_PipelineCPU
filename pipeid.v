module pipeid(mwreg,mrn,ern,ewreg,em2reg,mm2reg,dpc4,inst,
	wrn,wdi,ealu,malu,mmo,wwreg,clock,resetn,bpc,
	jpc,pcsource,wpcir,dwreg,dm2reg,dwmem,daluc,daluimm,
	da,db,dimm,drn,dshift,djal);

//write at the negedge of clock(different from book)

input wire clock,resetn;
input wire mwreg,ewreg,em2reg,mm2reg,wwreg;
input wire[4:0] mrn,ern,wrn;
input wire[31:0] dpc4,inst,wdi,ealu,malu,mmo;

output wire dwreg,dm2reg,dwmem,daluimm,dshift,djal,wpcir;
output wire[3:0] daluc;
output wire[31:0] da,db,dimm,bpc,jpc;
output wire[4:0] drn;
output wire[1:0] pcsource;

wire dregrt,sext; //from CU.

wire dwreg_tmp,dm2reg_tmp,dwmem_tmp,daluimm_tmp,dshift_tmp,djal_tmp;
wire[3:0] daluc_tmp;
wire[4:0] drn_tmp;

//case add $1,$1,$2; beq $1,$2,...
//da,db have value immediately after EX calculation+MUX. No need to wait for RF.
//Thus such z calculation is reliable. CU will give response to IF in time.
wire z = ~|(da^db); //da==db

wire[5:0] op = inst[31:26];
wire[5:0] func = inst[5:0];
wire[4:0] rs = inst[25:21];
wire[4:0] rt = inst[20:16];
wire[4:0] rd = inst[15:11];

wire[31:0] rf_outa, rf_outb;

pipecu cu(op, func, z, dwmem_tmp, dwreg_tmp, dregrt, dm2reg_tmp, daluc_tmp, dshift_tmp,
              daluimm_tmp, pcsource, djal_tmp, sext);

regfile rf(rs,rt,wdi,wrn,wwreg,clock,resetn,rf_outa,rf_outb);

assign dwreg = wpcir?dwreg_tmp:1'b0;
assign dm2reg = wpcir?dm2reg_tmp:1'b0;
assign dwmem = wpcir?dwmem_tmp:1'b0;
assign daluimm = wpcir?daluimm_tmp:1'b0;
assign dshift = wpcir?dshift_tmp:1'b0;
assign djal = wpcir?djal_tmp:1'b0;
assign daluc = wpcir?daluc_tmp:4'b0;
assign drn = dregrt?rt:rd;
assign jpc = {dpc4[31:28],inst[25:0],1'b0,1'b0};
wire e = sext&inst[15];
wire[15:0] imm = {16{e}};
assign dimm = {imm, inst[15:0]};
wire[31:0] offset = {imm[13:0], inst[15:0], 1'b0, 1'b0};
assign bpc = dpc4 + offset;

//data hazards:
//forwarding: 1 instruction before, R-type => ealu(ready before negedge of system clock)
//forwarding: 2 instructions before, R-type => malu(ready before negedge of system clock)
wire[1:0] fwda, fwdb;
assign fwda[0] = (ewreg&~em2reg&ern==rs&ern!=0) | (mm2reg&mrn==rs&mrn!=0);
assign fwda[1] = (mwreg&~mm2reg&mrn==rs&ern!=rs&mrn!=0) | (mm2reg&mrn==rs&mrn!=0); //modified ern==rs will cause error.
assign fwdb[0] = (ewreg&~em2reg&ern==rt&ern!=0) | (mm2reg&mrn==rt&mrn!=0);
assign fwdb[1] = (mwreg&~mm2reg&mrn==rt&ern!=rt&mrn!=0) | (mm2reg&mrn==rt&mrn!=0); //modified ern==rs will cause error.

mux4x32 forwarding_da(rf_outa,ealu,malu,mmo,fwda,da);
mux4x32 forwarding_db(rf_outb,ealu,malu,mmo,fwdb,db);
//DON'T HAVE TO STOP: 2 instructions before.
//mmo is used for updating "npc" in IF stage potentially. However, npc need to be ready before the next cycle, the time
//will always be sufficient.
//have to stop: 1 instruction before, lw(this instruction in EX stage, not so good)

//assign wpcir = ~ ( (mm2reg & ((mrn==rs)|(mrn==rt))) | (em2reg & ((ern==rs)|(ern==rt))) );
assign wpcir = ~(em2reg & ((ern==rs)|(ern==rt)) & ~dwmem_tmp);
//control hazards:
//need to flush when j/jal/beq/bne. pc<=npc at next cycle!!


endmodule