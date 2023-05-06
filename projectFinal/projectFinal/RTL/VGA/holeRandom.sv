
module holeRandom 	
 ( 
	input	logic  clk,
	input	logic  resetN, 
	input	logic	 rise,
	output logic unsigned [2:0] hole	
  ) ;

  
parameter unsigned  MIN_VAL = 0;  //set the min and max values 
parameter unsigned MAX_VAL = 5;

	logic unsigned  [2:0] counter;
	logic rise_d;
	
	
always_ff @(posedge clk or negedge resetN) begin
		if (!resetN) begin
			hole <= 0;
			counter <= MIN_VAL;
			rise_d <= 1'b0;
		end
		
		else begin
			counter <= counter+1;
			if ( counter >= MAX_VAL ) // the +1 is done on the next clock 
				counter <=  MIN_VAL ; // set min and max mvalues 
			rise_d <= rise;
			if (rise && !rise_d) // rising edge 
				hole <= counter;
		end
	
	end
 
endmodule

