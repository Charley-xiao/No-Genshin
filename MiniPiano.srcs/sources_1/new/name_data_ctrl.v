module name_data_ctrl (
    input clk,
    input rst,
    input [6:0] num,
    input [1:0] mode,
    output reg [59:0] data
);
    always @(posedge clk, negedge rst) begin
        if (!rst | mode == `M_IN) begin
            data <= 60'b111110_111110_111110_111110_111110_111110_111110_111110_111110_111110; //reset, all zero
        end else begin
            case (num)
                7'b0: begin
                    //LITTLESTAR
                    data <= 60'b010101_010010_011101_011101_010101_001110_011100_011101_001010_011011;
                end
                7'b1: begin
                    //GENSHINREX 
                    data <= 60'b010000_001110_010111_011100_010001_010010_010111_011011_001110_100001;
                end
                7'b10: begin
                    //MY RAILGUN 
                    data <= 60'b010110_100010_111110_011011_001010_010010_010101_010000_011110_010111;
                end
                7'b11: begin
                    //  TANGKO   
                    data <= 60'b111110_111110_011101_001010_010111_010000_010100_011000_111110_111110;
                end
                default: begin
                    data <= 60'b111110_111110_111110_111110_111110_111110_111110_111110_111110_111110;  //blank
                end
            endcase
        end
    end

endmodule
