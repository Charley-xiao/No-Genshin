`timescale 1ns / 1ps
`include "define.v"
module light_val_controller (
    input [1:0] _mode,
    input [6:0] num,
    input [11:0] score,
    input [2:0] cur_note_alter,
    input [1:0] grade,
    input [7:0] user_id,
    output reg [31:0] val_7seg
);

    always @(*) begin
        if (_mode == `M_AUTO) begin
            val_7seg[7:0]  = num;
            val_7seg[31:8] = 24'hffffff;  //set last 7 as num
        end else if (_mode == `M_LEARN) begin
            val_7seg[11:0]  = score;  //show score in this mode
            val_7seg[23:16] = user_id;
            val_7seg[27:24] = 4'hf;
            val_7seg[15:12] = 4'hf;
            if (grade == `G_S) val_7seg[31:28] = 4'h5;
            if (grade == `G_A) val_7seg[31:28] = 4'ha;
            if (grade == `G_B) val_7seg[31:28] = 4'hb;
            if (grade == `G_C) val_7seg[31:28] = 4'hc;
        end else if (_mode == `M_ALTER) begin
            val_7seg[3:0]  = cur_note_alter;
            val_7seg[31:4] = 28'hfffffff;
        end else begin
            val_7seg = 32'hffffffff;  //nothing to show then
        end
    end
endmodule
