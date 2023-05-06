
module holeTargetMux 	
 ( 
	input	logic  clk,
	input	logic  resetN,	
	input	logic unsigned	[2:0] hole,
	output logic unsigned [10:0] targetX,
	output logic unsigned [10:0] targetY
  ) ;
	
always_ff @(posedge clk or negedge resetN) begin
		if (!resetN) begin
				targetX <= 32'b00000110000; // 48
				targetY <= 32'b00000100000 ; // 32
		end
		
		else begin
			if (hole == 3'b000) 
			begin
				targetX <= 32'b00000110000; // 48
				targetY <= 32'b00000100000 ; // 32
			end
			else if (hole == 3'b001)			
			begin
				targetX <= 32'b00100110000 ; // 304
				targetY <= 32'b00000100000 ; // 32
			end
			else if (hole == 3'b010)			
			begin
				targetX <= 32'b01000110000 ; // 560
				targetY <= 32'b00000100000 ; // 32
			end
			else if (hole == 3'b011)
			begin
				targetX <= 32'b00000110000; // 48
				targetY <= 32'b00110100000  ; // 416
			end
			else if (hole == 3'b100)
			begin
				targetX <= 32'b00100110000 ; // 304
				targetY <= 32'b00110100000  ; // 416
			end
			else if (hole == 3'b101)
			begin
				targetX <= 32'b01000110000 ; // 560
				targetY <= 32'b00110100000  ; // 416
			end	
		end
	
end
 
endmodule

