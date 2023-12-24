// modes
`define M_IN 2'b11
`define M_AUTO 2'b10
`define M_LEARN 2'b01
`define M_ALTER 2'b00

// some timeout constants
`define TIMEOUT 31'd1000000
`define RATE 31'd1000000
`define DEB_DELAY 21'd1500000
`define S_DELAY_0 64'd249999
`define S_DELAY_1 64'd499999
`define S_DELAY_2 64'd749999
`define S_DELAY_3 64'd999999
`define S_DELAY_4 64'd1249999

// learn mode states
`define IDLE 2'b00
`define READY 2'b01
`define PLAY 2'b10
`define RESULT 2'b11

// note lengths
`define LEN_1_2 2'b00
`define LEN_1_4 2'b01
`define LEN_1_8 2'b10
`define LEN_1_16 2'b11

// note counter for auto
`define CNT_1_2 160000000
`define CNT_1_4 80000000
`define CNT_1_8 40000000
`define CNT_1_16 20000000
`define AUTO_TIMEOUT 5000000

// note counter for learn
`define CNT_L_1_2 120000000
`define CNT_L_1_4 70000000
`define CNT_L_1_8 40000000
`define CNT_L_1_16 20000000

// score additions
`define STD_1 70000000
`define STD_1_S 5
`define STD_2 50000000
`define STD_2_S 4
`define STD_3 30000000
`define STD_3_S 3
`define STD_4_S 1

// music notes
`define DO 5'b00001
`define RE 5'b00010
`define MI 5'b00011
`define FA 5'b00100
`define SO 5'b00101
`define LA 5'b00110
`define SI 5'b00111

// octaves
`define OCT_LOW 2'b00
`define OCT_LOW_P 5'b00000
`define OCT_MID 2'b01
`define OCT_MID_P 5'b01000
`define OCT_HGH 2'b10
`define OCT_HGH_P 5'b10000

// grades
`define G_S 2'b00
`define G_A 2'b01
`define G_B 2'b10
`define G_C 2'b11
