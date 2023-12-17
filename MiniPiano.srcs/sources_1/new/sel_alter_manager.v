`timescale 1ns / 1ps
`include "define.v"
module sel_alter_manager (
    input rset,
    input clk,
    input [1:0] mode,
    input [6:0] sel,
    output reg [6:0] parsed_sel,
    output reg [4:0] note
);

    // states
    parameter IDLE = 2'b00;
    parameter READY = 2'b01;
    parameter SEL = 2'b10;
    reg [2:0] state;

    reg [6:0] parser_table[6:0];  // the parsing table
    reg [2:0] cur_note;
    reg has_played;
    reg mrset;  // memorized reset
    initial begin
        mrset = 0;
        has_played = 1'b0;
        state = IDLE;
        parser_table[0] = 6'b0;
        parser_table[1] = 6'b0;
        parser_table[2] = 6'b0;
        parser_table[3] = 6'b0;
        parser_table[4] = 6'b0;
        parser_table[5] = 6'b0;
        parser_table[6] = 6'b0;
        cur_note = 3'b0;
    end

    always @(*) begin
        // make parsed sels using parser table
        case (sel)
            7'b0000001: begin
                if (parser_table[6] == 6'b0) parsed_sel = 7'b0000001;
                else parsed_sel = parser_table[6];
            end
            7'b0000010: begin
                if (parser_table[5] == 6'b0) parsed_sel = 7'b0000010;
                else parsed_sel = parser_table[5];
            end
            7'b0000100: begin
                if (parser_table[4] == 6'b0) parsed_sel = 7'b0000100;
                else parsed_sel = parser_table[4];
            end
            7'b0001000: begin
                if (parser_table[3] == 6'b0) parsed_sel = 7'b0001000;
                else parsed_sel = parser_table[3];
            end
            7'b0010000: begin
                if (parser_table[2] == 6'b0) parsed_sel = 7'b0010000;
                else parsed_sel = parser_table[2];
            end
            7'b0100000: begin
                if (parser_table[1] == 6'b0) parsed_sel = 7'b0100000;
                else parsed_sel = parser_table[1];
            end
            7'b1000000: begin
                if (parser_table[1] == 6'b0) parsed_sel = 7'b1000000;
                else parsed_sel = parser_table[1];
            end
        endcase
    end

    always @(posedge clk) begin
        if (mrset != rset) begin  // reset
            mrset <= rset;
            state <= IDLE;
            has_played <= 1'b0;
            parser_table[0] <= 6'b0;
            parser_table[1] <= 6'b0;
            parser_table[2] <= 6'b0;
            parser_table[3] <= 6'b0;
            parser_table[4] <= 6'b0;
            parser_table[5] <= 6'b0;
            parser_table[6] <= 6'b0;
            cur_note = 3'b0;
        end else if (mode == `M_ALTER) begin
            // alter mode, change parser table
            case (state)
                IDLE: begin
                    has_played <= 1'b0;
                    cur_note = 3'b0;
                    state <= READY;
                end
                READY: begin  // play some, do to si
                    if (has_played == 1'b1 & sel == 7'b0) begin
                        has_played <= 1'b0;
                        note <= cur_note + 5'b01000;
                        cur_note <= cur_note + 1;
                        if (cur_note > 3'd6) cur_note <= 3'd0;
                        state <= SEL;
                    end
                end
                SEL: begin  // alter parser table
                    if (sel != 7'b0) begin
                        parser_table[cur_note] <= sel;
                        has_played <= 1'b1;
                        state <= READY;
                    end
                end
            endcase
        end else begin
            if (state != IDLE) state <= IDLE;
        end
    end

endmodule
