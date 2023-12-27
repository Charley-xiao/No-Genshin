`timescale 1ns / 1ps
`include "define.v"

module LearnController (
    input rset,
    input clk,
    input [6:0] num,
    input [1:0] _mode,
    input [6:0] sel,
    output reg [4:0] note,
    output reg [9:0] score,
    output reg play,
    output reg update_grade_flag,
    output reg canc,
    output reg [1:0] grade
);

    // State machine parameters
    parameter IDLE = `IDLE;
    parameter READY = `READY;
    parameter PLAY =   `PLAY;
    parameter RESULT = `RESULT;
    parameter NOTE_DURATION = `NOTE_DURATION;  // Assume each note lasts this duration
    parameter TIMER_MAX = `TIMER_MAX;     // 1 second on a 100MHz clock
    // Registers and wires
    reg [1:0] state;
    reg [31:0] note_duration_counter;
    reg [31:0] prevnum;
    reg note_played;  // Indicates if the current note has been played
    reg [31:0] timer;
    reg running;
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
            keyToNote[7'b0000001] = `DO + `OCT_MID_P;
           keyToNote[7'b0000010] = `RE + `OCT_MID_P;
           keyToNote[7'b0000100] = `MI + `OCT_MID_P;
           keyToNote[7'b0001000] = `FA + `OCT_MID_P;
           keyToNote[7'b0010000] = `SO + `OCT_MID_P;
           keyToNote[7'b0100000] = `LA + `OCT_MID_P;
           keyToNote[7'b1000000] = `SI + `OCT_MID_P;
    end

    // Index for the current note
    integer i;
    // Main learning mode state machine
    always @(posedge clk) begin
        if (rset) begin
            // Reset state logic
            update_grade_flag<=1'b1;
            i <= is;
            state <= IDLE;
            note_played <= 0;
            score <= 0;
            note_duration_counter <= NOTE_DURATION;
            play <= 0;
            timer <= TIMER_MAX; // Reset the timer
            running <= 0; // Stop the timer
            grade <= `G_C; // C grade
        end else if (_mode == `M_LEARN) begin
            // If the selected song has changed, reset to prepare the new song
            if (prevnum != num) begin
                i <= is;
                prevnum <= num;
                score <= 0;
                note_duration_counter <= NOTE_DURATION;
                note_played <= 0;
                play <= 0;
                state <= IDLE;
                timer <= TIMER_MAX; // Reset the timer
                running <= 0; // Stop the timer
                 grade <= `G_C; // C grade
            end else begin
                case (state)
                    IDLE: begin                   
                        state <= READY;
                    end
                    // READY state: prepare to play the note
                    READY: begin
                        if (note < 5'd8 && note > 0) _note <= note + `OCT_LOW_P;
                        else if (note > 5'd16 && note < 5'd24) _note <= note - `OCT_MID_P;
                        else if (note > 5'd24 && note <= 5'd31) _note <= note - `OCT_HGH_P;
                        else _note <= note;
                        state <= PLAY;  // Transition to PLAY state
                        case (len[i*2+:2])
                            2'b00:   note_duration_counter <= `CNT_L_1_2;
                            2'b01:   note_duration_counter <= `CNT_L_1_4;
                            2'b10:   note_duration_counter <= `CNT_L_1_8;
                            2'b11:   note_duration_counter <= `CNT_L_1_16;
                            default: note_duration_counter <= `CNT_L_1_16;
                        endcase
                        if(is==i)begin canc<=1;end
                        else begin canc<=0;end
                    end
                    // PLAY state: wait for user input and play the note
                    PLAY: begin
                     if(is==i)begin canc<=1;end
                           else begin canc<=0;end
                     if (running && timer > 0) begin
                      timer <= timer - 1; 
                      end
                        if (play) begin
                            play <= 0;
                        end else if (note_played && sel == 7'b0000000) begin
                            note_played <= 1'b0;  // Reset the flag once the selector is cleared
                            timer <= TIMER_MAX;
                            running <= 1;
                            state <= READY;  // Go back to READY state to wait for new input
                        end else if (!note_played) begin
                            // Check if the note is a rest
                            if (_note == `OCT_LOW_P || _note == `OCT_MID_P || _note == `OCT_HGH_P) begin
                                // Note is a rest, skip playing
                                play <= 1'b0;
                                if (i > 0) begin
                                    i <= i - 1;
                                    state <= READY;
                                end else begin
                                update_grade_flag <= 1'b1; 
                                    state <= RESULT;
                                end
                            end else if (sel != 7'b0000000) begin
                            running <= 0;
                                // Check if the correct key is pressed
                                if (keyToNote[sel] == _note) begin
                                    play <= 1'b1;  // Start playing the note
                                    if (note_duration_counter > 0) begin
                                        note_duration_counter <= note_duration_counter - 1;
                                    end else begin
                                        play <= 1'b0;  // Stop playing the note
                                        note_played <= 1'b1;  // Mark the note as played
                                        if (i > 0) begin
                                              if (timer > `STD_1) score <= score + `STD_1_S;
                                              else if (timer > `STD_2) score <= score + `STD_2_S;
                                              else if (timer > `STD_3) score <= score + `STD_3_S;
                                              else score <= score + `STD_4_S;
                                            i <= i - 1;  // Prepare the next note
                                            state <= READY;
                                        end else begin
                                              if (timer > `STD_1) score <= score + `STD_1_S;
                                              else if (timer > `STD_2) score <= score + `STD_2_S;
                                              else if (timer > `STD_3) score <= score + `STD_3_S;
                                              else score <= score + `STD_4_S;  
                                             update_grade_flag <= 1'b1; 
                                            state <= RESULT;  // No more notes, show result
                                        end
                                    end
                                end else begin
                                    // Incorrect key pressed, could add light flashing etc.
                                        play <= 1'b0;                            
                                        state <= READY; 
                                end
                            end
                        end
                    end
                    // RESULT state: display the result and wait for user action
                    RESULT: begin
                    if( update_grade_flag==1'b1)begin
                     if (score > is * 4) begin
                                       grade <= `G_S; // S grade
                                   end else if (score> is * 3) begin
                                       grade <= `G_A; // A grade
                                   end else if (score > is* 2) begin
                                       grade <= `G_B; // B grade
                                   end else begin
                                       grade <= `G_C; // C grade
                                   end
                                   update_grade_flag<=1'b0;
                                    canc<=1;
                                   end
                        score <= score;
                        // Reset to IDLE after the result is acknowledged
                    end
                endcase
            end
        end
    end
    // Update the note when not in learning mode or when a note has been played
    always @(posedge clk) begin
        if (_mode == `M_LEARN) begin
            if (state == RESULT) begin
                note <= 0;
            end else begin
            note <= pcs[i*5+:5];
            end
        end else begin
            note <= 0;
        end
    end
endmodule
