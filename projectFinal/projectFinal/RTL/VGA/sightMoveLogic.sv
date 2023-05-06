module sightMoveLogic

(

//system
input logic clk,
input logic resetN,
input logic startOfFrame,
input logic startOfTurn,
input logic keyEnter,
input logic stop0,


//white ball
input logic signed [10:0] topLeftX_WhiteBall,
input logic signed [10:0] topLeftY_WhiteBall,

output logic signed [10:0] topLeftX,
output logic signed [10:0] topLeftY
);

logic flag;

always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN)
	begin
		topLeftX <= 440;
		topLeftY <= 224;
	end
	
	else begin
		if(startOfFrame)
		begin
			if(!flag)
			begin
				flag <= 1;
				topLeftX <= topLeftX_WhiteBall;
				topLeftY <= topLeftY_WhiteBall;
			end
			if(!stop0)
				flag <= 0;
		end
		
	end
end

endmodule
