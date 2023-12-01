`timescale 1ns / 1ps
module light_7seg_manager(
    input [31:0] val,
    input rst,
    input clk,
    input [1:0] _mode,
    output [7:0] seg_out0,
    output reg [3:0] tub_sel0,
    output [7:0] seg_out1,
    output reg [3:0] tub_sel1
    );
    
    reg [63:0] timer;
    reg [3:0] sw0, sw1;
    
    light_7seg_ego slv0(sw0, rst, _mode, seg_out0);
    light_7seg_ego slv1(sw1, rst, _mode, seg_out1);
    
    always @(posedge clk or negedge rst)
    begin
        if(~rst) timer <= 64'd0;
        else if(timer == 64'd1_249_999) timer <= 64'd0;
        else timer <= timer + 1'b1;
    end
    
    always@(posedge clk or negedge rst)
    begin
        if(~rst) begin
            tub_sel0 = 4'b0;
            tub_sel1 = 4'b0;
            sw0 = 4'b0;
            sw1 = 4'b0;
         end 
         else if(timer <= 64'd249999) begin
            tub_sel0 = 4'b0001;
            sw0 = val[3:0];
            tub_sel1 = 4'b0001;
            sw1 = val[19:16];
         end
         else if(timer <= 64'd499999) begin
            tub_sel0 = 4'b0010;
            sw0 = val[7:4];
            tub_sel1 = 4'b0010;
            sw1 = val[23:20];
         end   
         else if(timer <= 64'd749999) begin
            tub_sel0 = 4'b0100;
            sw0 = val[11:8];
            tub_sel1 = 4'b0100;
            sw1 = val[27:24];
         end        
         else if(timer <= 64'd999999) begin
            tub_sel0 = 4'b1000;
            sw0 = val[15:12];
            tub_sel1 = 4'b1000;
            sw1 = val[31:28];
         end                           
     end       
    
endmodule
