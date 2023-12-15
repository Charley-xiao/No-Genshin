module note_data_ctrl (
    input clk,
    input rst,
    input [4:0] note,
    output reg [11:0] data
);
    reg [4:0] _note;
    always @(posedge clk, negedge rst) begin
        if (!rst) begin
            data <= 12'b111110_111110;  //reset, all zero
        end else begin
            _note = note;
            _note = _note - _note / 4'd8 * 4'd8;
            case (_note)
                5'b00001: data <= 12'b001101_011000;  //do
                5'b00010: data <= 12'b011011_001110;  //re
                5'b00011: data <= 12'b010110_010010;  //mi
                5'b00100: data <= 12'b001111_001010;  //fa
                5'b00101: data <= 12'b011100_011000;  //so
                5'b00110: data <= 12'b010101_001010;  //la
                5'b00111: data <= 12'b011100_010010;  //si
                default: begin
                    data <= 12'b111110_111110;  //blank
                end
            endcase
        end
    end

endmodule
