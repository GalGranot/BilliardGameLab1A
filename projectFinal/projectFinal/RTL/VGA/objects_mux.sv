
// (c) Technion IIT, Department of Electrical Engineering 2021 
//-- Alex Grinshpun Apr 2017
//-- Dudy Nov 13 2017
// SystemVerilog version Alex Grinshpun May 2018
// coding convention dudy December 2018

//-- Eyal Lev 31 Jan 2021

module	objects_mux	(	
//		--------	Clock Input	 	
input	logic	clk,
input	logic	resetN,

//sight
input logic sightDR,
input logic [7:0] sightRGB,

// whiteBall 
input	logic	whiteBallDR, // two set of inputs per unit
input	logic	[7:0] whiteBallRGB,
	
//playBall1

input logic playBall1DR,
input logic [7:0] playBall1RGB,

//playBall2

input logic playBall2DR,
input logic [7:0] playBall2RGB,

//playBall3

input logic playBall3DR,
input logic [7:0] playBall3RGB,

//playBall4

input logic playBall4DR,
input logic [7:0] playBall4RGB,

////////////////////////
// background 

//holes

input logic holeDR, // box of numbers
input	logic	[7:0] holeRGB,   
input	logic	[7:0] backGroundRGB, 


//number
input logic numberDR,
input logic [7:0] numberRGB,

//start
input logic startDR,
input logic [7:0] startRGB,

//win
input logic winDR,
input logic [7:0] winRGB,

//confetti
input logic confettiDR,
input logic [7:0] confettiRGB,

//target
input logic targetDR,
input logic [7:0] targetRGB,
//lose
input logic loseDR,
input logic [7:0] loseRGB,

//portals
input logic orangePortalDR,
input logic [7:0] orangePortalRGB,

input logic bluePortalDR,
input logic [7:0] bluePortalRGB,

//points
input logic pointsDR,
input logic [7:0] pointsRGB,

output	logic	[7:0] RGBOut
);

logic flag_playBall1;

always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN) begin
			RGBOut	<= 8'b0;
			flag_playBall1 <= 0;
	end
	else begin

		if(sightDR)
			RGBOut <= sightRGB;
		else if (whiteBallDR)   
			RGBOut <= whiteBallRGB;		
		else if(playBall1DR)
			RGBOut <= playBall1RGB;
		else if(playBall2DR)
			RGBOut <= playBall2RGB;
		else if(playBall3DR)
			RGBOut <= playBall3RGB;
		else if(playBall4DR)
			RGBOut <= playBall4RGB;
		else if(numberDR)
			RGBOut <= numberRGB;		 
		else if(targetDR)
			RGBOut <= targetRGB;
		else if(pointsDR)
			RGBOut <= pointsRGB;		
		else if(holeDR)
			RGBOut <= holeRGB;
		else if(orangePortalDR)
			RGBOut <= orangePortalRGB;
		else if(bluePortalDR)
			RGBOut <= bluePortalRGB;
		else if(startDR)
			RGBOut <= startRGB;
		else if(confettiDR)
			RGBOut <= confettiRGB;
		else if(winDR)
			RGBOut <= winRGB;
		else if(loseDR)
			RGBOut <= loseRGB;
		else 
			RGBOut <= backGroundRGB; //default
	end
end

endmodule


