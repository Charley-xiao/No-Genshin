`timescale 1ns / 1ps
`include "define.v"
module sel_alter_manager (
    input rset,
    input clk,
    input [1:0] mode,
    input [6:0] sel,
    output reg [6:0] parsed_sel,
    output reg [4:0] note,
    output reg [2:0] cur_note
);


    reg [6:0] parser_table[6:0];  // the parsing table
    reg has_played;
    reg [6:0] last_sel;
    reg mrset;  // memorized reset


    always @(*) begin
        // make parsed sels using parser table
        case (sel)
            7'b0000001: begin
                if (parser_table[0] == 6'b0) parsed_sel = 7'b0000001;
                else parsed_sel = parser_table[0];
            end
            7'b0000010: begin
                if (parser_table[1] == 6'b0) parsed_sel = 7'b0000010;
                else parsed_sel = parser_table[1];
            end
            7'b0000100: begin
                if (parser_table[2] == 6'b0) parsed_sel = 7'b0000100;
                else parsed_sel = parser_table[2];
            end
            7'b0001000: begin
                if (parser_table[3] == 6'b0) parsed_sel = 7'b0001000;
                else parsed_sel = parser_table[3];
            end
            7'b0010000: begin
                if (parser_table[4] == 6'b0) parsed_sel = 7'b0010000;
                else parsed_sel = parser_table[4];
            end
            7'b0100000: begin
                if (parser_table[5] == 6'b0) parsed_sel = 7'b0100000;
                else parsed_sel = parser_table[5];
            end
            7'b1000000: begin
                if (parser_table[6] == 6'b0) parsed_sel = 7'b1000000;
                else parsed_sel = parser_table[6];
            end
        endcase
    end

    always @(posedge clk or posedge rset) begin
        if (rset) begin
            last_sel <= 7'b0;
            has_played <= 1'b0;
            parser_table[0] <= 6'b0;
            parser_table[1] <= 6'b0;
            parser_table[2] <= 6'b0;
            parser_table[3] <= 6'b0;
            parser_table[4] <= 6'b0;
            parser_table[5] <= 6'b0;
            parser_table[6] <= 6'b0;
            cur_note <= 3'b0;
        end else if (mode == `M_ALTER) begin
            // alter mode, change parser table
            if (has_played == 1'b0 && sel == 7'b0) begin
                note <= cur_note + `OCT_MID_P + 1'b1;
                has_played <= 1'b1;
            end else if (sel != 7'b0 && sel != last_sel) begin
                parser_table[cur_note] <= sel;
                last_sel <= sel;
                has_played <= 1'b0;
                if (cur_note == 3'b110) cur_note <= 3'b0;
                else cur_note <= cur_note + 1'b1;
            end
        end else begin
            last_sel   <= 7'b0;
            has_played <= 1'b0;
            cur_note   <= 3'b0;
        end
    end

endmodule
