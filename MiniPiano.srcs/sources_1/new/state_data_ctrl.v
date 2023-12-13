module state_data_ctrl(
    input clk,
    input rst,
	input [1:0] mode,
    output reg [35: 0] data
);
    parameter non_act = 4'b0000;
    parameter none_s = 4'b0001;
    parameter none_s_2 = 4'b0110;
    parameter start = 4'b0010;
    parameter move = 4'b0011;
    parameter switch = 4'b0100;
    parameter reverse = 4'b0101;

    always @ (posedge clk,negedge rst)
	begin
		if (!rst) begin
			data <= 6'b11_1110;
		end
        else begin
            case (mode)
            2'b01: begin
                    data <= 36'b111110_111110_111110_010101_010111_111110; //LEARN              
            end
            2'b10: begin
                data <= 36'b111110_001010_011110_011101_011000_111110; //AUTO
            end
            2'b11: begin
                data <= 36'b111110_111110_111110_010010_010111_111110;// IN

            end
            default: begin
                data <= 36'b111110_111110_111110_111110_111110_111110;//blank
            end
            endcase
        end
	end

endmodule