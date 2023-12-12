`timescale 1ns / 1ps
`include "define.v"
module AutoController(
    input rset,
    input clk,
    input [6:0] num,
    input [1:0] _mode,
    output reg [4:0] note
);
    reg mrset;
    initial begin mrset = 0; end
    wire [700:0] pcs;
    wire [300:0] len;
    wire [7:0] is;
    reg [31:0] counter;
    reg [31:0] rest_counter;
    integer i;

    wire [2:0] pseudo;
  

    Library ml(
        .num(num),
        .pcs(pcs),
        .len(len),
        .scale(pseudo),
        .is(is)
    );
 
//how to translateï¼ˆpassï¼? scale from ml to buzzer?ï¼ˆs3 and s0ï¼?
    always @(posedge clk) begin
        if(mrset != rset) begin 
            i <= is;
            mrset <= rset;
        end
        if(_mode == `M_AUTO) begin
            if (counter == 0) begin
                i <= is;
                note <= pcs[i*5 +: 5];
                case (len[i*2 +: 2])
                    2'b00: counter <= 160000000; 
                    2'b01: counter <= 80000000; 
                    2'b10: counter <= 40000000;
                    2'b11: counter <= 20000000; 
                    default: counter <= 160000000;
                endcase
                if (i == 0) begin
                    i <= is; //resett to the length of the song
                end else begin
                    i <= i - 1;
                end
            end else begin
                counter <= counter - 1;
                if(counter < 5000000) note <= 0;
            end
        end
    end
endmodule
