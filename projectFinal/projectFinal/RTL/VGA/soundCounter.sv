

module soundCounter 
	(

   input logic clk, 
   input logic resetN,
	input logic anySound,
   output logic [3:0] count,
	output logic finishCount
   );
	
assign finishCount = (count == 4'b1010);
	
   always_ff @( posedge clk or negedge resetN )
   begin
      if (!resetN) begin 
			count	<= 4'b000;
		end
      else 	begin
			if (anySound)
				count	<= 4'b000;
			else 
				count	<= count + 4'b0001;
		end
	end
	 

endmodule

