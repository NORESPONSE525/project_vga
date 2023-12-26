`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:46:42 12/26/2023 
// Design Name: 
// Module Name:    top 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module top(
	input clk,
	input rst,
	input 
	
    );
	 
	clkdiv(.clk(clk), .rst(rst), .clkdiv(clkdiv));
	ROM_test m0(.clka(clkdiv[16]), .addra(R_rom_addr), .douta(W_rom_data));
	
	VGA m1(
		.d_in(), 
		.vga_clk(clkdiv[16]), 
		.rst(rst), 
		.row_addr(R_rom_addr [18:10]), 
		.col_addr(R_rom_addr [9:0]), 
		.r(W_rom_data[11:8]), 
		.g(W_rom_data[7:4]), 
		.b(W_rom_data[3:0]), 
		.rdn(read_en), 
		.hs(h_sync), 
		.vs(v_sync)
	);


endmodule
