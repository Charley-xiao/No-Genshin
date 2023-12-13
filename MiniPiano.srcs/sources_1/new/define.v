`define M_IN 2'b11
`define M_AUTO 2'b10
`define M_LEARN 2'b01

`define TIMEOUT 31'd1000000
`define RATE 31'd1000000
`define DEB_DELAY 21'd1500000;
`define S_DELAY_0 64'd249999;
`define S_DELAY_1 64'd499999;
`define S_DELAY_2 64'd749999;
`define S_DELAY_3 64'd999999;
`define S_DELAY_4 64'd1249999;

`define IDLE 2'b00;
`define READY 2'b01;
`define PLAY 2'b10;
`define RESULT 2'b11;

`define LEN_1_2 2'b00;
`define LEN_1_4 2'b01;
`define LEN_1_8 2'b10;
`define LEN_1_16 2'b11;

`define OCT_LOW 2'b00;
`define OCT_LOW_P 5'b00000;
`define OCT_MID 2'b01;
`define OCT_MID_P 5'b01000;
`define OCT_HGH 2'b10;
`define OCT_HGH_P 5'b10000;
