//direct-mapped,write-allocate,write-through
module pipedcache(p_a,p_dout,p_din,p_strobe,p_rw,uncached,p_ready,
	clock,resetn,m_a,m_dout,m_din,m_strobe,m_rw,m_ready);

input[31:0] p_a;
input[31:0] p_dout;
output[31:0] p_din;
input p_strobe; //strobe: memory access or not
input p_rw;
input uncached; //I/O
output p_ready;
output[31:0] m_a;
output[31:0] m_din;
input[31:0] m_dout;
output m_strobe;
output m_rw;
input m_ready;
input clock,resetn;

reg d_valid[0:63];
reg [23:0] d_tags[0:63];
reg [31:0] d_data[0:63];
wire [23:0] tag = p_a[31:8];
wire [31:0] c_din;
wire [5:0] index = p_a[7:2];
wire c_write;
integer i;
always @(posedge clock or negedge resetn)
begin
	if(~resetn)
	begin
		for(i=0;i<64;i++)
			d_valid[i] <= 0;
	end
	if(c_write)
		d_valid[index] <= 1;
end

always @(posedge clock)
begin
	if(c_write)
	begin
		d_tags[index] <= tag;
		d_data[index] <= c_din;
	end
end
assign m_rw = p_rw; //write through
assign m_a = p_a;
assign m_din = p_dout;
assign p_din = cache_hit?c_dout:m_dout;

wire valid = d_valid[index];
wire [23:0] tagout = d_tags[index];
wire [31:0] c_dout = d_data[index];
wire cache_hit = p_strobe & valid & (tagout==tag);
wire cache_miss = p_strobe & (!valid|(tagout!=tag));
assign m_strobe = p_rw | cache_miss; //access main memory
assign c_din = p_rw?p_dout:m_dout;
assign c_write = p_rw | (m_ready&cache_miss);

assign p_ready = (~p_rw&cache_hit) | m_ready;

endmodule