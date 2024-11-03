// This is a PUF design that includese 2**ADDR_BITS x OUT_BITS one_bit_pufs
// The addr is the address to read OUT_bits of the PUF bits
// For instance if ADDR_BITS = 2, OUT_BITS = 2
// The design will include 8 one_bit_pufs, 
// addr = 2'b10 will read 2 puf bits (OUT[5:4])

module puf #(
    parameter ADDR_BITS = 4,
    parameter OUT_BITS = 8
)
(
input clk,
input START, 
input [ADDR_BITS-1:0] addr,
input reset, 
output reg [OUT_BITS-1:0] OUT_reg
);

localparam TOTAL_PUFs = 2**ADDR_BITS * OUT_BITS;

wire [TOTAL_PUFs-1:0] OUT;

always @(posedge clk or posedge reset) begin
    if (reset) OUT_reg <= 0;
    else OUT_reg = OUT[addr * OUT_BITS +: OUT_BITS];
end

genvar i;
generate
    for (i = 0; i < TOTAL_PUFs; i = i + 1) begin : puf_loop
        one_bit_puf puf_inst(START, reset, OUT[i]);
    end
endgenerate


endmodule

module one_bit_puf(
     input wire START,    // PUF Start signal
     input wire reset,    // Reset signal
     output wire OUT
 );
 (* KEEP = "TRUE" *) wire Q0;
 (* KEEP = "TRUE" *) wire Q1;          // Outputs from the D-Latches
 wire P0;         // Delays through inverters
 wire P1;         // Delays through inverters
 
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