`timescale 1ns / 1ps
`include "define.v"
module MiniPiano (
    input wire clk,
    input wire [6:0] sel,// Selection input for the musical note
    input wire [1:0] octave,// Octave selection input
    input wire [1:0] _mode,  // 11 InController, 10 AutoController, 01 LearnController
    input wire butscale,  //what tune?
    input wire up,
    input wire down,//switch songs
    input wire user_switch,//switch user
    input wire showaccount,//show account message
    output wire speaker,
    output wire md,
    output [6:0] led,
    output [7:0] seg_out0,
    output [3:0] tub_sel0,
    output [7:0] seg_out1,
    output [3:0] tub_sel1,//led
    output [3:0] red,
    output [3:0] green,
    output [3:0] blue,//vga
    output hs,
    output vs
);
    assign md = 1'b0; // Set md to a constant 0 as it's currently not used
    wire play;// Wire to indicate when a note should be played
    reg rset;
    reg [4:0] note;// Register to store the current note value
    wire [31:0] score;// Wire to carry the score value
    wire [1:0] grade;
    wire [4:0] noteIn; // Wire to carry the note from InController
    wire [4:0] noteAuto;
    wire [4:0] noteLearn;
    wire [4:0] noteAlter;
    reg [6:0] num;//store the number of the musical piece
    reg [2:0] scale; //  store the scale information
    integer MAX_PIECES = 3'b100;
    integer MAX_SCALE = 3'b011;
    wire [6:0] parsed_sel; // Wire to carry the parsed selection input

    wire rset_n;
    not not_rst (rset_n, rset); // Invert the reset signal

    // 7-segment tube adjustment
    wire seg_rset;
    assign seg_rset = 1'b0;
    
    wire [2:0] cur_note_alter;//the current note alteration
    wire [31:0] val_7seg;
    
    light_val_controller ctrl_val (
        _mode,
        num,
        score,
        cur_note_alter,
        val_7seg
    );
    light_7seg_manager manager_7seg (
        val_7seg,
        seg_rset,
        clk,
        _mode,
        seg_out0,
        tub_sel0,
        seg_out1,
        tub_sel1
    );
    initial begin
        num   = 0;
        scale = 3'b000;
        rset  = 1'b0;
    end

    //debouncers
    wire debounced_down;
    wire debounced_up;
    wire debounced_butscale;
    wire debounced_user_switch;
    debouncer d1 (
        clk,
        up,
        debounced_up
    );
    debouncer d3 (
        clk,
        down,
        debounced_down
    );
    debouncer d2 (
        clk,
        butscale,
        debounced_butscale
    );
   debouncer user_switch_debouncer (
            clk,
            user_switch,
           debounced_user_switch
        );
    always @(debounced_butscale) begin
        if (debounced_butscale == 1'b1) begin
            scale = scale + 1'b1;
            if (scale >= MAX_SCALE) scale = 3'b000;
        end
    end
    
        // account operation
        reg [3:0] current_user_id = 0;
        reg [1:0] user_ratings[0:15];
     always @(posedge debounced_user_switch) begin
           current_user_id <= current_user_id + 1;
           if (current_user_id >= 4'b1111) begin // 如果超过了用户数的上限，重置为0
               current_user_id <= 0;
           end
       end
     // 初始化用户分数和评级
     integer i;
      initial begin
              for (i = 0; i < 16; i = i + 1) begin
                  user_ratings[i] = 2'b11; // 默认评级为C
              end
              current_user_id = 0; // 默认开始时用户ID为0
          end
      always @(posedge clk) begin
      if(user_ratings[current_user_id]>grade)begin
      user_ratings[current_user_id] <= grade;
      end
      end
      //use showaccount control the view,(account id and grade)or(present score and id)
      
    // change currect music
    always @(posedge clk) begin
        if (debounced_up) begin
            num <= (num >= MAX_PIECES - 1) ? 0 : num + 1;
            rset = ~rset;
        end else if (debounced_down) begin
            num <= (num == 0) ? MAX_PIECES - 1 : num - 1;
            rset = ~rset;
        end
    end

    //make note adjustment
    sel_alter_manager altman (
        rset,
        clk,
        _mode,
        sel,
        parsed_sel,
        noteAlter,
        cur_note_alter
    );

    //alter note for different modes
    always @(*) begin
        if (_mode == `M_IN) note = noteIn;
        else if (_mode == `M_AUTO) note = noteAuto;
        else if (_mode == `M_LEARN) note = noteLearn;
        else if (_mode == `M_ALTER) note = noteAlter;
    end

    Buzzer buzzer (
        play,
        _mode,
        clk,
        note,
        scale,
        led,
        speaker
    );

    //vga
    vga v (
        .clk(clk),
        .rst(rset_n),
        .mode(_mode),
        .note(note),
        .num(num),
        .r(red),
        .g(green),
        .b(blue),
        .vs(vs),
        .hs(hs)
    );

    // 3 different mode controllers
    InController inController (
        parsed_sel,
        octave,
        _mode,
        noteIn
    );  //add scale or not
    AutoController autoController (
        rset,
        clk,
        num,
        _mode,
        noteAuto
    );
    LearnController learnController (
        rset,
        clk,
        num,
        _mode,
        parsed_sel,
        current_user_id,
        noteLearn,
        score,
        play,
        grade
    );
endmodule
