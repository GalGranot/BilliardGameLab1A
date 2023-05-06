// (c) Technion IIT, Department of Electrical Engineering 2021 
module score_counter 	
 ( 
	input	logic clk,
	input	logic resetN,
	input logic increaseScore,
	input logic decreaseScore,
	
	output logic unsigned [3:0] score	
  ) ;

	
always_ff @(posedge clk or negedge resetN) begin
		if (!resetN) 
			score <= 4'b0000;
		
		else 
			begin
				if (increaseScore)
					score <= score + 4'b0001; // play ball in
				else if (decreaseScore) 
				begin
					if (score == 4'b0000)
						score <= score; // white ball in
					else score <= score - 4'b0001;
				end
				else score <= score;
			end
	end
 
endmodule

