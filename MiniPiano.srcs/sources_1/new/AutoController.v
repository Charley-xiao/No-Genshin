module AutoController(
    input clk,
    input [6:0] num,
    input [1:0] _mode,
    output reg [4:0] note,
    output wire [2:0] scale//control the tune of pieces,details in library
);
    wire [300:0] pcs;
    wire [300:0] len;
    wire [6:0] is;
    reg [31:0] counter;
    reg [31:0] rest_counter;
    integer i;

    MusicLibrary ml(
        .num(num),
        .pcs(pcs),
        .len(len),
        .scale(scale),
        .is(is)
    );
//how to translate（pass） scale from ml to buzzer?（s3 and s0）
    always @(posedge clk) begin
        if(_mode == 2'b10) begin
            if (counter == 0) begin
                i <= is;
                note <= pcs[i*5 +: 5];
                case (len[i*2 +: 2])
                    2'b00: counter <= 160000000; 
                    2'b01: counter <= 80000000; 
                    2'b10: counter <= 40000000;
                    2'b11: counter <= 20000000; 
                    default: counter <= 160000000;
                endcase
                if (i == 0) begin
                    i <= is; //resett to the length of the song
                end else begin
                    i <= i - 1;
                end
            end else begin
                counter <= counter - 1;
                if(counter < 5000000) note <= 0;
            end
        end
    end
endmodule
