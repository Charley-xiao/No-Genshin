`timescale 1ns / 1ps
module Buzzer(input wire clk, input wire [4:0] note, output wire speaker);
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

    assign speaker = pwm;

endmodule
