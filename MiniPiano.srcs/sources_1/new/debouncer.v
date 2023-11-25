`timescale 1ns / 1ps

module debouncer(
input clk,   
input k_in, 
output wire k_out  
    );
 reg k_value;
 reg k_p_flag;
 reg k_reg;
 reg [20:0]delay_cnt;
 parameter _______=21'd1500000; 


always@(posedge clk)
    k_reg<=k_in;


always@(posedge clk)
    if(k_in!=k_reg)
        delay_cnt<=_______;
    else if(delay_cnt>0)
        delay_cnt<=delay_cnt-1'b1;
    else
        delay_cnt<=21'd0;
        

always@(posedge clk)

    if(delay_cnt==1'b1)
        k_value<=k_in;
    else
        k_value<=k_value;


always@(posedge clk)
    if(delay_cnt==1'b1&&k_in==1)
        k_p_flag<=1'b1;
    else
        k_p_flag<=1'b0;

assign k_out=k_p_flag;
endmodule
