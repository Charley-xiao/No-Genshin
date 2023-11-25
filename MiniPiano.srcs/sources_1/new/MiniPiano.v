`timescale 1ns / 1ps
module MiniPiano(
    input wire clk,
    input wire [6:0] sel,
    input wire [1:0] octave,
    input wire [1:0] _mode, // 11 InController, 10 AutoController, 01 LearnController
    input wire  butscale,//what tune?
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
    reg [2:0] scale;
    integer MAX_PIECES = 3'b100;
    integer MAX_SCALE = 3'b011;//NEED TO ADJUST
    initial begin 
        num = 0;
        scale=3'b000;
    end
       always @(*) begin
                if(butscale==1)begin scale = scale +1'b1;
                if(scale>= MAX_SCALE) scale=3'b000;
                end
     end
    always @(*) begin
        // TODO change music id but currently buggy
            if (up == 1'b1) begin
                num = num + 1'b1;
                if (num >= MAX_PIECES) num = 0;
            end
            if (down == 1'b1) begin
                num = num - 1'b1;
                if (num < 0) num = MAX_PIECES - 1;
            end
    end
    always @(*) begin 
        if(_mode == 2'b11) note = noteIn;
        else if(_mode == 2'b10) note = noteAuto;
        else note = noteIn;
    end
    Buzzer buzzer(clk, note,scale,led, speaker);
    InController inController(sel, octave,_mode,noteIn);//add scale or not？
    AutoController autoController(clk,num,_mode,noteAuto);
endmodule
