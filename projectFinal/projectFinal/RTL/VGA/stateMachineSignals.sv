module stateMachineSignals

(
input logic clk,
input logic resetN,
input logic stop0, stop1, stop2, stop3, stop4,
input logic col1Hole, col2Hole, col3Hole, col4Hole,
input logic killBall1, killBall2, killBall3, killBall4,
input logic hitEnableStateMachine, keyEnter,
input logic whiteBallIn, whiteInitLoc,
input logic hardModeN,

output logic endOfRoll,
output logic allBallsIn,
output logic hitEnable,
output logic increasePoint,
output logic init0,
output logic whiteBallMove,
output logic flag_hardMode,
output logic playBallIn,
output logic col1,
output logic col2,
output logic col3,
output logic col4
);

logic flagcol1;
logic flagcol2;
logic flagcol3;
logic flagcol4;


always_ff @(posedge clk or negedge resetN) begin
	if (!resetN) begin
		flagcol1 <= 0;
		flagcol2 <= 0;
		flagcol3 <= 0;
		flagcol4 <= 0;
		flag_hardMode <= 0;
		col1 <= 0;
		col2 <= 0;
		col3 <= 0;
		col4 <= 0;
	end
	
	else begin
		if(col1Hole && !flagcol1)
		begin
			flagcol1 <= 1;
			col1 <= 1;
		end
		else col1 <= 0;
		if(col2Hole && !flagcol2)
		begin
			flagcol2 <= 1;
			col2 <= 1;
		end
		else col2 <= 0;
		if(col3Hole && !flagcol3)
		begin
			flagcol3 <= 1;
			col3 <= 1;
		end
		else col3 <= 0;
		if(col4Hole && !flagcol4)
		begin
			flagcol4 <= 1;
			col4 <= 1;
		end
		else col4 <= 0;
		
		if(!hardModeN)
			flag_hardMode <= 1;
	end
end
 



assign playBallIn = col1Hole || col2Hole || col3Hole || col4Hole;
assign endOfRoll = stop0 && stop1 && stop2 && stop3 && stop4;
assign increasePoint = col1 || col2 || col3 || col4;
assign allBallsIn = killBall1 && killBall2 && killBall3;
assign hitEnable = keyEnter && hitEnableStateMachine;
assign init0 = whiteBallIn || whiteInitLoc;
assign whiteBallMove = !stop0;

endmodule
