
// game controller dudy Febriary 2020
// (c) Technion IIT, Department of Electrical Engineering 2021 
//updated --Eyal Lev 2021


module	game_controller
(	
input	logic	clk,
input	logic	resetN,
input	logic	startOfFrame,  // short pulse every start of frame 30Hz 

//draw requests
input	logic	whiteBallDR,
input logic playBall1DR,
input logic playBall2DR,
input logic playBall3DR,
input logic playBall4DR,
input	logic	borderDR,
input logic numberDR,
input logic holeDR,
input logic orangePortalDR,
input logic bluePortalDR,


input logic win,
input logic finishCount,

output logic SingleHitPulse, // critical code, generating A single pulse in a frame 
//collisions
output logic colTwoBalls, //any collision

//border collisions
output logic col0Border,
output logic col1Border,
output logic col2Border,
output logic col3Border,
output logic col4Border,

//hole collisions
output logic col0Hole,
output logic col1Hole,
output logic col2Hole,
output logic col3Hole,
output logic col4Hole,

//ball collisions
output logic col01,
output logic col02,
output logic col03,
output logic col04,
output logic col12,
output logic col13,
output logic col14,
output logic col23,
output logic col24,
output logic col34,

//specific balls
output logic col0,
output logic col1,
output logic col2,
output logic col3,
output logic col4,

//portal collisions
output logic colOP0,
output logic colOP1,
output logic colOP2,
output logic colOP3,
output logic colOP4,

output logic colBP0,
output logic colBP1,
output logic colBP2,
output logic colBP3,
output logic colBP4,

output logic col0Sling,

output logic [3:0] soundController,
output logic enableSound,
output logic anySound
);

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//assignments
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//border collisions
assign col0Border = whiteBallDR && borderDR;
assign col1Border = playBall1DR && borderDR;
assign col2Border = playBall2DR && borderDR;
assign col3Border = playBall3DR && borderDR;
assign col4Border = playBall4DR && borderDR;

//any collision between ball and border
assign colBorder = col0Border || col1Border || col2Border || col3Border || col4Border;

//hole collisions
assign col0Hole = whiteBallDR && holeDR;
assign col1Hole = playBall1DR && holeDR;
assign col2Hole = playBall2DR && holeDR;
assign col3Hole = playBall3DR && holeDR;
assign col4Hole = playBall4DR && holeDR;

//play ball (not black) hole collision
assign colPlayHole = col1Hole || col2Hole || col3Hole;

//ball collisions
assign col01 = whiteBallDR && playBall1DR;
assign col02 = whiteBallDR && playBall2DR;
assign col03 = whiteBallDR && playBall3DR;
assign col04 = whiteBallDR && playBall4DR;
assign col12 = playBall1DR && playBall2DR;
assign col13 = playBall1DR && playBall3DR;
assign col14 = playBall1DR && playBall4DR;
assign col23 = playBall2DR && playBall3DR;
assign col24 = playBall2DR && playBall4DR;
assign col34 = playBall3DR && playBall4DR;

//portal collisions

assign colOP0 = orangePortalDR && whiteBallDR;
assign colOP1 = orangePortalDR && playBall1DR;
assign colOP2 = orangePortalDR && playBall2DR;
assign colOP3 = orangePortalDR && playBall3DR;
assign colOP4 = orangePortalDR && playBall4DR;

assign colBP0 = bluePortalDR && whiteBallDR;
assign colBP1 = bluePortalDR && playBall1DR;
assign colBP2 = bluePortalDR && playBall2DR;
assign colBP3 = bluePortalDR && playBall3DR;
assign colBP4 = bluePortalDR && playBall4DR;


///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//specific ball collision commands
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

assign col0 = col01 || col02 || col03 || col04; //&& other collisions
assign col1 = col01 || col12 || col13 || col14; //&& other collisions
assign col2 = col02 || col12 || col23 || col24; //&& other collisions
assign col3 = col03 || col13 || col23 || col34;
assign col4 = col04 || col14 || col24 || col34;

// any collision between two balls
assign colTwoBalls = col0 || col1 || col2 || col3 || col4;

// any sound
assign anySound = colBorder || col0Hole || colPlayHole || col4Hole || colTwoBalls || win;

assign col0Sling = col0 || col0Hole || col0Border;

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
		
		if(col01 && !flag)
			begin
				flag <= 1;
				SingleHitPulse <= 1;
			end

		if((col0Border || col1Border || col0Hole || col1Hole) && !flag)
		begin 
			flag	<= 1'b1; // to enter only once 
		end 
	end 
end

always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN)
		soundController <= 4'b0000;
	else begin
		if(colBorder)
			soundController <= 4'b0001;
		else if (col0Hole)
			soundController <= 4'b0010;
		else if (colPlayHole)
			soundController <= 4'b0011;
		else if (col4Hole)
			soundController <= 4'b0100;
		else if (colTwoBalls)
			soundController <= 4'b0101;
		else if (win)
			soundController <= 4'b0110;
	end
end

always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN)
		enableSound <= 1'b0;
	else begin
		if(anySound)
			enableSound <= 1'b1;
		else if (finishCount)
			enableSound <= 1'b0;
	end
end
endmodule
