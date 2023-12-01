`timescale 1ns / 1ps
`include "define.v"
module LearnController(
    input rset,
    input clk,
    input [6:0] num,
    input [1:0] _mode,
    input [6:0] sel,
    output reg [4:0] note
);
    reg en;
    initial en = 0;
    reg [1:0] state;
    reg [31:0] score;
    reg [31:0] timer;
    wire [700:0] pcs;
    wire [300:0] len;
    wire [6:0] is;
    wire [2:0] pseudo;
    parameter IDLE = 2'b00;
    parameter READY = 2'b01;
    parameter PLAY = 2'b10;
    parameter RESULT = 2'b11;
    reg [31:0] notecnt = 0;
    
    Library learnlib(
            .num(num),
            .pcs(pcs),
            .len(len),
            .scale(pseudo),
            .is(is)
      );
      
    reg [4:0] keyToNote [300:0]; // Mapping from key to note
            initial begin
                keyToNote[7'b0000001] = 5'b10001; 
                keyToNote[7'b0000010] = 5'b10010; 
                keyToNote[7'b0000100] = 5'b10011; 
                keyToNote[7'b0001000] = 5'b10100;
                keyToNote[7'b0010000] = 5'b10101;
                keyToNote[7'b0100000] = 5'b10110;
                keyToNote[7'b1000000] = 5'b10111;
            end
            function isEqual;
                input [6:0] sel;
                input [4:0] _note;
                integer i;
                begin
                    if(_note < 8 && _note > 0) _note = _note + 8;
                    else if(_note > 16 && _note < 24) _note = _note - 8;
                    else if(_note > 24 && _note < 32) _note = _note - 16;
                    if(keyToNote[sel] == _note) isEqual = 1'b1;
                    else isEqual = 1'b0;
                end
            endfunction
//                always @_mode if (_mode != `M_LEARN) state <= IDLE; 
//                always @num if (_mode == `M_LEARN) state <= PLAY;
//                always @(posedge rset) if (_mode == `M_LEARN) state <= READY;
                
                reg [31:0] prevnum;
                initial prevnum=114514;
                always@(_mode,num,rset) begin 
                    if(rset == 1 && _mode == `M_LEARN) state = READY;
                    if(_mode != `M_LEARN) state = IDLE;
                    else if(num != prevnum) begin 
                        prevnum = num;
                        state = PLAY;
                    end
                end
                
                
                always @(*) begin 
                    if(sel != 0) begin
                    if((_mode == `M_LEARN) & (state == PLAY)) begin
                    // Step 1: Judge if the note is correct, if yes, reset the timer and score += TIMEOUT - timer, otherwise reset the timer and score += 0
                    if (isEqual(sel,pcs[notecnt*5+:5])) begin
                        score = score + (`TIMEOUT - timer) / `RATE;
                        timer = 0;
                    end else begin
                        score = score + 0;
                        timer = 0;
                    end
                    notecnt = notecnt + 1;
                end
                end
                end
                always @(*) begin 
                    if(_mode == `M_LEARN) begin 
                        if(state == IDLE) begin 
                        score = 0;
                                                        notecnt = 0;
                                                        en = 0;
                        end
                        if(state == READY) begin 
                        score = 0;
                                                        notecnt = 0;
                                                        en = 1;
                        end
                        if(state == PLAY && notecnt < is) begin 
                        note = pcs[notecnt*5+:5];
                        end
                        else en=1;
                    end
                end
    always @(posedge clk) begin
            // Increment timer when in the PLAY state
            if (_mode == `M_LEARN) begin
            if (state == PLAY) begin
                if (timer < `TIMEOUT) begin
                    timer <= timer + 1;
                end
            end
        end
        end

endmodule