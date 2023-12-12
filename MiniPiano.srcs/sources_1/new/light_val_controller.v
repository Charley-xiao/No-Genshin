`timescale 1ns / 1ps
`include "define.v"
module light_val_controller(
    input [1:0] _mode,
    input [6:0] num,
    input [31:0] score,
    output reg [31:0] val_7seg
    );
    
    always @(*) begin 
        if(_mode == `M_AUTO) begin
            val_7seg[6:0] = num;
           val_7seg[31:7] = 0; 
        end else 
    if(_mode == `M_LEARN) begin
                 val_7seg = score;                 
    end
    else begin
                    val_7seg = 32'd0;      // 默认情况下清零
                end
    end
endmodule