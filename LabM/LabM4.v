module LabM;
reg [31:0] memIn, address;
wire [31:0] memOut;
reg clk, read, write;

mem data(memOut, address, memIn, clk, read, write);

initial
begin
	
		write = 1; read = 0; address = 16;
		clk = 0;
		memIn = 32'h12345678;
		#8;
		address = 24;
		memIn = 32'h89abcdef;
		#8;
		write = 0; read = 1; address = 0; 
		repeat (10) 
		begin 
			#4 $display("Address %d contains %h", address, memOut); 
			address = address + 4; 
		end 
		$finish;

end
always
begin
		#4 clk = ~clk;
end
endmodule
