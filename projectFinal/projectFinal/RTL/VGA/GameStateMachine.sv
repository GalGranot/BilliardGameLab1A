
module GameStateMachine
	(
input logic clk, 
input logic resetN, 
input logic startN, 
input logic whiteHoleCollision,
input logic playBallHoleCollision,	
input logic endOfRoll, 
input logic allBallsin,
input logic blackHoleCollision,
input logic whiteBallMove,
input logic startOfFrame,
input logic hardMode,
input logic hardModeN,

output logic idleState,
output logic init0,
output logic initPlayBalls,
output logic hitEnable,
output logic whiteBallin,
output logic win,
output logic lose,
output logic drawSight,
output logic startOfTurn,
output logic drawPortals
   );
	
//states
enum logic [2:0] {s_idle, s_initLocations, s_roll, s_newHit, s_whiteBallin, s_winGame, s_loseGame} game_ps, game_ns; 	
	

//--------------------------------------------------------------------------------------------
always @(posedge clk or negedge resetN)
   begin 
		if (!resetN)
			begin
				game_ps <= s_idle;
	
			end
		else
			game_ps <= game_ns;	
	end
	
	
//--------------------------------------------------------------------------------------------	
always_comb
begin

	game_ns = game_ps; 
	idleState = 0;
	init0 = 0;
	initPlayBalls = 0;
	hitEnable = 0;
	whiteBallin = 0;
	win = 0;
	lose = 0;
	drawSight = 0;
	startOfTurn = 0;
	drawPortals = 0;

	case (game_ps)
		
		s_idle: begin
		
			idleState = 1;
			if (!startN || !hardModeN)
			game_ns = s_initLocations;
		end // idle
		
		s_initLocations: begin
		
		init0 = 1;
		initPlayBalls = 1;
		game_ns = s_newHit;
		end // initLocations

		s_newHit: begin
		drawSight = 1;
		hitEnable = 1;
		startOfTurn = 1;
		if (allBallsin && blackHoleCollision)
		begin
			win = 1;
			game_ns = s_winGame;
		end
		if (blackHoleCollision && !allBallsin)
			begin
				game_ns = s_loseGame;
			end		
		if (whiteBallMove)
			game_ns = s_roll;
		end // newHit
		
		s_roll: begin
		
		if(hardMode)
			drawPortals = 1;
			
		if(allBallsin && blackHoleCollision)
		begin
			win = 1;
			game_ns = s_winGame;
		end
		if (blackHoleCollision && !allBallsin)
		begin
			lose = 1;
			game_ns = s_loseGame;
		end
		
			
		if (whiteHoleCollision)
			begin
				game_ns = s_whiteBallin;
			end
		
		else if (endOfRoll)
			begin
				game_ns = s_newHit;
			end
		end // roll
		
		s_whiteBallin: begin
		whiteBallin = 1;
		init0 = 1;
		game_ns = s_newHit;
		end // whiteBallin
				
		s_winGame: begin
			win = 1;

			if (!startN)
				game_ns = s_idle;
			end // winGame
		
		s_loseGame: begin

		lose = 1;
			if (!startN)
				game_ns = s_idle;
			end // loseGame

	endcase
end
	
endmodule
