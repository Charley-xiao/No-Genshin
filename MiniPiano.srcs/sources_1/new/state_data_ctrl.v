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
               `M_LEARN: begin
                    data <= 36'b111110_111110_111110_010101_010111_111110;  //LEARN              
                end
                `M_AUTO: begin
                    data <= 36'b111110_001010_011110_011101_011000_111110;  //AUTO
                end
               `M_IN: begin
                    data <= 36'b111110_111110_111110_010010_010111_111110;  //IN
                end
                 `M_ALTER: begin
                    data <= 36'b111110_001010_010101_011101_111110_111110;  //ALT
                end
            endcase
        end
    end

endmodule
