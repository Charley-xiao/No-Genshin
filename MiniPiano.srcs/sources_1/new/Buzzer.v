`timescale 1ns / 1ps
module Buzzer(
    input wire clk, 
    input wire [4:0] note, 
    output reg [6:0] led,
    output wire speaker
);
    reg pwm;
    wire [31:0] notes[24:0];
    reg [31:0] counter;
    // C3
    assign notes[1] = 764525;
    // D3
    assign notes[2] = 681198;
    // E3
    assign notes[3] = 606796;
    // F3
    assign notes[4] = 572737;
    // G3
    assign notes[5] = 510284;
    // A3
    assign notes[6] = 454545;
    // B3
    assign notes[7] = 405022;
    // C4
    assign notes[9] = 382262;
    // D4
    assign notes[10] = 340599;
    // E4
    assign notes[11] = 303398;
    // F4
    assign notes[12] = 286368;
    // G4
    assign notes[13] = 255102;
    // A4
    assign notes[14] = 227272;
    // B4
    assign notes[15] = 202511;
    // C5
    assign notes[17] = 191131;
    // D5
    assign notes[18] = 170300;
    // E5
    assign notes[19] = 151699;
    // F5
    assign notes[20] = 143184;
    // G5
    assign notes[21] = 127551;
    // A5
    assign notes[22] = 113636;
    // B5
    assign notes[23] = 101255;

    initial begin
        pwm = 0;
    end

    always @(posedge clk) begin
        if(note == 5'b00000 || note == 5'b01000 || note == 5'b10000 || counter < notes[note]) begin
            counter <= counter + 1'b1;
        end else begin
            pwm = ~pwm;
            counter <= 0;
        end
    end
    
    always @(*) begin 
        case(note) 
            5'd0: led = 7'b0000000;
            5'd1: led = 7'b1000000;
            5'd2: led = 7'b0100000;
            5'd3: led = 7'b0010000;
            5'd4: led = 7'b0001000;
            5'd5: led = 7'b0000100;
            5'd6: led = 7'b0000010;
            5'd7: led = 7'b0000001;
            5'd8: led = 7'b0000000;
            5'd9: led = 7'b1000000;
            5'd10: led = 7'b0100000;
            5'd11: led = 7'b0010000;
            5'd12: led = 7'b0001000;
            5'd13: led = 7'b0000100;
            5'd14: led = 7'b0000010;
            5'd15: led = 7'b0000001;
            5'd16: led = 7'b0000000;
            5'd17: led = 7'b1000000;
            5'd18: led = 7'b0100000;
            5'd19: led = 7'b0010000;
            5'd20: led = 7'b0001000;
            5'd21: led = 7'b0000100;
            5'd22: led = 7'b0000010;
            5'd23: led = 7'b0000001;
            default: led = 7'b0000000;
        endcase
    end

    assign speaker = pwm;

endmodule
