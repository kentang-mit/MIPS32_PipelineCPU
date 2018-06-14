module sevenseg(
	input [3:0] in,
	output reg [6:0] sevenseg
);

initial
begin
	sevenseg = 0;
end
always @(*)
	begin
	case(in)
		4'h0: sevenseg[6:0] = 7'b1000000;
		4'h1: sevenseg[6:0] = 7'b1111001;
		4'h2: sevenseg[6:0] = 7'b0100100;
		4'h3: sevenseg[6:0] = 7'b0110000;
		4'h4: sevenseg[6:0] = 7'b0011001;
		4'h5: sevenseg[6:0] = 7'b0010010;
		4'h6: sevenseg[6:0] = 7'b0000010;
		4'h7: sevenseg[6:0] = 7'b1111000;
		4'h8: sevenseg[6:0] = 7'b0000000;
		4'h9: sevenseg[6:0] = 7'b0010000;
		4'hA: sevenseg[6:0] = 7'b0001000;
		4'hB: sevenseg[6:0] = 7'b0000011;
		4'hC: sevenseg[6:0] = 7'b1000110;
		4'hD: sevenseg[6:0] = 7'b0100001;
		4'hE: sevenseg[6:0] = 7'b0000110;
		4'hF: sevenseg[6:0] = 7'b0001110;
		default: sevenseg[6:0] = 7'b1111111;
	endcase
	end
endmodule

		