`timescale 10ps/1ps

module pipecomputer_sim;

    reg           resetn_sim;
    reg           clock_50M_sim;
	 reg           mem_clk_sim;
	 //reg    [31:0] in_port0_sim;
	 //reg    [31:0] in_port1_sim;

	 

  //wire   [6:0]  hex0_sim,hex1_sim,hex2_sim,hex3_sim,hex4_sim,hex5_sim;
	 //wire          led0_sim,led1_sim,led2_sim,led3_sim;
	 
	       
//	 wire   [31:0]  in_port0_sim,in_port1_sim;
	 wire [6:0] hex0_sim,hex1_sim;
     reg[3:0] in_port0_sim,in_port1_sim;
	 wire   [31:0]  pc_sim,inst_sim,aluout_sim,memout_sim;
    wire           imem_clk_sim,dmem_clk_sim;
    //wire   [31:0]  out_port0_sim,out_port1_sim;
    wire   [31:0]  mem_dataout_sim;            // to check data_mem output
    wire   [31:0]  data_sim;
    //wire   [31:0]  io_read_data_sim;
   
    wire           wmem_sim;   // connect the cpu and dmem. 
    wire [31:0] ealu_sim, malu_sim, walu_sim;

  pipelined_computer pc(resetn_sim,clock_50M_sim,mem_clk_sim,in_port0_sim,in_port1_sim,pc_sim,inst_sim,ealu_sim,malu_sim,walu_sim,hex0_sim,hex1_sim);

	 initial
        begin
            clock_50M_sim = 1;
            while (1)
                #1  clock_50M_sim = ~ clock_50M_sim;
        end
	 initial
        begin
            mem_clk_sim = 0;
            while (1)
                #1  mem_clk_sim = ~ mem_clk_sim;
        end
	 initial
        begin
            resetn_sim = 0;
            while (1)
               #1  resetn_sim = 1;
        end
	 
        initial
        begin
            in_port0_sim = 0;
            in_port1_sim = 0;
            #5 in_port0_sim = 15;
            #6 in_port1_sim = 13;
        end


		  
    initial
        begin
		  
          $display($time,"resetn=%b clock_50M=%b  mem_clk =%b", resetn_sim, clock_50M_sim, mem_clk_sim);
			 
			 //# 125000 $display($time,"out_port0 = %b  out_port1 = %b ", out_port0_sim,out_port1_sim );

        end

endmodule 

