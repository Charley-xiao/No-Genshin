`timescale 1ns / 1ps
`include "define.v"
module MiniPiano (
    input wire clk,
    input wire [6:0] sel,
    input wire [1:0] octave,
    input wire [1:0] _mode,  // 11 InController, 10 AutoController, 01 LearnController
    input wire butscale,  //what tune?
    input wire up,
    input wire down,
    output wire speaker,
    output wire md,
    output [6:0] led,
    output [7:0] seg_out0,
    output [3:0] tub_sel0,
    output [7:0] seg_out1,
    output [3:0] tub_sel1,
    output [3:0] red,
    output [3:0] green,
    output [3:0] blue,
    output hs,
    output vs
);
  assign md = 1'b1;
  wire play;
  reg rset;
  reg [4:0] note;
  wire [31:0] score;
  wire [4:0] noteIn;
  wire [4:0] noteAuto;
  wire [4:0] noteLearn;
  reg [6:0] num;
  reg [2:0] scale;
  integer MAX_PIECES = 3'b100;
  integer MAX_SCALE = 3'b011;  //NEED TO ADJUST

  // 7-segment tube adjustment
  wire seg_rset;
  assign seg_rset = 1'b0;
  wire [31:0] val_7seg;
  light_val_controller ctrl_val (
      _mode,
      num,
      score,
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

  always @(debounced_butscale) begin
    if (debounced_butscale == 1'b1) begin
      scale = scale + 1'b1;
      if (scale >= MAX_SCALE) scale = 3'b000;
    end
  end

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

  //alter note for different modes
  always @(*) begin
    if (_mode == `M_IN) note = noteIn;
    else if (_mode == `M_AUTO) note = noteAuto;
    else if (_mode == `M_LEARN) note = noteLearn;  //need add learn then
    else note = noteIn;
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
  vga v (
      .clk(clk),
      .rst(1'b1),
      .mode(_mode),
      .r(red),
      .g(green),
      .b(blue),
      .vs(vs),
      .hs(hs)
  );

  // 3 different mode controllers
  InController inController (
      sel,
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
      sel,
      noteLearn,
      score,
      play
  );
endmodule
