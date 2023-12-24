module hex_to_decimal (  
  input [9:0] data,  
  output [11:0] out
); 
  
  wire integer i;  
  assign i = data;
  assign out[3:0] = i%10;
  assign out[7:4] = (i/10)%10;
  assign out[11:8] = (i/100)%10;
  
endmodule
