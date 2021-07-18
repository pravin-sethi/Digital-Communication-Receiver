module interleaver(
input [7:0] byte0,
input [7:0] byte1,
input [7:0] byte2,
input [7:0] byte3, 
output [7:0] out0,
output [7:0] out1,
output [7:0] out2,
output [7:0] out3
);

assign out0 ={byte3[1:0],byte2[1:0],byte1[1:0],byte0[1:0]};
assign out1 ={byte3[3:2],byte2[3:2],byte1[3:2],byte0[3:2]};
assign out2 ={byte3[5:4],byte2[5:4],byte1[5:4],byte0[5:4]};
assign out3 ={byte3[7:6],byte2[7:6],byte1[7:6],byte0[7:6]};
endmodule