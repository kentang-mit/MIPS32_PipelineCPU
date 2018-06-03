module regfile (rna,rnb,d,wn,we,clk,clrn,qa,qb);
   input [4:0] rna,rnb,wn;
   input [31:0] d;
   input we,clk,clrn;
   
   output [31:0] qa,qb;
   
   reg [31:0] register [1:31]; // r1 - r31
   wire test;
   assign test = register[1];
   
   assign qa = (rna == 0)? 0 : register[rna]; // read
   assign qb = (rnb == 0)? 0 : register[rnb]; // read
	integer i;
   //Should write at negedge of clk.
   //Reason: At posedge of clk, the "wn" is not ready, so the write action is delayed for one cycle.
   //Note that all the "feedback" are given to "D-port" of dffs, so it is unnecessary to emphasize
   //"write at posedge, read at negedge", since the "write" need only be completed before the next clock.
   always @(negedge clk or negedge clrn) begin
      if (clrn == 0) begin // reset
         for (i=1; i<32; i=i+1)
            register[i] <= 0;
      end else begin
         if ((wn != 0) && (we == 1))          // write
            register[wn] <= d;
      end
   end
endmodule