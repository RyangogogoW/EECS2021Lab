module labM; 
reg clk, read, write; 
reg [31:0] address, memIn; 
wire [31:0] memOut; 
mem data(memOut, address, memIn, clk, read, write); 
initial 
begin        
  		 address = 128; write = 0; read = 0; 
		 clk = 0;
   		repeat   (11)   
		begin
			#4 read = 1;
			#4
			if (memOut[6:0] == 7'h33)
				 $display("%2h %2h %2h %1h %2h %2h // R-Type", memOut[31:25], memOut[24:20], memOut[19:15], memOut[14:12], memOut[11:7], memOut[6:0]); 
			if (memOut[6:0] == 7'h6F)
				$display("%5h %2h %2h // UJ-Type", {memOut[31],memOut[19:12],memOut[20],memOut[30:21]}, memOut[11:7], memOut[6:0]); 
			if (memOut[6:0] == 7'h3 || memOut[6:0] == 7'h13)
				$display("%3h %2h %1h %2h %2h // I-Type", memOut[31:20], memOut[19:15], memOut[14:12], memOut[11:7], memOut[6:0]);
			if (memOut[6:0] == 7'h23)
				$display("%2h %2h %2h %1h %2h %2h // S-Type", memOut[31:25], memOut[24:20], memOut[19:15], memOut[14:12], memOut[11:7], memOut[6:0]); 			
			if (memOut[6:0] == 7'h63)
				$display("%2h %2h %2h %1h %2h %2h // SB-Type", memOut[31:25], memOut[24:20], memOut[19:15], memOut[14:12], memOut[11:7], memOut[6:0]); 
			address = address + 4; 

   		end
		$finish;
end
always
begin
		#4 clk = ~clk;
end
endmodule 
