`timescale 1ns / 1ps
`include "define.v"
module light_val_controller (
    input [1:0] _mode,
    input [6:0] num,
    input [11:0] score,
    input [2:0] cur_note_alter,
    output reg [31:0] val_7seg
);

    always @(*) begin
        if (_mode == `M_AUTO) begin
            val_7seg[6:0]  = num;
            val_7seg[31:7] = 0;  //set last 7 as num
        end else if (_mode == `M_LEARN) begin
            val_7seg = {20'h00000,score};  //show score in this mode
        end else if (_mode == `M_ALTER) begin
           val_7seg = cur_note_alter;
        end else begin
            val_7seg = 32'd0;  //nothing to show then
        end
    end
endmodule
