/*
 * Copyright (c) 2024 Your Name
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module tt_um_one_bit_puf_wrapper (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // always 1 when the design is powered, so you can ignore it
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

	// Signals mapped from the wrapper input
	wire start_signal = ui_in[7];           // Map START signal to ena
    wire reset_signal = ~rst_n;        // Map reset signal (active-low)
    
    // Instantiate one_bit_puf or two_bit_puf
    wire one_bit_out;
    one_bit_puf puf_instance (
        .START(start_signal),
        .reset(reset_signal),
        .OUT(one_bit_out)
    );
	
    // Assign the output of one_bit_puf to the first bit of uo_out
    assign uo_out[0] = one_bit_out;

    // Unused output bits are assigned to 0
    assign uo_out[7:1] = 7'b0;
    assign uio_out = 8'b0;
    assign uio_oe  = 8'b0;


  // List all unused inputs to prevent warnings such as:
	wire _unused = &{ui_in[6:0], ena, uio_in, clk, 1'b0};

endmodule
