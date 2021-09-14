//----------------------------------------------------------------------
module Breadboard	(w,x,y,z,r1,r2,r3,r4,r5,r6,r7,r8,r9,r10); //Module Header
input w,x,y,z;                                             //Specify inputs
output r1,r2,r3,r4,r5,r6,r7,r8,r9,r10;                        //Specify outputs
reg r1, r2, r3,r4,r5,r6,r7,r8,r9,r10;                           //Output is a memory area.

always @ ( w,x,y,z,r1,r2,r3,r4,r5,r6,r7,r8,r9,r10) begin      //Create a set of code that works line by line

r1= ((!w)&(!x)&y&z) | ((!w)&x&y&(!z)) | ((!w)&x&y&z) | (w&(!x)&(!y)&z) | (w&(!x)&y&z) | (w&x&(!y)&(!z)) | (w&x&(!y)&z) | (w&x&y&(!z)) | (w&x&y&z);              //Bitwise operation of the formula
r2= ((!w)&(!x)&y&z)|((!w)&x&(!y)&z)|((!w)&x&y&z)|(w&(!x)&y&z)|(w&x&(!y)&(!z))|(w&x&(!y)&z)|(w&x&y&(!z))|(w&x&y&z);
r3= ((!w)&x&y&z)|(w&(!x)&y&z)|(w&x&(!y)&z)|(w&x&y&(!z))|(w&x&y&z);
r4= ((!w)&x&y&(!z)) | ((!w)&x&y&z) | (w&(!x)&y&z) | (w&(!x)&(!y)&z) | (w&x&(!y)&z) | (w&x&y&(!z)) | (w&x&y&z);
r5= ((!w)&(!x)&y&z) | ((!w)&x&y&z) | (w&(!x)&y&z) | (w&x&y&z);
r6= ((!w)&(!x)&(!y)&(!z)) | ((!w)&(!x)&(!y)&z) | ((!w)&(!x)&y&(!z)) | ((!w)&(!x)&y&z) | ((!w)&x&(!y)&(!z)) | (w&(!x)&(!y)&(!z)) | (w&x&(!y)&(!z));
r7= ((!w)&(!x)&(!y)&z) | ((!w)&(!x)&y&(!z)) | ((!w)&(!x)&y&z) | ((!w)&x&(!y)&z) | (w&(!x)&(!y)&(!z)) | (w&x&(!y)&z);
r8= ((!w)&(!x)&y&z) | ((!w)&x&(!y)&z) | ((!w)&x&y&(!z)) | (w&(!x)&(!y)&z) | (w&(!x)&y&(!z)) | (w&x&(!y)&(!z));
r9= ((!w)&(!x)&y&z) | ((!w)&x&y&z) | (w&(!x)&y&z) | (w&x&y&z);
r10= ((!w)&(!x)&(!y)&z) | ((!w)&(!x)&y&(!z)) | ((!w)&x&(!y)&(!z)) | ((!w)&x&y&z) | (w&(!x)&(!y)&(!z)) | (w&(!x)&y&z) | (w&x&(!y)&z) | (w&x&y&(!z));

end                                   // Finish the Always block

endmodule                             //Module End

//----------------------------------------------------------------------

module testbench();

  reg [4:0] i; //A loop control for 16 rows of a truth table.
  reg  a;//Value of 2^3
  reg  b;//Value of 2^2
  reg  c;//Value of 2^1
  reg  d;//Value of 2^0
  
  //A wire can hold the return of a function
  wire  f0,f1,f2,f3,f4,f5,f6,f7,f8,f9;
  
  Breadboard zap(a,b,c,d,f0,f1,f2,f3,f4,f5,f6,f7,f8,f9);
  

  initial begin
   	
  //$display acts like a classic C printf command.
  $display ("|##|W|X|Y|Z|F0|F1|F2|F3|F4|F5|F6|F7|F8|F9|");
  $display ("|==+=+=+=+=+==+==+==+==+==+==+==+==+==+==|");
  
    //A for loop, with register i being the loop control variable.
	for (i = 0; i < 16; i = i + 1) 
	begin//Open the code blook of the for loop
		a=(i/8)%2;//High bit
		b=(i/4)%2;
		c=(i/2)%2;
		d=(i/1)%2;//Low bit	
		 
		#60;
		 	
		$display ("|%2d|%1d|%1d|%1d|%1d| %1d| %1d| %1d| %1d| %1d| %1d| %1d| %1d| %1d| %1d|",i,a,b,c,d,f0,f1,f2,f3,f4,f5,f6,f7,f8,f9);
		if(i%4==3) 
		 $display ("|--+-+-+-+-+--+--+--+--+--+--+--+--+--+--|");//Only one line, does not need a code block

	end//End of the for loop code block
 
	#10; //A time dealy of 10 time unit
	$finish;
  end  //End the code block of the main (initial)
  
endmodule //Close the testbench module
