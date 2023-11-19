`timescale 1ns / 1ps
module MiniPiano(
    input wire clk,
    input wire [6:0] sel,
    input wire [1:0] octave,
    output wire speaker
);
    wire [4:0] note;
    Buzzer buzzer(clk, note, speaker);
    InController inController(sel, octave, note);
    
endmodule
