
module light_7seg_ego(input [6:0]sw, input rst,input [1:0] _mode,output reg [7:0] seg_out,output reg tub_sel);

    always @ * begin
            tub_sel = 1;
            if(_mode != 2'b10) begin 
                seg_out=0; 
            end
            else if(rst)begin
            seg_out = 8'b1111_1100;
            end
            else begin
                case(sw)
            7'h0: seg_out = 8'b1111_1100; //0
            7'h1: seg_out = 8'b0110_0000; //1
            7'h2: seg_out = 8'b1101_1010; //2
            7'h3: seg_out = 8'b1111_0010; //3
            7'h4: seg_out = 8'b0110_0110; //4
            7'h5: seg_out = 8'b1011_0110; //5
            7'h6: seg_out = 8'b1011_1110; //6
            7'h7: seg_out = 8'b1110_0000; //7
            7'h8: seg_out = 8'b1111_1110; //8
            7'h9: seg_out = 8'b1110_0110; //9
            7'ha: seg_out = 8'b1110_1110; //A
            7'hb: seg_out = 8'b0011_1110; //B
            7'hc: seg_out = 8'b1001_1100; //C
            7'hd: seg_out = 8'b0111_1010; //D
            7'he: seg_out = 8'b1001_1110; //E
            7'hf: seg_out = 8'b1000_1110; //F
            default: seg_out = 8'b0000_0001;
        endcase    
            end end
endmodule
