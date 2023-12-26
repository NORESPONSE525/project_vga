module VGA (vga_clk,clrn,d_in,row_addr,col_addr,rdn,r,g,b,hs,vs); // vga

   input     [11:0] d_in;     // bbbb_gggg_rrrr, pixel
   input            vga_clk;  // 25MHz
   input            rst;
   output reg [8:0] row_addr; // pixel ram row address, 480 (512) lines
   output reg [9:0] col_addr; // pixel ram col address, 640 (1024) pixels
   output reg [3:0] r,g,b; // red, green, blue colors
   output reg       rdn;      // read pixel RAM (active_low)
   output reg       hs,vs;    // horizontal and vertical synchronization
	
   // h_count: VGA horizontal counter (0-799)
   reg [9:0] h_count; // VGA horizontal counter (0-799): pixels
   always @ (posedge vga_clk) begin
       if (!clrn) begin
           h_count <= 10'h0;
       end else if (h_count == 10'd799) begin
           h_count <= 10'h0;
       end else begin 
           h_count <= h_count + 10'h1;
       end
   end
	
   // v_count: VGA vertical counter (0-524)
   reg [9:0] v_count; // VGA vertical   counter (0-524): lines
   always @ (posedge vga_clk or negedge rst) begin
       if (!rst) begin
           v_count <= 10'h0;
       end else if (h_count == 10'd799) begin
           if (v_count == 10'd524) begin
               v_count <= 10'h0;
           end else begin
               v_count <= v_count + 10'h1;
           end
       end
   end
	
    // signals, will be latched for outputs
    wire  [9:0] row    =  v_count - 10'd35;     // pixel ram row addr 
    wire  [9:0] col    =  h_count - 10'd143;    // pixel ram col addr 
    wire        h_sync = (h_count > 10'd95);    //  96 -> 799
    wire        v_sync = (v_count > 10'd1);     //   2 -> 524
    wire        read   = (h_count > 10'd142) && // 143 -> 782
                         (h_count < 10'd783) && //        640 pixels
                         (v_count > 10'd34)  && //  35 -> 514
                         (v_count < 10'd515);   //        480 lines
								 
    // vga signals
    always @ (posedge vga_clk) begin
	 	 if (!rst) 
			begin
				row_addr <=  9'b0; // pixel ram row address
				col_addr <=  10'b0;      // pixel ram col address
				rdn      <=  1'b1;     // read pixel (active low)
				hs       <=  1'b0;   // horizontal synchronization
				vs       <=  1'b0;   // vertical   synchronization
				r        <=  4'b0; // 3-bit red
				g        <=  4'b0; // 3-bit green
				b        <=  4'b0; // 2-bit blue
		   end
		 else
			begin
				row_addr <=  row[8:0]; // pixel ram row address
				col_addr <=  col;      // pixel ram col address
				rdn      <= ~read;     // read pixel (active low)
				hs       <=  h_sync;   // horizontal synchronization
				vs       <=  v_sync;   // vertical   synchronization
				r        <=  rdn ? 4'h0 : d_in[3:0]; // 3-bit red
				g        <=  rdn ? 4'h0 : d_in[7:4]; // 3-bit green
				b        <=  rdn ? 4'h0 : d_in[11:8]; // 2-bit blue
		   end
    end
endmodule
