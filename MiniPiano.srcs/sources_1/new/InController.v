`timescale 1ns / 1ps
`include "define.v"
module InController(
    input [6:0] sel,
    input [1:0] octave,
    input [1:0] _mode,
    output reg [4:0] note
);
    reg [4:0] _oct;
    always @(*) begin
        // octave change
        _oct = (octave == `OCT_LOW) ? `OCT_LOW_P : (
            (octave == `OCT_MID) ? `OCT_MID_P : `OCT_HGH_P
        );  
        if(_mode == `M_IN) begin
            case(sel) //play with differect input
                7'b0000001: note = 5'b00001 + _oct;
                7'b0000010: note = 5'b00010 + _oct;
                7'b0000100: note = 5'b00011 + _oct;
                7'b0001000: note = 5'b00100 + _oct;
                7'b0010000: note = 5'b00101 + _oct;
                7'b0100000: note = 5'b00110 + _oct;
                7'b1000000: note = 5'b00111 + _oct;
                default: note = 5'b00000 + _oct;
            endcase
        end else note = 5'b00000;//not selected
    end
endmodule
