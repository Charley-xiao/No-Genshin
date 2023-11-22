`timescale 1ns / 1ps
module AutoController(
    input clk,
    input [6:0] num,
    input [1:0] _mode,
    output reg [4:0] note
);
    wire [300:0] pcs;
    wire [300:0] len;
    reg [31:0] counter;
    reg [31:0] rest_counter;
    reg [31:0] mlen;
    reg [31:0] i;

    Library lib(num,pcs,len,mlen);

    initial begin
        i = mlen;
    end
    
    always @(posedge clk) begin
        if(_mode == 2'b10) begin
            if (counter == 0) begin
                    note <= pcs[i*5 +: 5];
                    case (len[i*2 +: 2])
                        2'b00: counter <= 160000000; 
                        2'b01: counter <= 80000000; 
                        2'b10: counter <= 40000000;
                        2'b11: counter <= 20000000; 
                        default: counter <= 160000000;
                    endcase
                    if (i == 0) begin
                        i <= mlen; //
                    end else begin
                        i <= i - 1;
                    end
                end 
                else begin
                    counter <= counter - 1;
                    if(counter < 5000000) note <= 0;
                end
            end
        end
endmodule


//  00  2
//  01  4
//  10  8
//  11  16