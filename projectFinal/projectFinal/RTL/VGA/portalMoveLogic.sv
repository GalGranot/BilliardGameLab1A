module portalMoveLogic

(

//system
input logic clk,
input logic resetN,

output logic signed [10:0] topLeftXBlue,
output logic signed [10:0] topLeftYBlue,

output logic signed [10:0] topLeftXOrange,
output logic signed [10:0] topLeftYOrange
);

logic flag;

always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN)
	begin
		topLeftXBlue <= 0;
		topLeftYBlue <= 0;
		topLeftXOrange <= 0;
		topLeftYOrange <= 0;
	end
	
	else begin
		/*topLeftXBlue <= 11'b00101000000; //320
		topLeftYBlue <= 11'b00010101011; //171
		topLeftXOrange <= 11'b00101000000; //320
		topLeftYOrange <= 11'b00100110110; //310*/
		
		topLeftXBlue <= 11'b00011011100; //220
		topLeftYBlue <= 11'b00001101110; //110
		topLeftXOrange <= 11'b00110111000; //440
		topLeftYOrange <= 11'b00101010010; //338

	end
end

endmodule
