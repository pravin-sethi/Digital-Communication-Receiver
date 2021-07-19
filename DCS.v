module main(output [95:0] out,output reg [95:0]fec,output reg [15:0]crc,output reg status,input data,clock,start);
    wire [95:0]w_fec;wire fec_status;
    wire [15:0]w_crc;wire crc_status;
    reg b;          //For providing input to FEC
    reg [6:0]c;     //Counter 
    CRC A(w_crc,crc_status,data,clock,start);

    always @(posedge clock,posedge start) begin
        if(start==1) begin
            c<=0;
            status<=0;
        end
        if(c<32) begin
            b<=data;
            c=c+1'b1;
        end
        else if(c<48) begin
            b<=crc[15-c+32];
            c=c+1'b1;
        end
        if(fec_status==1) begin
            status<=1;
        end
    end

    always @(w_crc,w_fec) begin 
         crc=w_crc;
         fec=w_fec;
    end

    FEC B(w_fec,fec_status,b,clock,start);

    interleaver C(fec[23:0],fec[47:24],fec[71:48],fec[95:72],out);

endmodule

module interleaver(
input [23:0] byte0,
input [23:0] byte1,
input [23:0] byte2,
input [23:0] byte3, 
output [95:0]OP
);
wire [23:0] out0,out1,out2,out3;
assign out0 ={byte3[5:0],byte2[5:0],byte1[5:0],byte0[5:0]};
assign out1 ={byte3[11:6],byte2[11:6],byte1[11:6],byte0[11:6]};
assign out2 ={byte3[17:12],byte2[17:12],byte1[17:12],byte0[17:12]};
assign out3 ={byte3[23:18],byte2[23:18],byte1[23:18],byte0[23:18]};
  assign OP[95:0] ={out0[23:0],out1[23:0],out2[23:0],out3[23:0]};
endmodule

module FEC(output reg [95:0]fec,output reg status,input data,clck,start);
    reg [5:0]c;         //Count
    reg [3:0] b;        //Buffer/sliding window
    reg f;              //Flag
    always@(posedge clck,posedge start) begin
        if(start==1) begin
            c<=48;
            b<=4'b0000;
            status<=0;
            fec<=0;
            f<=0;
        end
        else if(c>0) begin
            if(f==1) begin
                fec[2*c-1]<=b[3]+b[1]+b[0];
                fec[2*c-2]<=b[3]+b[2]+b[1]+b[0];
                c<=c-1'b1;  
            end
          	if(data==0||data==1) begin      //Checking if x or z dosen't get into the sliding window
            	b[3:0]<={data,b[3:1]};
            	f<=1;
          	end
           if(c==2) status<=1;              /*Since there is difference of 2 clock cycles between FEC's status to be true and main status
                                            so making FEC status true at c==2 */
        end
    end

endmodule 

module CRC(output reg [15:0] R,output reg Status,input msb,clck,start);
    reg [5:0]c;
    always@(posedge clck,posedge start) begin
        if(start==1) begin
            R<=16'hFFFF;
            c<=0;
            Status<=0;
        end
        else if(c<32) begin
            R[0]<=R[15]+msb;
            R[1]<=R[0];
            R[2]<=R[1]+R[15]+msb;
            R[14:3]<=R[13:2];
            R[15]<=R[14]+R[15]+msb;
            c<=c+1'b1;
        end
        else Status<=1;
    end
endmodule 

