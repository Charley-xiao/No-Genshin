`timescale 1ns / 1ps
module AutoController(
    input clk,
    input [6:0] num,
    input [1:0] _mode,
    output reg [4:0] note
);
    wire [100:0] pcs[65:0];
    wire [100:0] len[65:0];
    reg [31:0] counter;
    reg [31:0] rest_counter;
    integer i = 7;
    // when usable, change pcs[0] to pcs[num] to select different music
    // i = 7 is the length, also need to be changed below
    assign pcs[0] = 40'b10001_10001_10101_10101_10110_10110_10101;
    assign len[0] =  16'b01____01____01____01____01____01____00;
    always @(posedge clk) begin
        if (counter == 0) begin
                note <= pcs[0][i*5 +: 5];
                case (len[0][i*2 +: 2])
                    2'b00: counter <= 160000000; 
                    2'b01: counter <= 80000000; 
                    2'b10: counter <= 40000000;
                    2'b11: counter <= 20000000; 
                    default: counter <= 160000000;
                endcase
                if (i == 0) begin
                    i <= 7;
                end else begin
                    i <= i - 1;
                end
            end 
            else begin
                counter <= counter - 1;
                if(counter < 5000000) note <= 0;
        end
        end
endmodule

// 17 17 21 21 22 22 21, 20 20 19 19 18 18 17
//  4   4   4    4   4   4   2    4   4   4   4   4   4   2
//  00  2
//  01  4
//  10  8
//  11  16