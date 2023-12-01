`timescale 1ns / 1ps
`include "define.v"
module light_val_controller(
    input _mode,
    input [6:0] num,
    output reg [31:0] val_7seg
    );
    
    always @(*) begin 
        if(_mode == `M_AUTO) begin
            val_7seg[0] = num[0];
            val_7seg[1] = num[1];
            val_7seg[2] = num[2];
            val_7seg[3] = num[3];
            val_7seg[4] = num[4];
            val_7seg[5] = num[5];
            val_7seg[6] = num[6];
        end
    end
    
endmodule