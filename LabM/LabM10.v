module labM; 
reg [31:0] PCin;
reg clk, RegWrite, ALUSrc, Mem2Reg,MemWrite,MemRead; 
reg [2:0] op;
wire signed[31:0] wd, rd1, rd2, imm, ins, PCp4, z, memOut, branch, wb; 
wire signed[31:0] jTarget;
wire zero; 
yIF myIF(ins, PCp4, PCin, clk);
yID myID(rd1, rd2, imm, jTarget, branch, ins, wd, RegWrite, clk);
yEX myEx(z, zero, rd1, rd2, imm, op, ALUSrc);
yDM myDM(memOut, z, rd2, clk, MemRead, MemWrite); 
yWB myWB(wb, z, memOut, Mem2Reg);
assign wd = wb;
initial 
begin 
   //------------------------------------Entry   point   
   PCin = 32'h28; 
   //------------------------------------Run   program   
   repeat   (43)   
   begin   
      //---------------------------------Fetch   an   ins   
	clk = 1; #1; 
      //---------------------------------Set   control   signals  
	//op = 3'b010;
	if(ins[6:0] == 7'h33)//R add x2,x3,x1
	begin 		
		RegWrite = 1;
		ALUSrc = 0;
		Mem2Reg = 0;
		MemRead = 0;
		MemWrite = 0;
		if (ins[14:12] == 3'b111 && ins[31:25] == 7'b0000000) op = 3'b000;			//and
		else if (ins[14:12] == 3'b110 && ins[31:25] == 7'b0000000) op = 3'b001;	//or
		else if (ins[14:12] == 3'b000 && ins[31:25] == 7'b0000000) op = 3'b010;	//add
		else if (ins[14:12] == 3'b000 && ins[31:25] == 7'b0100000) op = 3'b110;	//sub
		else if (ins[14:12] == 3'b010 && ins[31:25] == 7'b0000000) op = 3'b111;	//slt
      	end
	else if(ins[6:0] == 7'h23) //S sd sw x8 x0 0x020 $x8->*($x0+0x020)
	begin
		op = 3'b010;
		RegWrite = 0;
		ALUSrc = 1;
		Mem2Reg = 0;
		MemRead = 0;
		MemWrite = 1;
	end 
	else if (ins[6:0] == 7'h63)	//SB beq
	begin
		op = 3'b110;
		RegWrite = 0;
		ALUSrc = 0;
		Mem2Reg = 0;
		MemRead = 0;
		MemWrite = 0;
	end
	else if(ins[6:0] == 7'h13) //I
	begin
				RegWrite = 1;
				ALUSrc = 1;
				MemRead = 0;
				MemWrite = 0;
				Mem2Reg = 0;
				if (ins[14:12] == 3'b111 ) op = 3'b000;			//andi
				else if (ins[14:12] == 3'b110) op = 3'b001;	//ori
				else if (ins[14:12] == 3'b000) op = 3'b010;	//addi
				else if (ins[14:12] == 3'b010) op = 3'b111;	//slti
	end
	else if (ins[6:0] == 7'h3)	//ld lw ...
			begin
				op = 3'b010;
				RegWrite = 1;
				ALUSrc = 1;
				MemRead = 1;
				MemWrite = 0;
				Mem2Reg = 1;
				

	end

      //---------------------------------Execute   the   ins             
	clk = 0; #1; 
      //---------------------------------View   results   
	#2;
  	$display("%h: rd1=%2d rd2=%2d z= %2d zero=%b wb=%2d",  ins, rd1, rd2, z, zero, wb); 		
      //---------------------------------Prepare for the next ins 
	#1;
	//---------------------------------Prepare for the next ins if (beq && zero == 1)
	if (ins[6:0] == 7'h63 && zero == 1) //beq
		PCin = PCin+(branch<<2); //shifted left twice; 
	else if (ins[6:0] == 7'h6F) //jal
		PCin = PCin-(5<<2); //shifted left twice; 
	else
		PCin = PCp4;  
   end   
   $finish;   
end 
endmodule 
