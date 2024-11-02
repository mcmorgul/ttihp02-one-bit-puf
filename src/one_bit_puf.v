module one_bit_puf(
     input wire START,    // PUF Start signal // enable
     input wire reset,    // Reset signal
     output wire OUT
 );
 (* KEEP = "TRUE" *) wire Q0;
 (* KEEP = "TRUE" *) wire Q1;
 wire P0;         // Delays through inverters
 wire P1;         // Delays through inverters
 // wire enable1, enable0;
 // wire input1, input0;

 Dlatch dl0(START, reset, P1, Q0);
 Dlatch dl1(START, reset, P0, Q1);

 // Inverters for path P1 and P2
 assign P0 = ~Q0;
 assign P1 = ~Q1;

 // Output: Difference between the two paths P1 and P2
 assign OUT = P1;


 endmodule


 module Dlatch(
     input enable,
     input reset,
     input D,
// (* KEEP = "TRUE" *)
  output reg Q
 );
 always @(enable or reset or D) begin
     if (reset)
         Q <= 1'b0;
     else if (enable)
         Q <= D;   // The input to latch 1 is the inverted signal P1
 end

 endmodule

 //module two_bit_puf(input START, input reset, output [1:0] OUT);
//one_bit_puf puf1(START, reset, OUT[1]);
//one_bit_puf puf0(START, reset, OUT[0]);
//endmodule