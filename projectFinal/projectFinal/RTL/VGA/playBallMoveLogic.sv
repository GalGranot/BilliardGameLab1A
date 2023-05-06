// (c) Technion IIT, Department of Electrical Engineering 2021 
//-- Alex Grinshpun Apr 2017
//-- Dudy Nov 13 2017
// SystemVerilog version Alex Grinshpun May 2018
// coding convention dudy December 2018
// updaed Eyal Lev Feb 2021

/*

Comments:


Tasks:

	
Code to use later:


*/


module	playBallMoveLogic
(	
	input	logic	clk,
	input	logic	resetN,
	input	logic	startOfFrame,  // short pulse every start of frame 30Hz 
	
	//collision inputs
	input logic collisionBallBorder,
	input	logic	[3:0] HitEdgeCode, //one bit per edge
	input logic collisionTwoBalls,
	input int xSpeedNew,
	input int ySpeedNew,
	input logic inHole,
	
	input logic colOP,
	input logic colBP,

	
	//later - collisions between ball1 and all other balls

	output logic signed 	[10:0]	topLeftX, // output the top left corner 
	output logic signed	[10:0]	topLeftY,  // can be negative , if the object is partliy outside
	output int xSpeed,
	output int ySpeed,
	output logic stopPlayBall,
	output killBall
	
);


// a module used to generate the  ball trajectory.

parameter int INITIAL_X = 280;
parameter int INITIAL_Y = 185;
parameter int INITIAL_X_SPEED = 0;
parameter int INITIAL_Y_SPEED = 0;
parameter int minSpeed = 2;
parameter int zeroSpeed = 0;
const int  friction = 1;

const int	FIXED_POINT_MULTIPLIER	=	64;
// FIXED_POINT_MULTIPLIER is used to enable working with integers in high resolution so that 
// we do all calculations with topLeftX_FixedPoint to get a resolution of 1/64 pixel in calcuatuions,
// we devide at the end by FIXED_POINT_MULTIPLIER which must be 2^n, to return to the initial proportions
const int x_FRAME_SIZE	=	639 * FIXED_POINT_MULTIPLIER; // note it must be 2^n 
const int y_FRAME_SIZE	=	479 * FIXED_POINT_MULTIPLIER;
const int bracketOffset =	30;
const int OBJECT_WIDTH_X = 64;

const int maxSpeed = 230;

 // local parameters 
int topLeftX_FixedPoint;
int topLeftY_FixedPoint;
int collisionWithHoleCtr;


logic flag_collisionBallBorder;
logic flag_collisionTwoBalls;
logic flag_killBall;
logic flag_OP;
logic flag_BP;

const int orangePortalX = 440 * FIXED_POINT_MULTIPLIER;
const int orangePortalY = 338 * FIXED_POINT_MULTIPLIER;
const int bluePortalX = 220 * FIXED_POINT_MULTIPLIER;
const int bluePortalY = 110 * FIXED_POINT_MULTIPLIER;
const int maxPortalCtr = 10;
int orangePortalCtr; int bluePortalCtr;
const int ballWidth = 32 * FIXED_POINT_MULTIPLIER;

const int topBorderY = 32 * FIXED_POINT_MULTIPLIER;
const int bottomBorderY = 416 * FIXED_POINT_MULTIPLIER;
const int leftBorderX = 48 * FIXED_POINT_MULTIPLIER;
const int rightBorderX = 560 * FIXED_POINT_MULTIPLIER;
int penetrationDepth = 2 * FIXED_POINT_MULTIPLIER;

int stopCtr;
const int maxStopCtr = 10;
logic flag_stop;




always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN)
	begin 
		xSpeed <= INITIAL_X_SPEED;
		ySpeed <= INITIAL_Y_SPEED;
		topLeftX_FixedPoint <= INITIAL_X * FIXED_POINT_MULTIPLIER;
		topLeftY_FixedPoint <= INITIAL_Y * FIXED_POINT_MULTIPLIER;
		stopPlayBall <= 0;
		killBall <= 0;
		flag_killBall <= 0;
		collisionWithHoleCtr <= 0;
		orangePortalCtr <= 0;
		bluePortalCtr <= 0;
		flag_OP <= 0;
		flag_BP <= 0;
		stopCtr <= 0;
		flag_stop <= 0;
	end //reset
	
	else begin
	
		//limit position
		if(topLeftX_FixedPoint <= leftBorderX - penetrationDepth)
			topLeftX_FixedPoint <= leftBorderX + penetrationDepth;
		if(topLeftX_FixedPoint >= rightBorderX + penetrationDepth)
			topLeftX_FixedPoint <= rightBorderX - penetrationDepth;
			
		if(topLeftY_FixedPoint <= topBorderY - penetrationDepth)
			topLeftY_FixedPoint <= topBorderY + penetrationDepth;
		if(topLeftY_FixedPoint >= bottomBorderY + penetrationDepth)
			topLeftY_FixedPoint <= bottomBorderY - penetrationDepth;

		
		//limit speed
		if(xSpeed > maxSpeed)
			xSpeed <= maxSpeed;
		if(xSpeed < -maxSpeed)
			xSpeed <= -maxSpeed;
		if(ySpeed > maxSpeed)
			ySpeed <= maxSpeed;
		if(ySpeed < -maxSpeed)
			ySpeed <= -maxSpeed;
			
		//portal logic
		if(colOP && !flag_OP && orangePortalCtr <= maxPortalCtr)
			orangePortalCtr <= orangePortalCtr + 1;
		if(colBP && !flag_BP && bluePortalCtr <= maxPortalCtr)
			bluePortalCtr <= bluePortalCtr + 1;
			
		if(orangePortalCtr >= maxPortalCtr)
		begin
			flag_OP <= 1;
			orangePortalCtr <= 0;
		end
		if(bluePortalCtr >= maxPortalCtr)
		begin
			flag_BP <= 1;
			bluePortalCtr <= 0;
		end
		
		if(flag_OP)
		begin
			if(xSpeed >= 0)
				topLeftX_FixedPoint <= bluePortalX + ballWidth;
			else
				topLeftX_FixedPoint <= bluePortalX - ballWidth;
			if(ySpeed >= 0)
				topLeftY_FixedPoint <= bluePortalY + ballWidth;
			else
				topLeftY_FixedPoint <= bluePortalY - ballWidth;
		end
		
		if(flag_BP)
		begin
			if(xSpeed >= 0)
				topLeftX_FixedPoint <= orangePortalX + ballWidth;
			else
				topLeftX_FixedPoint <= orangePortalX - ballWidth;
			if(ySpeed >= 0)
				topLeftY_FixedPoint <= orangePortalY + ballWidth;
			else
				topLeftY_FixedPoint <= orangePortalY - ballWidth;
		end
			
		//border collisions
		if(collisionBallBorder && !flag_collisionBallBorder)
		begin
			flag_collisionBallBorder <= 1;
			//collision with corners
			if
			(
				(HitEdgeCode[0] && HitEdgeCode[1]) ||
				(HitEdgeCode[0] && HitEdgeCode[3]) ||
				(HitEdgeCode[1] && HitEdgeCode[2]) ||
				(HitEdgeCode[2] && HitEdgeCode[3])
			)
			begin
				xSpeed <= -xSpeed;
				ySpeed <= -ySpeed;
			end
			//collisions with borders
			else begin
				if(HitEdgeCode[1] || HitEdgeCode[3])
					xSpeed <= -xSpeed;
				if(HitEdgeCode[0] || HitEdgeCode[2])
					ySpeed <= -ySpeed;
			end
		end //border collisions
		
		//ball collisions
		if(collisionTwoBalls && !flag_collisionTwoBalls)
		begin
			flag_collisionTwoBalls <= 1;
			xSpeed <= xSpeedNew;
			ySpeed <= ySpeedNew;
		end //ball collisions
		
		//hole collisions
		if(inHole && collisionWithHoleCtr <= 2)
			collisionWithHoleCtr <= collisionWithHoleCtr + 1;
		if(inHole && !flag_killBall && collisionWithHoleCtr >= 2)
			flag_killBall <= 1;
			
		if(flag_killBall)
		begin
			xSpeed <= zeroSpeed;
			ySpeed <= zeroSpeed;
			stopPlayBall <= 1;
			killBall <= 1;
		end
		else
			killBall <= 0;
		//hole collisions
		
		if (startOfFrame)
		begin
			//flag reset
			flag_OP <= 0;
			flag_BP <= 0;
			flag_collisionBallBorder <= 0;
			flag_collisionTwoBalls <= 0;
			
			//end of roll
			if(!xSpeed && !ySpeed && stopCtr <= maxStopCtr)
				stopCtr <= stopCtr + 1;
			if(stopCtr >= maxStopCtr && !flag_stop)
			begin
				stopCtr <= 0;
				flag_stop <= 1;
				stopPlayBall <= 1;
			end				
			if(xSpeed || ySpeed)
			begin
				flag_stop <= 0;
				stopPlayBall <= 0;
			end

			
			//position interpolation
			topLeftX_FixedPoint  <= topLeftX_FixedPoint + xSpeed;
			topLeftY_FixedPoint  <= topLeftY_FixedPoint + ySpeed;
			
			//x friction
			if(xSpeed >= minSpeed)
				xSpeed <= xSpeed - friction;
			if(xSpeed <= -minSpeed)
				xSpeed <= xSpeed + friction;
			if(xSpeed < minSpeed && xSpeed > -minSpeed)
				xSpeed <= zeroSpeed;
			//y friction
			if(ySpeed >= minSpeed)
				ySpeed <= ySpeed - friction;
			if(ySpeed <= -minSpeed)
				ySpeed <= ySpeed + friction;
			if(ySpeed < minSpeed && ySpeed > -minSpeed)
				ySpeed <= zeroSpeed;
			
			
			
			/*//end of roll
			if(!xSpeed && !ySpeed)
				stopPlayBall <= 1;
			else
				stopPlayBall <= 0;*/
		end
	end
end 


//get a better (64 times) resolution using integer   
assign topLeftX = topLeftX_FixedPoint / FIXED_POINT_MULTIPLIER ;   // note it must be 2^n 
assign topLeftY = topLeftY_FixedPoint / FIXED_POINT_MULTIPLIER ;    


endmodule

