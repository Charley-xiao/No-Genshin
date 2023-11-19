`timescale 1ns / 1ps
module MiniPiano(
    input wire clk,
    input wire [6:0] sel,
    input wire [1:0] octave,
    input wire [1:0] _mode, // 11 InController, 10 AutoController, 01 LearnController
    input wire up,
    input wire down,
    output wire speaker,
    output wire md,
    output [6:0] led
);  
    assign md = 1'b1;
    reg [4:0] note;
    wire [4:0] noteIn;
    wire [4:0] noteAuto;
    reg [6:0] num;
    integer MAX_PIECES = 1;
    initial begin 
        num = 0;
    end
    always @(*) begin
        // TODO change music id but currently buggy
        if(up == 1'b1) num = num + 1'b1;
        if(down == 1'b1) num = num - 1'b1;
        if(num < 0) num = MAX_PIECES;
        if(num > MAX_PIECES || num == MAX_PIECES) num = 0;
    end
    always @(*) begin 
        if(_mode == 2'b11) note = noteIn;
        else if(_mode == 2'b10) note = noteAuto;
        else note = noteIn;
    end
    Buzzer buzzer(clk, note,led, speaker);
    InController inController(sel, octave,_mode,noteIn);
    AutoController autoController(clk,num,_mode,noteAuto);
endmodule
