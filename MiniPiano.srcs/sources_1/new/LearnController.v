`timescale 1ns / 1ps
`include "define.v"

module LearnController (
    input rset,
    input clk,
    input [6:0] num,
    input [1:0] _mode,
    input [6:0] sel,
    output reg [4:0] note,
    output reg [31:0] score,
    output reg play
);

    // State machine parameters
    parameter IDLE = 2'b00;
    parameter READY = 2'b01;
    parameter PLAY = 2'b10;
    parameter RESULT = 2'b11;
    parameter NOTE_DURATION = 80000000;  // Assume each note lasts this duration

    // Registers and wires
    reg [1:0] state;
    reg [31:0] note_duration_counter;
    reg [31:0] prevnum;
    reg note_played;  // Indicates if the current note has been played
    reg score_added;  // Ensures score is only added once
    reg mrset;  // Master reset tracking
    wire [700:0] pcs;
    wire [300:0] len;
    wire [7:0] is;
    wire [2:0] scal;

    // Instantiate the library module
    Library learnlib (
        .num(num),
        .pcs(pcs),
        .len(len),
        .scale(scal),
        .is(is)
    );

    // Note-key mapping
    reg [4:0] keyToNote[129:0];
    reg [4:0] _note;  // Translated note value
    always @(*) begin
        keyToNote[7'b0000001] = 5'b01001;
        keyToNote[7'b0000010] = 5'b01010;
        keyToNote[7'b0000100] = 5'b01011;
        keyToNote[7'b0001000] = 5'b01100;
        keyToNote[7'b0010000] = 5'b01101;
        keyToNote[7'b0100000] = 5'b01110;
        keyToNote[7'b1000000] = 5'b01111;
    end

    // Index for the current note
    integer i;
    initial begin
        mrset   = 1'b1;
        prevnum = 0;
    end

    // Main learning mode state machine
    always @(posedge clk) begin
        if (rset != mrset) begin
            // Reset state logic
            i <= is;
            mrset <= rset;
            state <= IDLE;
            note_played <= 0;
            score_added <= 0;
            score <= 0;
            note_duration_counter <= NOTE_DURATION;
            play <= 0;
        end else if (_mode == `M_LEARN) begin
            // If the selected song has changed, reset to prepare the new song
            if (prevnum != num) begin
                i <= is;
                prevnum <= num;
                score <= 0;
                note_duration_counter <= NOTE_DURATION;
                note_played <= 0;
                score_added <= 0;
                play <= 0;
                state <= IDLE;
            end else begin
                case (state)
                    IDLE: begin
                        i <= is;
                        prevnum <= num;
                        score <= 0;
                        state <= READY;
                        note_played <= 0;
                    end
                    // READY state: prepare to play the note
                    READY: begin
                        play <= 1'b0;

                        score_added <= 0;  // Reset score added flag
                        if (note < 5'd8 && note > 0) _note <= note + 5'b01000;
                        else if (note > 5'd16 && note < 5'd24) _note <= note - 5'b01000;
                        else if (note > 5'd24 && note <= 5'd31) _note <= note - 5'b10000;
                        else _note <= note;
                        state <= PLAY;  // Transition to PLAY state
                        case (len[i*2+:2])
                            2'b00:   note_duration_counter <= 120000000;
                            2'b01:   note_duration_counter <= 70000000;
                            2'b10:   note_duration_counter <= 40000000;
                            2'b11:   note_duration_counter <= 20000000;
                            default: note_duration_counter <= 160000000;
                        endcase
                    end
                    // PLAY state: wait for user input and play the note
                    PLAY: begin
                        if (play) begin
                            play <= 0;
                        end else if (note_played && sel == 7'b0000000) begin
                            note_played <= 1'b0;  // Reset the flag once the selector is cleared
                            state <= READY;  // Go back to READY state to wait for new input
                        end else if (!note_played) begin
                            // Check if the note is a rest
                            if (_note == 5'b00000 || _note == 5'b01000 || _note == 5'b10000) begin
                                // Note is a rest, skip playing
                                play <= 1'b0;
                                if (i > 0) begin
                                    i <= i - 1;
                                    state <= READY;
                                end else begin
                                    state <= RESULT;
                                end
                            end else if (sel != 7'b0000000) begin
                                // Check if the correct key is pressed
                                if (keyToNote[sel] == _note) begin
                                    play <= 1'b1;  // Start playing the note
                                    if (note_duration_counter > 0) begin
                                        note_duration_counter <= note_duration_counter - 1;
                                    end else begin
                                        play <= 1'b0;  // Stop playing the note
                                        note_played <= 1;  // Mark the note as played
                                        if (i > 0) begin
                                            i <= i - 1;  // Prepare the next note
                                            state <= READY;
                                        end else begin
                                            state <= RESULT;  // No more notes, show result
                                        end
                                    end
                                    if (!score_added) begin
                                        score <= score + 10;  // Increase score
                                        score_added <= 1;  // Mark score as added
                                    end
                                end else begin

                                    // Incorrect key pressed, could add light flashing etc.
                                    if (play == 1'b1) begin
                                        play <= 1'b0;
                                    end else if (!score_added) begin
                                        score <= (score > 5) ? score - 5 : 0;  // Decrease score but prevent negative
                                        score_added <= 1;  // Mark score as decreased
                                    end
                                    if (play == 1'b0) begin
                                        state <= READY;  // Return to READY state because of the wrong input
                                    end
                                end
                            end
                        end
                    end
                    // RESULT state: display the result and wait for user action
                    RESULT: begin
                        play  <= 1'b0;
                        score <= score;
                        // Display the result logic...
                        // Reset to IDLE after the result is acknowledged

                    end
                    default: begin
                        state <= IDLE;
                    end
                endcase
            end
        end
    end
    // Update the note when not in learning mode or when a note has been played
    always @(posedge clk) begin
        if (_mode == `M_LEARN) begin
            note <= pcs[i*5+:5];
            if (state == RESULT) begin
                note <= 0;
            end
        end else begin
            note <= 0;
        end
    end
endmodule
