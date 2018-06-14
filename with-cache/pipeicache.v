//direct-mapped,read-only
module pipeicache(p_a,p_din,p_ready,
	clock,m_a,m_dout,m_strobe,m_ready);

input[31:0] p_a;
output [31:0] p_din;
output p_ready;
output[31:0] m_a;
input[31:0] m_dout;
output m_strobe;
input m_ready;
input clock;

reg i_valid[0:63];
reg [23:0] i_tags[0:63];
reg [31:0] i_data[0:63];
wire [23:0] tag = p_a[31:8];
wire [31:0] c_din;
wire [5:0] index = p_a[7:2];
wire c_write;

integer i;
initial
begin
	for(i=0;i<64;i=i+1)
	begin
		i_valid[i] = 0;
		i_data[i] = 0;
		i_tags[i] = 0;
	end
end

always @(posedge clock)
begin
	if(c_write)
	begin
		i_valid[index] <= 1;
		i_data[index] <= c_din;
		i_tags[index] <= tag;
	end
end


wire valid = i_valid[index];
wire [23:0] tagout = i_tags[index];
wire [31:0] c_dout = i_data[index];
wire cache_hit = (tagout == tag) & valid;
wire cache_miss = ~cache_hit;
assign c_write = cache_miss & m_ready;
assign p_ready = cache_hit | m_ready;
assign m_a = p_a;
assign m_strobe = cache_miss;
assign c_din = m_dout;
assign p_din = cache_hit?c_dout:m_dout;
endmodule