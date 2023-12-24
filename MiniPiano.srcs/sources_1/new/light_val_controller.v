`timescale 1ns / 1ps
`include "define.v"
module light_val_controller (
    input [1:0] _mode,
    input [6:0] num,
    input [11:0] score,
    input [2:0] cur_note_alter,
    input [1:0] grade,
    output reg [31:0] val_7seg
);

    always @(*) begin
        if (_mode == `M_AUTO) begin
            val_7seg[6:0]  = num;
            val_7seg[31:7] = 0;  //set last 7 as num
        end else if (_mode == `M_LEARN) begin
            val_7seg[11:0] = score;  //show score in this mode
            if(grade == `G_S) val_7seg[31:12] = 20'h05000;
            if(grade == `G_A) val_7seg[31:12] = 20'h0a000;
            if(grade == `G_B) val_7seg[31:12] = 20'h0b000;
            if(grade == `G_C) val_7seg[31:12] = 20'h0c000;
        end else if (_mode == `M_ALTER) begin
           val_7seg = cur_note_alter;
        end else begin
            val_7seg = 32'd0;  //nothing to show then
        end
    end
endmodule
