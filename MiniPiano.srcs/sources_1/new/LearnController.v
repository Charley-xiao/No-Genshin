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
      
    reg [4:0] keyToNote [7:0]; // Mapping from key to note
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
                    isEqual = 1'b0;
                    if(_note < 8 && _note > 0) _note = _note + 8;
                    else if(_note > 16 && _note < 24) _note = _note - 8;
                    else if(_note > 24 && _note < 32) _note = _note - 16;
                    for (i = 1; i < 128; i = i *2) begin
                        if (sel[i] && _note == keyToNote[i]) begin
                            isEqual = 1'b1; 
                        end
                    end
                end
            endfunction
    always @(posedge clk or posedge rset) begin
                if (rset) begin
                    state <= IDLE;
                    score <= 0;
                    notecnt <= 0;
                    en <= 0;
                end
                else begin
                    case (state)
                        IDLE: begin
                            if (_mode == `M_LEARN) begin
                                state <= PLAY;
                            end
                        end
                        PLAY: begin
                            if (sel != 0) begin
                                if (isEqual(sel, pcs[notecnt*5+:5])==1'b1) begin
                                    score <= score + (`TIMEOUT - timer) / `RATE;
                                    timer <= 0;
                                end else begin
                                    score <= score;
                                    timer <= 0;
                                end
                                if (notecnt < is) begin
                                    notecnt <= notecnt + 1;
                                end else begin
                                    state <= RESULT;
                                end
                            end
                        end
                        RESULT: begin
                            en <= 1;
                            if (_mode != `M_LEARN) begin
                                state <= IDLE;
                            end
                        end
                    endcase
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