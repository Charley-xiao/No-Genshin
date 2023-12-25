`timescale 1ns / 1ps
`include "define.v"
module debouncer (
    input clk,
    input k_in,
    output wire k_out
);
    reg k_value;
    reg k_p_flag;
    reg k_reg;
    reg [20:0] delay_cnt;
    parameter delay_param = `DEB_DELAY;  //max delay time

    always @(posedge clk) k_reg <= k_in;

    always @(posedge clk)
        if (k_in != k_reg) delay_cnt <= delay_param;
        else if (delay_cnt > 0) delay_cnt <= delay_cnt - 1'b1;
        else delay_cnt <= 21'd0;


    always @(posedge clk)
        if (delay_cnt == 1'b1 && k_in == 1) k_p_flag <= 1'b1;  //only change when already delayed
        else k_p_flag <= 1'b0;

    assign k_out = k_p_flag;

endmodule
