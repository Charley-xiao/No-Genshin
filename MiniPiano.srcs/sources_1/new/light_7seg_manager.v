`timescale 1ns / 1ps
`include "define.v"
module light_7seg_manager (
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

    light_7seg_ego slv0 (
        sw0,
        rst,
        _mode,
        seg_out0
    );  //first 4 digits
    light_7seg_ego slv1 (
        sw1,
        rst,
        _mode,
        seg_out1
    );  //second 4 digits

    always @(posedge clk or negedge rst) begin
        if (rst) timer <= 64'd0;
        else if (timer == `S_DELAY_4) timer <= 64'd0;
        else timer <= timer + 1'b1;
    end

    always @(posedge clk) begin
        if (rst) begin
            tub_sel0 = 4'b0;  //all not setting
            tub_sel1 = 4'b0;
            sw0 = 4'b0;
            sw1 = 4'b0;
        end else if (timer <= `S_DELAY_0) begin
            tub_sel0 = 4'b0001;  //rightmost
            sw0 = val[3:0];
            tub_sel1 = 4'b0001;
            sw1 = val[19:16];
        end else if (timer <= `S_DELAY_1) begin
            tub_sel0 = 4'b0010;  //2nd rightmost
            sw0 = val[7:4];
            tub_sel1 = 4'b0010;
            sw1 = val[23:20];
        end else if (timer <= `S_DELAY_2) begin
            tub_sel0 = 4'b0100;  //2nd leftmost
            sw0 = val[11:8];
            tub_sel1 = 4'b0100;
            sw1 = val[27:24];
        end else if (timer <= `S_DELAY_3) begin
            tub_sel0 = 4'b1000;  //leftmost
            sw0 = val[15:12];
            tub_sel1 = 4'b1000;
            sw1 = val[31:28];
        end
    end

endmodule
