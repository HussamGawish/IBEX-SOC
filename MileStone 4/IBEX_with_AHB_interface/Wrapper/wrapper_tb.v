module wrapper_tb();
    reg 	HCLK;							// System clock
	reg	HRESETn;						// System Reset, active low

	// AHB-LITE MASTER PORT for Instructions
	 wire [31:0]  HADDR;				// AHB transaction address
	 wire [ 2:0]  HSIZE;				// AHB size: byte, half-word or word
	 wire [ 1:0]  HTRANS;				// AHB transfer: non-sequential only
	 wire [31:0]  HWDATA;				// AHB write-data
	 wire         HWRITE;				// AHB write control
	reg   [31:0]  HRDATA;				// AHB read-data
	reg          HREADY;				// AHB stall signal
	
	// MISCELLANEOUS 
  	reg         NMI;				// Non-maskable interrupt input
  	reg         IRQ;				// Interrupt request line
    reg [4:0]   IRQ_NUM;			// Interrupt number from the PIC			
  	reg 	    SYSTICKCLK;			// SYSTICK clock; ON pulse width is HCLK half period
  	 wire [31:0]	IRQ_MASK;

 IBEX_wrapper ibex_wrapper
  (
     	HCLK,							// System clock
		HRESETn,						// System Reset, active low

	// AHB-LITE MASTER PORT for Instructions
	   HADDR,				// AHB transaction address
	   HSIZE,				// AHB size: byte, half-word or word
	   HTRANS,				// AHB transfer: non-sequential only
	   HWDATA,				// AHB write-data
	   HWRITE,				// AHB write control
	   HRDATA,				// AHB read-data
       HREADY,				// AHB stall signal
	
	// MISCELLANEOUS 
       NMI,				// Non-maskable interrupt input
       IRQ,				// Interrupt request line
       IRQ_NUM,			// Interrupt number from the PIC			
       SYSTICKCLK,			// SYSTICK clock; ON pulse width is HCLK half period
  	   IRQ_MASK
);


 always #10 HCLK = ~HCLK;

   initial begin
        HCLK = 0;
        HRESETn = 0;
        HRDATA = 0;
        HREADY = 0;
        NMI = 0;
		IRQ = 0;
	    IRQ_NUM = 0;
		SYSTICKCLK = 0;
    end

initial begin
        $dumpfile("wrapper_tb.vcd");
        $dumpvars();
       

        // Reset operation
        HRESETn = 1'b0;
        #2;
        HRESETn = 1'b1;
        #2;

        
        #100;

        $finish;
    end
endmodule