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
                7'b0000001: note = `DO + _oct;
                7'b0000010: note = `RE + _oct;
                7'b0000100: note = `MI + _oct;
                7'b0001000: note = `FA + _oct;
                7'b0010000: note = `SO + _oct;
                7'b0100000: note = `LA + _oct;
                7'b1000000: note = `SI + _oct;
                default: note = 5'b00000 + _oct;
            endcase
        end else note = 5'b00000;//not selected
    end
endmodule
