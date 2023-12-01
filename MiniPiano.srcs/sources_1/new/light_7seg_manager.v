`timescale 1ns / 1ps
module light_7seg_manager(
    input [31:0] val,
    input rst,
    input clk,
    output reg [7:0] seg_out0,
    output reg [3:0] tub_sel0,
    output reg [7:0] seg_out1,
    output reg [3:0] tub_sel1
    );
    
    reg [63:0] timer;
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
            seg_out0 = 8'b0;
            seg_out1 = 8'b1;
         end 
         else if(timer <= 64'd249999) begin
            tub_sel0 = 4'b0001;
            seg_out0 = val[3:0];
            tub_sel1 = 4'b0001;
            seg_out1 = val[19:16];
         end
         else if(timer <= 64'd499999) begin
            tub_sel0 = 4'b0010;
            seg_out0 = val[7:4];
            tub_sel1 = 4'b0010;
            seg_out1 = val[23:20];
         end   
         else if(timer <= 64'd749999) begin
            tub_sel0 = 4'b0100;
            seg_out0 = val[11:8];
            tub_sel1 = 4'b0100;
            seg_out1 = val[27:24];
         end        
         else if(timer <= 64'd999999) begin
            tub_sel0 = 4'b1000;
            seg_out0 = val[15:12];
            tub_sel1 = 4'b1000;
            seg_out1 = val[31:28];
         end                           
     end       
    
endmodule
