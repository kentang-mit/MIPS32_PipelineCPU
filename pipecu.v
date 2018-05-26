module pipecu (op, func, z, wmem, wreg, regrt, m2reg, aluc, shift,
              aluimm, pcsource, jal, sext);
   input  [5:0] op,func;
   input        z;
   output       wreg,regrt,jal,m2reg,shift,aluimm,sext,wmem;
   output [3:0] aluc;
   output [1:0] pcsource;
   wire r_type = ~|op;
   wire i_add = r_type & func[5] & ~func[4] & ~func[3] &
                ~func[2] & ~func[1] & ~func[0];          //100000
   wire i_sub = r_type & func[5] & ~func[4] & ~func[3] &
                ~func[2] &  func[1] & ~func[0];          //100010
      
   //  please complete the deleted code.
   
   wire i_and =  r_type & func[5] & ~func[4] & ~func[3] & func[2] & 
                ~func[1] & ~func[0]; //100100
   wire i_or  =  r_type & func[5] & ~func[4] & ~func[3] & func[2] & 
                ~func[1] & func[0]; //100101

   wire i_xor =  r_type & func[5] & ~func[4] & ~func[3] & func[2] & 
                func[1] & ~func[0]; //100110
   wire i_sll =  r_type & ~func[5] & ~func[4] & ~func[3] & ~func[2] &
                ~func[1] & ~func[0]; //000000
   wire i_srl = r_type & ~func[5] & ~func[4] & ~func[3] & ~func[2] &
                func[1] & ~func[0]; //000010
   wire i_sra = r_type & ~func[5] & ~func[4] & ~func[3] & ~func[2] &
                func[1] & func[0]; //000011
   wire i_jr  = r_type & ~func[5] & ~func[4] & func[3] & ~func[2] &
                ~func[1] & ~func[0]; //001000
  
   //Note: here, op[i] instead of func[i].
   wire i_addi = ~op[5] & ~op[4] &  op[3] & ~op[2] & ~op[1] & ~op[0]; //001000
   wire i_andi = ~op[5] & ~op[4] &  op[3] &  op[2] & ~op[1] & ~op[0]; //001100
   
   wire i_ori  = ~op[5] & ~op[4] &  op[3] &  op[2] & ~op[1] & op[0]; //001101
   wire i_xori = ~op[5] & ~op[4] &  op[3] &  op[2] & op[1] & ~op[0]; //001110
   wire i_lw   = op[5] & ~op[4] &  ~op[3] &  ~op[2] & op[1] & op[0]; //100011
   wire i_sw   = op[5] & ~op[4] &  op[3] &  ~op[2] & op[1] & op[0]; //101011
   wire i_beq  = ~op[5] & ~op[4] &  ~op[3] & op[2] & ~op[1] & ~op[0]; //000100
   wire i_bne  = ~op[5] & ~op[4] &  ~op[3] & op[2] & ~op[1] & op[0]; //000101
   wire i_lui  = ~op[5] & ~op[4] &  op[3] & op[2] & op[1] & op[0]; //001111
   wire i_j    = ~op[5] & ~op[4] &  ~op[3] & ~op[2] & op[1] & ~op[0]; //000010
   wire i_jal  = ~op[5] & ~op[4] &  ~op[3] & ~op[2] & op[1] & op[0]; //000011
   
  
   assign pcsource[1] = i_jr | i_j | i_jal;
   assign pcsource[0] = ( i_beq & z ) | (i_bne & ~z) | i_j | i_jal ;
   
   assign wreg = i_add | i_sub | i_and | i_or   | i_xor  |
                 i_sll | i_srl | i_sra | i_addi | i_andi |
                 i_ori | i_xori | i_lw | i_lui  | i_jal;
   
   //aluc +:0000, -:x100 and:x001 or:x101 xor:x010 lui: x110 sll:0011 srl:0111 sra:1111
   //Note: bne, beq == xor
   assign aluc[3] = i_sra;
   assign aluc[2] = i_or | i_ori | i_lui | i_srl | i_sra | i_sub;
   assign aluc[1] = i_beq | i_bne | i_xor | i_xori | i_lui | i_sll | i_srl | i_sra;
   assign aluc[0] = i_and | i_andi | i_or | i_ori | i_sll | i_srl | i_sra;
   assign shift   = i_sll | i_srl | i_sra ;

   assign aluimm  = i_addi | i_andi | i_ori | i_xori | i_lw | i_sw; // All I-type(except LUI?). J-type is processed individually.
   assign sext    = i_addi | i_lw | i_sw | i_beq | i_bne;//arithmetic I-type(NOTE logical unnecessary)
   assign wmem    = i_sw;
   assign m2reg   = i_lw;
   //rd = rt
   assign regrt   = i_addi | i_andi | i_ori | i_xori | i_lw | i_lui;
   assign jal     = i_jal;

endmodule