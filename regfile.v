module regfile (rna,rnb,d,wn,we,clk,clrn,qa,qb);
   input [4:0] rna,rnb,wn;
   input [31:0] d;
   input we,clk,clrn;
   
   output [31:0] qa,qb;
   
   reg [31:0] register [1:31]; // r1 - r31
   
   assign qa = (rna == 0)? 0 : register[rna]; // read
   assign qb = (rnb == 0)? 0 : register[rnb]; // read
	/*
   wire read_clk;
   assign read_clk = ~clk;

   always @(posedge read_clk) begin
      if(rna != 0) begin
         if(rnb != 0) begin
            qa = register[rna];
            qb = register[rnb];
         end
         else begin
            qa = register[rna];
            qb = 0; 
         end
      end
      else begin
         if(rnb != 0) begin
            qb = register[rnb];
            qa = 0;
         end
         else begin
            qa = 0;
            qb = 0;
         end
      end
   end
   */
	integer i;
   //I added negedge clk, for the sake of simulation. Hold-time??
   always @(posedge clk or negedge clrn or negedge clk) begin
      if (clrn == 0) begin // reset
         for (i=1; i<32; i=i+1)
            register[i] <= 0;
      end else begin
         if ((wn != 0) && (we == 1))          // write
            register[wn] <= d;
      end
   end
endmodule