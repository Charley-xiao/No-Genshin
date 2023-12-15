`timescale 1ns / 1ps


module vga (
    input clk,
    input rst,
    input [1:0] mode,
    input [4:0] note,
    input [6:0] num,
    output reg [3:0] r,
    output reg [3:0] g,
    output reg [3:0] b,
    output hs,
    output vs
);

    //vga bound
    parameter UP_BOUND = 31;
    parameter DOWN_BOUND = 510;
    parameter LEFT_BOUND = 144;
    parameter RIGHT_BOUND = 783;

    parameter up_pos_0 = 267;  //first line
    parameter down_pos_0 = 274;
    parameter up_pos_1 = 280;  //second line
    parameter down_pos_1 = 287;
    parameter left_pos = 429;
    parameter right_pos = 498;

    wire pclk;
    reg [1:0] count;
    reg [9:0] hcount, vcount;
    wire [7:0] p0[62:0];  //first line
    wire [47:0] data0;
    wire [7:0] p1[69:0];  //second line
    wire [59:0] data1;

    //control data from mode 
    state_data_ctrl st_data (
        .clk (clk),
        .rst (rst),
        .mode(mode),
        .data(data0[35:0])
    );

    //control data from current note
    note_data_ctrl nt_data (
        .clk (clk),
        .rst (rst),
        .note(note),
        .data(data0[47:36])
    );

    //control data from current note
    name_data_ctrl nm_data (
        .clk (clk),
        .rst (rst),
        .num (num),
        .mode(mode),
        .data(data1[59:0])
    );

    //control data from name

    // set chars, len = 6 for every digit
    // group 1: state / mode
    char_set p_1 (
        .clk (clk),
        .rst (rst),
        .data(data0[35:30]),
        .col0(p0[0]),
        .col1(p0[1]),
        .col2(p0[2]),
        .col3(p0[3]),
        .col4(p0[4]),
        .col5(p0[5]),
        .col6(p0[6])
    );
    char_set p_2 (
        .clk (clk),
        .rst (rst),
        .data(data0[29:24]),
        .col0(p0[7]),
        .col1(p0[8]),
        .col2(p0[9]),
        .col3(p0[10]),
        .col4(p0[11]),
        .col5(p0[12]),
        .col6(p0[13])
    );
    char_set p_3 (
        .clk (clk),
        .rst (rst),
        .data(data0[23:18]),
        .col0(p0[14]),
        .col1(p0[15]),
        .col2(p0[16]),
        .col3(p0[17]),
        .col4(p0[18]),
        .col5(p0[19]),
        .col6(p0[20])
    );
    char_set p_4 (
        .clk (clk),
        .rst (rst),
        .data(data0[17:12]),
        .col0(p0[21]),
        .col1(p0[22]),
        .col2(p0[23]),
        .col3(p0[24]),
        .col4(p0[25]),
        .col5(p0[26]),
        .col6(p0[27])
    );
    char_set p_5 (
        .clk (clk),
        .rst (rst),
        .data(data0[11:6]),
        .col0(p0[28]),
        .col1(p0[29]),
        .col2(p0[30]),
        .col3(p0[31]),
        .col4(p0[32]),
        .col5(p0[33]),
        .col6(p0[34])
    );
    char_set p_6 (
        .clk (clk),
        .rst (rst),
        .data(data0[5:0]),
        .col0(p0[35]),
        .col1(p0[36]),
        .col2(p0[37]),
        .col3(p0[38]),
        .col4(p0[39]),
        .col5(p0[40]),
        .col6(p0[41])
    );

    char_set blank_1 (
        .clk (clk),
        .rst (rst),
        .data(6'b11_1110),
        .col0(p0[42]),
        .col1(p0[43]),
        .col2(p0[44]),
        .col3(p0[45]),
        .col4(p0[46]),
        .col5(p0[47]),
        .col6(p0[48])
    );

    // group 2: current note
    char_set c_1 (
        .clk (clk),
        .rst (rst),
        .data(data0[47:42]),
        .col0(p0[49]),
        .col1(p0[50]),
        .col2(p0[51]),
        .col3(p0[52]),
        .col4(p0[53]),
        .col5(p0[54]),
        .col6(p0[55])
    );
    char_set c_2 (
        .clk (clk),
        .rst (rst),
        .data(data0[41:36]),
        .col0(p0[56]),
        .col1(p0[57]),
        .col2(p0[58]),
        .col3(p0[59]),
        .col4(p0[60]),
        .col5(p0[61]),
        .col6(p0[62])
    );

    // group 3: music name (next line)
    char_set n_1 (
        .clk (clk),
        .rst (rst),
        .data(data1[59:54]),
        .col0(p1[0]),
        .col1(p1[1]),
        .col2(p1[2]),
        .col3(p1[3]),
        .col4(p1[4]),
        .col5(p1[5]),
        .col6(p1[6])
    );
    char_set n_2 (
        .clk (clk),
        .rst (rst),
        .data(data1[53:48]),
        .col0(p1[7]),
        .col1(p1[8]),
        .col2(p1[9]),
        .col3(p1[10]),
        .col4(p1[11]),
        .col5(p1[12]),
        .col6(p1[13])
    );
    char_set n_3 (
        .clk (clk),
        .rst (rst),
        .data(data1[47:42]),
        .col0(p1[14]),
        .col1(p1[15]),
        .col2(p1[16]),
        .col3(p1[17]),
        .col4(p1[18]),
        .col5(p1[19]),
        .col6(p1[20])
    );
    char_set n_4 (
        .clk (clk),
        .rst (rst),
        .data(data1[41:36]),
        .col0(p1[21]),
        .col1(p1[22]),
        .col2(p1[23]),
        .col3(p1[24]),
        .col4(p1[25]),
        .col5(p1[26]),
        .col6(p1[27])
    );
    char_set n_5 (
        .clk (clk),
        .rst (rst),
        .data(data1[35:30]),
        .col0(p1[28]),
        .col1(p1[29]),
        .col2(p1[30]),
        .col3(p1[31]),
        .col4(p1[32]),
        .col5(p1[33]),
        .col6(p1[34])
    );
    char_set n_6 (
        .clk (clk),
        .rst (rst),
        .data(data1[29:24]),
        .col0(p1[35]),
        .col1(p1[36]),
        .col2(p1[37]),
        .col3(p1[38]),
        .col4(p1[39]),
        .col5(p1[40]),
        .col6(p1[41])
    );
    char_set n_7 (
        .clk (clk),
        .rst (rst),
        .data(data1[23:18]),
        .col0(p1[42]),
        .col1(p1[43]),
        .col2(p1[44]),
        .col3(p1[45]),
        .col4(p1[46]),
        .col5(p1[47]),
        .col6(p1[48])
    );
    char_set n_8 (
        .clk (clk),
        .rst (rst),
        .data(data1[17:12]),
        .col0(p1[49]),
        .col1(p1[50]),
        .col2(p1[51]),
        .col3(p1[52]),
        .col4(p1[53]),
        .col5(p1[54]),
        .col6(p1[55])
    );
    char_set n_9 (
        .clk (clk),
        .rst (rst),
        .data(data1[11:6]),
        .col0(p1[56]),
        .col1(p1[57]),
        .col2(p1[58]),
        .col3(p1[59]),
        .col4(p1[60]),
        .col5(p1[61]),
        .col6(p1[62])
    );
    char_set n_10 (
        .clk (clk),
        .rst (rst),
        .data(data1[5:0]),
        .col0(p1[63]),
        .col1(p1[64]),
        .col2(p1[65]),
        .col3(p1[66]),
        .col4(p1[67]),
        .col5(p1[68]),
        .col6(p1[69])
    );


    assign pclk = count[1];
    always @(posedge clk or negedge rst) begin
        if (!rst) count <= 0;
        else count <= count + 1;
    end

    // count horizontal and vertical length
    assign hs = (hcount < 96) ? 0 : 1;
    always @(posedge pclk or negedge rst) begin
        if (!rst) hcount <= 0;
        else if (hcount == 799) hcount <= 0;
        else hcount <= hcount + 1;
    end
    assign vs = (vcount < 2) ? 0 : 1;
    always @(posedge pclk or negedge rst) begin
        if (!rst) vcount <= 0;
        else if (hcount == 799) begin
            if (vcount == 520) vcount <= 0;
            else vcount <= vcount + 1;
        end else vcount <= vcount;
    end

    //analyze and get output, for 1 being lit up
    always @(posedge pclk or negedge rst) begin
        if (!rst) begin
            r <= 0;
            g <= 0;
            b <= 0;
        end
        else if (vcount>=UP_BOUND && vcount<=DOWN_BOUND
                 && hcount>=LEFT_BOUND && hcount<=RIGHT_BOUND) begin
            if (hcount >= left_pos && hcount <= right_pos) begin
                if (vcount >= up_pos_0 && vcount <= down_pos_0) begin
                    if (p0[hcount-left_pos][vcount-up_pos_0]) begin
                        r <= 4'b1111;
                        g <= 4'b1111;
                        b <= 4'b1111;
                    end else begin
                        r <= 4'b0000;
                        g <= 4'b0000;
                        b <= 4'b0000;
                    end
                end else if (vcount >= up_pos_1 && vcount <= down_pos_1) begin
                    if (p1[hcount-left_pos][vcount-up_pos_1]) begin
                        r <= 4'b1111;
                        g <= 4'b1111;
                        b <= 4'b1111;
                    end else begin
                        r <= 4'b0000;
                        g <= 4'b0000;
                        b <= 4'b0000;
                    end
                end else begin
                    r <= 4'b0000;
                    g <= 4'b0000;
                    b <= 4'b0000;
                end
            end else begin
                r <= 4'b0000;
                g <= 4'b0000;
                b <= 4'b0000;
            end
        end else begin
            r <= 4'b0000;
            g <= 4'b0000;
            b <= 4'b0000;
        end
    end

endmodule
