module reg_set(output reg [15:0] R,output reg Status,input [15:0]V,input [5:0]cnt,input msb,clck,start);
reg [5:0]c;
always@(posedge clck,posedge start) begin
    if(start==1) begin 
        R<=16'hFFFF;
        c<=0;
        Status<=0;
    end
    else if(c<cnt) begin
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