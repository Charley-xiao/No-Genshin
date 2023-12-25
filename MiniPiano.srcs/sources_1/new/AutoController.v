`timescale 1ns / 1ps
`include "define.v"
module AutoController (
    input rset,
    input clk,
    input [6:0] num,
    input [1:0] _mode,
    input paused,
    output reg [4:0] note
);
    reg mrset;  //memorized reset
    initial begin
        mrset = 0;
    end
    wire [700:0] pcs;  //pieces
    wire [300:0] len;  //length of pieces
    wire [7:0] is;
    reg [31:0] counter;
    reg [31:0] rest_counter;
    integer i;

    wire [2:0] pseudo;  //not needed in this way


    Library ml (
        .num(num),
        .pcs(pcs),
        .len(len),
        .scale(pseudo),
        .is(is)
    );

    always @(posedge clk) begin
        if (mrset != rset) begin
            i <= is;
            mrset <= rset;
        end
        if (_mode == `M_AUTO && paused == 1)begin
        note<=0;
        end  
      else if (_mode == `M_AUTO && paused == 0) begin
            if (counter == 0) begin
                i <= is;
                note <= pcs[i*5+:5];  // pieces with 5 as length
                case (len[i*2+:2])
                    `LEN_1_2:  counter <= `CNT_1_2;  //1/2
                    `LEN_1_4:  counter <= `CNT_1_4;  //1/4
                    `LEN_1_8:  counter <= `CNT_1_8;  //1/8
                    `LEN_1_16: counter <= `CNT_1_16;  //1/16
                    default:   counter <= `CNT_1_2;
                endcase
                if (i == 0) begin
                    i <= is;  //reset to the length of the song
                end else begin
                    i <= i - 1;
                end
            end else begin
                counter <= counter - 1;
                if (counter < `AUTO_TIMEOUT) note <= 0;
            end
            
        end
    end
endmodule
