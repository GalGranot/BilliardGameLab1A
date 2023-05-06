
// game controller dudy Febriary 2020
// (c) Technion IIT, Department of Electrical Engineering 2021 
//updated --Eyal Lev 2021


module	game_controller	(	
			input	logic	clk,
			input	logic	resetN,
			input	logic	startOfFrame,  // short pulse every start of frame 30Hz 
			input	logic	drawing_request_Ball,
			input	logic	drawing_request_1,
			input logic drawing_request_2,
			
			output logic collision, // active in case of collision between two objects
			output logic SingleHitPulse // critical code, generating A single pulse in a frame 
);

// drawing_request_Ball   -->  smiley
// drawing_request_1      -->  brackets
// drawing_request_2      -->  number/box 


//assign collision = ((drawing_request_Ball &&  drawing_request_1) || (drawing_request_2 && drawing_request_Ball));// any collision 
assign collision = (collision_smiley_number || collision_smiley_border);// any collision 
						 						
						
assign collision_smiley_number = drawing_request_Ball && drawing_request_2; // collision between ball and number only

assign collision_smiley_border = drawing_request_Ball &&  drawing_request_1;

logic flag ; // a semaphore to set the output only once per frame / regardless of the number of collisions 

always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN)
	begin 
		flag	<= 1'b0;
		SingleHitPulse <= 1'b0 ; 
	end 
	else begin 

			SingleHitPulse <= 1'b0 ; // default 
			if(startOfFrame) 
				flag <= 1'b0 ; // reset for next time 
				
			
if(collision_smiley_number && !flag)
	begin
		flag <= 1;
		SingleHitPulse <= 1;
	end

if ( collision_smiley_border  && (flag == 1'b0)) begin 
			flag	<= 1'b1; // to enter only once 
		end ; 
	end 
end

endmodule
