
module correctTargetCheck 	
 ( 
	input	logic  clk,
	input	logic  resetN,	
	input	logic increasePoint,
	input logic [10:0] targetX,
	input logic [10:0] targetY,
	input logic [10:0] playBall1X,
	input logic [10:0] playBall1Y,
	input logic [10:0] playBall2X,
	input logic [10:0] playBall2Y,
	input logic [10:0] playBall3X,
	input logic [10:0] playBall3Y,
	input logic [10:0] playBall4X,
	input logic [10:0] playBall4Y,
	input logic col1Hole,
	input logic col2Hole,
	input logic col3Hole,
	input logic col4Hole,
	output logic correctTarget
  ) ;
  
always_ff @(posedge clk or negedge resetN) begin
		if (!resetN) begin
			correctTarget <= 0;
		end
		
		else begin
			if (increasePoint) 
			begin
				if (col1Hole)
				begin
					if ((targetX - 40 < playBall1X) && (playBall1X < targetX + 40) && (targetY - 32 < playBall1Y) && (playBall1Y < targetY + 32))
						correctTarget <= 1;
					else correctTarget <= 0;
				end
				else if (col2Hole)
				begin
					if ((targetX - 40 < playBall2X) && (playBall2X < targetX + 40) && (targetY - 32 < playBall2Y) && (playBall2Y < targetY + 32))
						correctTarget <= 1;
					else correctTarget <= 0;
				end
				else if (col3Hole)
				begin
					if ((targetX - 40 < playBall3X) && (playBall3X < targetX + 40) && (targetY - 32 < playBall3Y) && (playBall3Y < targetY + 32))
						correctTarget <= 1;
					else correctTarget <= 0;
				end
				else if (col4Hole)
				begin
					if ((targetX - 40 < playBall4X) && (playBall4X < targetX + 40) && (targetY - 32 < playBall4Y) && (playBall4Y < targetY + 32))
						correctTarget <= 1;
					else correctTarget <= 0;				
				end
			end
			else correctTarget <= 0;				
		end
	
end
 
endmodule

