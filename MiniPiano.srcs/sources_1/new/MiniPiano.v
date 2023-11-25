`timescale 1ns / 1ps
module MiniPiano(
    input wire clk,
    input wire [6:0] sel,
    input wire [1:0] octave,
    input wire [1:0] _mode, // 11 InController, 10 AutoController, 01 LearnController
    input wire  butscale,//what tune?
    input wire up,
    output wire speaker,
    output wire md,
    output [6:0] led,
    output [7:0] seg_out,
    output tub_sel1
);  
    assign md = 1'b1;
    reg rset;
    reg [4:0] note;
    wire [4:0] noteIn;
    wire [4:0] noteAuto;
    reg [6:0] num;
    reg [2:0] scale;
    integer MAX_PIECES = 3'b100;
    integer MAX_SCALE = 3'b011;//NEED TO ADJUST
    wire debounced_up;
    wire debounced_butscale;
    debouncer d1(clk,up,debounced_up);
    debouncer d2(clk,butscale,debounced_butscale);
    wire seg_rset;
    assign seg_rset = 1'b0;
    light_7seg_ego ___(.sw(num),.seg_out(seg_out),.rst(seg_rset),._mode(_mode),.tub_sel(tub_sel1));
    initial begin 
        num = 0;
        scale=3'b000;
        rset = 1'b0;
    end
    always @(debounced_butscale) begin 
    if(debounced_butscale==1'b1)begin 
                    scale = scale +1'b1;
                    if(scale>= MAX_SCALE) scale=3'b000;
                    end
    end
       always @(posedge debounced_up) begin
                
            if (debounced_up == 1'b1) begin
                if (num >= MAX_PIECES-1) num =1'b0;
                else num = num + 1'b1;
                rset = ~rset;
            end
           
    end
    always @(*) begin 
        if(_mode == 2'b11) note = noteIn;
        else if(_mode == 2'b10) note = noteAuto;
        else note = noteIn;
    end
    Buzzer buzzer(clk, note,scale,led, speaker);
    InController inController(sel, octave,_mode,noteIn);//add scale or notï¼?
    AutoController autoController(rset,clk,num,_mode,noteAuto);
endmodule
