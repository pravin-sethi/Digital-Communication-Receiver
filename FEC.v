module Convolution_CG(output reg [95:0]FEC,output reg status,input data,clck,start);
    reg [5:0]c;         //Count
    reg [3:0] b;        //Buffer
    reg f;              //Flag
    always@(posedge clck,posedge start) begin
        if(start==1) begin
            c<=48;
            b<=4'b0000;
            status<=0;
            FEC<=0;
            f<=0;
        end
        else if(c>0) begin
            if(f==1) begin
                FEC[2*c-1]<=b[3]+b[1]+b[0];
                FEC[2*c-2]<=b[3]+b[2]+b[1]+b[0];
                c<=c-1'b1;  
            end
            b[3:0]<={data,b[3:1]};
            f<=1;
        end
        else status<=1;
    end

endmodule 