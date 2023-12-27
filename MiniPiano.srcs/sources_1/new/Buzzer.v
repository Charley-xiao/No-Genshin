`timescale 1ns / 1ps
`include "define.v"
module Buzzer (
    input wire play,
    input wire [1:0] _mode,
    input wire clk,
    input wire [4:0] note,
    input wire [2:0] scale,
    output reg [6:0] led,
    output wire speaker
);
    reg pwm;
    // C for normal, and F for sharp (#), B for flat (b)
    wire [31:0] Cnotes[32:0];
    wire [31:0] Fnotes[32:0];
    wire [31:0] Bnotes[32:0];

    reg [31:0] counter;
    reg [31:0] notes[32:0];
    // C3
    assign Cnotes[1]  = 764525;
    assign Fnotes[1]  = 2290950;
    assign Bnotes[1]  = 1619695;
    // D3
    assign Cnotes[2]  = 681198;
    assign Fnotes[2]  = 2041232;
    assign Bnotes[2]  = 1528818;
    // E3
    assign Cnotes[3]  = 606796;
    assign Fnotes[3]  = 1818182;
    assign Bnotes[3]  = 1443001;
    // F3
    assign Cnotes[4]  = 572736;
    assign Fnotes[4]  = 17716148;
    assign Bnotes[4]  = 1362026;
    // G3
    assign Cnotes[5]  = 510284;
    assign Fnotes[5]  = 1528818;
    assign Bnotes[5]  = 1285677;
    // A3
    assign Cnotes[6]  = 454545;
    assign Fnotes[6]  = 1362026;
    assign Bnotes[6]  = 1213445;
    // B3 
    assign Cnotes[7]  = 405022;
    assign Fnotes[7]  = 1213445;
    assign Bnotes[7]  = 1145344;
    // C4
    assign Cnotes[9]  = 382262;
    assign Fnotes[9]  = 1145344;
    assign Bnotes[9]  = 809913;
    // D4
    assign Cnotes[10] = 340599;
    assign Fnotes[10] = 1020512;
    assign Bnotes[10] = 764467;
    // E4
    assign Cnotes[11] = 303398;
    assign Fnotes[11] = 909091;
    assign Bnotes[11] = 721552;
    // F4
    assign Cnotes[12] = 286368;
    assign Fnotes[12] = 858074;
    assign Bnotes[12] = 681046;
    // G4
    assign Cnotes[13] = 255102;
    assign Fnotes[13] = 764468;
    assign Bnotes[13] = 642881;
    // A4
    assign Cnotes[14] = 227272;
    assign Fnotes[14] = 681060;
    assign Bnotes[14] = 606810;
    // B4
    assign Cnotes[15] = 202511;
    assign Fnotes[15] = 606759;
    assign Bnotes[15] = 572710;
    // C5
    assign Cnotes[17] = 191131;
    assign Fnotes[17] = 566861;
    assign Bnotes[17] = 405073;
    // D5
    assign Cnotes[18] = 170300;
    assign Fnotes[18] = 510230;
    assign Bnotes[18] = 382230;
    // E5
    assign Cnotes[19] = 151699;
    assign Fnotes[19] = 454545;
    assign Bnotes[19] = 360776;
    // F5
    assign Cnotes[20] = 143184;
    assign Fnotes[20] = 429037;
    assign Bnotes[20] = 340523;
    // G5
    assign Cnotes[21] = 127551;
    assign Fnotes[21] = 382219;
    assign Bnotes[21] = 321441;
    // A5
    assign Cnotes[22] = 113636;
    assign Fnotes[22] = 340529;
    assign Bnotes[22] = 303405;
    // B5
    assign Cnotes[23] = 101255;
    assign Fnotes[23] = 303370;
    assign Bnotes[23] = 286355;
    //C6
    assign Cnotes[25] = 95566;
    assign Fnotes[25] = 286344;
    assign Bnotes[25] = 202536;
    // D6
    assign Cnotes[26] = 85150;
    assign Fnotes[26] = 255108;
    assign Bnotes[26] = 191115;
    // E6
    assign Cnotes[27] = 75850;
    assign Fnotes[27] = 227273;
    assign Bnotes[27] = 180388;
    // F6
    assign Cnotes[28] = 71592;
    assign Fnotes[28] = 214519;
    assign Bnotes[28] = 170261;
    //G6
    assign Cnotes[29] = 63776;
    assign Fnotes[29] = 191113;
    assign Bnotes[29] = 160720;
    //A6
    assign Cnotes[30] = 56818;
    assign Fnotes[30] = 170262;
    assign Bnotes[30] = 151702;
    //B6
    assign Cnotes[31] = 50628;
    assign Fnotes[31] = 151685;
    assign Bnotes[31] = 143177;

    integer i;
    always @(posedge clk) begin
        case (scale)
            3'b000: for (i = 1; i < 32; i = i + 1) notes[i] = Cnotes[i];
            3'b001: for (i = 1; i < 32; i = i + 1) notes[i] = Fnotes[i];
            3'b010: for (i = 1; i < 32; i = i + 1) notes[i] = Bnotes[i];
            // Add more cases as needed
        endcase
        if(note ==`OCT_LOW_P || note ==`OCT_MID_P|| note == `OCT_HGH_P || counter <notes[note]) begin
            counter <= counter + 1'b1;
        end else begin
            if ((_mode != `M_LEARN) || (_mode == `M_LEARN && play == 1'b1)) begin
                pwm <= ~pwm;  //play it  
                counter <= 0;
            end
        end
    end
    always @(*) begin
        case (note)  //shine specific led
            5'd0:  led = `nonled;
            5'd1:  led = `oneled;
            5'd2:  led = `twoled;
            5'd3:  led = `thrled;
            5'd4:  led = `forled;
            5'd5:  led = `fivled;
            5'd6:  led = `sixled;
            5'd7:  led = `sevled;
            5'd8:  led = `nonled;
            5'd9:  led = `oneled;
            5'd10: led = `twoled;
            5'd11: led = `thrled;
            5'd12: led = `forled;
            5'd13: led = `fivled;
            5'd14: led = `sixled;
            5'd15: led = `sevled;
            5'd16: led = `nonled;
            5'd17: led = `oneled;
            5'd18: led = `twoled;
            5'd19: led = `thrled;
            5'd20: led = `forled;
            5'd21: led = `fivled;
            5'd22: led = `sixled;
            5'd23: led = `sevled;
            5'd24: led = `nonled;
            5'd25: led = `oneled;
            5'd26: led = `twoled;
            5'd27: led = `thrled;
            5'd28: led = `forled;
            5'd29: led = `fivled;
            5'd30: led = `sixled;
            5'd31: led = `sevled;

            default: led = `nonled;
        endcase
    end

    assign speaker = pwm;

endmodule
