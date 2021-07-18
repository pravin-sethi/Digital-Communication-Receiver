module t_main();
  wire [95:0] out;
wire status;
wire [95:0]fec;
wire [15:0]crc;
reg clck,start,x;

main m(out,fec,crc,status,x,clck,start);

initial begin clck = 1; forever #5 clck = ~clck; end
initial begin
    $dumpfile("dump.vcd"); 
    $dumpvars;
end

  initial begin
    start=1;
    x = 0;//0
    #5 start=0;
    #10 x = 0;
    #10 x = 0;
    #10 x = 0;
    #10 x = 0;//3
    #10 x = 0;
    #10 x = 1;
    #10 x = 1;
    #10 x = 0;//0
    #10 x = 0;
    #10 x = 0;
    #10 x = 0;
    #10 x = 0;//1
    #10 x = 0;
    #10 x = 0;
    #10 x = 1;
    #10 x = 0;//0
    #10 x = 0;
    #10 x = 0;
    #10 x = 0;
    #10 x = 0;//2
    #10 x = 0;
    #10 x = 1;
    #10 x = 0;
    #10 x = 0;//0
    #10 x = 0;
    #10 x = 0;
    #10 x = 0;
    #10 x = 0;//3
    #10 x = 0;
    #10 x = 1;
    #10 x = 1;

  end
  
  initial #550 $finish;
  
  initial begin
    $monitor("%h %h %h %b",crc,fec,out,status,$time);
  end
endmodule

