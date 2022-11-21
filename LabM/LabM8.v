module labM;
reg [31:0] PCin;
reg RegWrite, clk, ALUSrc; 
reg [2:0] op;
wire [31:0] wd, rd1, rd2, imm, ins, PCp4, z; 
wire signed[31:0] jTarget, branch;
wire zero;

yIF myIF(ins, PCp4, PCin, clk);
yID myID(rd1, rd2, imm, jTarget, branch, ins, wd, RegWrite, clk);
yEX myEx(z, zero, rd1, rd2, imm, op, ALUSrc);
assign wd = z; 
initial 
begin 
   //------------------------------------Entry   point   
   PCin = 128;
   //------------------------------------Run   program   
   repeat   (11)   
   begin   
      //---------------------------------Fetch   an   ins   
	clk = 1; #1; 
      //---------------------------------Set   control   signals  
	op = 3'b010;
	if(ins[6:0] == 7'h33) //R
	begin
		RegWrite = 1;
		ALUSrc = 0;
    end
	else if(ins[6:0] == 7'h3 || ins[6:0] == 7'h13) //I-type ld
	begin		
		RegWrite = 1;
		ALUSrc = 1;
	end
	else if (ins[6:0] == 7'h6F) //UJ
	begin		
		RegWrite = 1;
		ALUSrc = 1;
	end
	else if (ins[6:0] == 7'h23) //S sd
	begin		
		RegWrite = 0;
		ALUSrc = 1;
	end
	else if (ins[6:0] == 7'h63) //SB beq
	begin		
		RegWrite = 0;
		ALUSrc = 0;
	end

      //---------------------------------Execute   the   ins             
      clk = 0; #1; 
      //---------------------------------View   results   
      #1;
  	$display("[0x%h] %h rd1=%d rd2=%d imm=%h jTarget=%d z=%d zero=%h branch=%b", PCin, ins, rd1, rd2, imm, jTarget, z, zero, branch);

      //---------------------------------Prepare for the next ins 
	#1;
      PCin   =   PCp4;   
   end   
   $finish;   
end 
endmodule 
