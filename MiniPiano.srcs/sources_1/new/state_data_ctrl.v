module state_data_ctrl (
    input clk,
    input rst,
    input [1:0] mode,
    output reg [35:0] data
);

    always @(posedge clk, negedge rst) begin
        if (!rst) begin
            data <= 6'b11_1110;  //reset, all zero
        end else begin
            case (mode)
                2'b01: begin
                    data <= 36'b111110_111110_111110_010101_010111_111110;  //LEARN              
                end
                2'b10: begin
                    data <= 36'b111110_001010_011110_011101_011000_111110;  //AUTO
                end
                2'b11: begin
                    data <= 36'b111110_111110_111110_010010_010111_111110;  //IN
                end
                default: begin
                    data <= 36'b111110_111110_111110_111110_111110_111110;  //blank
                end
            endcase
        end
    end

endmodule
