module IBEX_wrapper
  (
    input  	HCLK,							// System clock
	input	HRESETn,						// System Reset, active low

	// AHB-LITE MASTER PORT for Instructions
	output wire [31:0]  HADDR,				// AHB transaction address
	output wire [ 2:0]  HSIZE,				// AHB size: byte, half-word or word
	output wire [ 1:0]  HTRANS,				// AHB transfer: non-sequential only
	output wire [31:0]  HWDATA,				// AHB write-data
	output wire         HWRITE,				// AHB write control
	input  wire [31:0]  HRDATA,				// AHB read-data
	input  wire         HREADY,				// AHB stall signal
	
	// MISCELLANEOUS 
  	input  wire         NMI,				// Non-maskable interrupt input
  	input  wire         IRQ,				// Interrupt request line
    input  wire [4:0]   IRQ_NUM,			// Interrupt number from the PIC			
  	input  wire 	    SYSTICKCLK,			// SYSTICK clock; ON pulse width is HCLK half period
  	output wire [31:0]	IRQ_MASK
);
  

 
  wire dpower = 1'b1;
  wire dground = 1'b0;

  
  reg data_err_i;
  reg data_rvalid_i;
  wire [3:0] data_be_o;
  reg [1:0] addr_offset;
  reg [31:0] data_wdata_o;
  reg [31:0] data_rdata_i;
  wire data_req_o;
  reg data_gnt_i;
  wire instr_req_o;
  reg instr_gnt_i;
  reg gnt_toggle; // gnt_toggle=0 --> data  gnt_toggle=1 --> Instr
  wire alert_minor_o;
  wire alert_major_o;
  wire core_sleep_o;
  wire [31:0] data_addr_o;
  reg [2:0] hsize;



  


  
  
  //assign data_err_i = (HRESP==2'b01)? 1'b1 : 1'b0; 
  //assign data_rvalid_i = (HRESP==2'b10 || HRESP==2'b11)? 1'b0 : 1'b1;

  ibex_core core (
    // Clock and Reset
    .clk_i(HCLK),
    .rst_ni(HRESETn),

    .test_en_i(dground),     // enable all clock gates for testing

    .hart_id_i(dground),  //???
    .boot_addr_i(dground), //???

    // Instruction memory interface
      .instr_req_o(instr_req_o),
      .instr_gnt_i(instr_gnt_i),
      .instr_rvalid_i(HREADY),
      .instr_addr_o(HADDR),
      .instr_rdata_i(HRDATA),
      .instr_err_i(dground),

    // Data memory interface
    .data_req_o(data_req_o),
    .data_gnt_i(data_gnt_i),
    .data_rvalid_i(HREADY),
    .data_we_o(HWRITE),
    .data_be_o(data_be_o),
    .data_addr_o(data_addr_o),
    .data_wdata_o(HWDATA),
    .data_rdata_i(HRDATA),
    .data_err_i(dground),

    // Interrupt inputs
     .irq_software_i(dground),
     .irq_timer_i(dground),
     .irq_external_i(dground),
     .irq_fast_i(dground),
     .irq_nm_i(dground),       // non-maskeable interrupt

    // Debug Interface
     .debug_req_i(dground),

    // CPU Control Signals
    .fetch_enable_i(dpower),
    .alert_minor_o(alert_minor_o),
    .alert_major_o(alert_major_o),
    .core_sleep_o(core_sleep_o)
);

 
 
  
    always @(*)
  begin
    if (instr_gnt_i)
        begin
        hsize <= 3'b010;
        addr_offset <= 2'b00;
        end
   else
   begin
    case (data_be_o)
     //For a byte 
      4'b0001  :
      begin
      addr_offset <= 2'b00;  
     hsize <= 3'b000;
      end

      4'b0010  :
      begin 
      addr_offset <= 2'b01;
      hsize <= 3'b000;
      end

      4'b0100  :
      begin 
      addr_offset <=2'b10;
      hsize <= 3'b000;
      end

      4'b1000  :
      begin
      addr_offset <= 2'b11;
     hsize <= 3'b000;
      end

      //For a halfword
      4'b0011:
      begin
      addr_offset <= 2'b00;
      hsize <= 3'b001;
      end

      4'b0110:
      begin
      addr_offset <= 2'b01;
      hsize <= 3'b001;
      end

      4'b1100:
      begin
      addr_offset <= 2'b10;
      hsize <= 3'b001;
      end

      //For a word
      4'b1111:
      begin
      addr_offset <= 2'b00;
      hsize <= 3'b010;
      end
      //HWDATA = data_wdata_o;
      //data_rdata_i = HRDATA;

      4'b1110:
      begin
      addr_offset <= 2'b00;
      hsize <= 3'b010;
      end
      //HWDATA = data_wdata_o & 32'ffffff00;
      //data_rdata_i = HRDATA & 32'ffffff00;

      4'b0111:
      begin
      addr_offset <= 2'b00;
      hsize <= 3'b010;
      end
      //HWDATA = data_wdata_o & 32'h00ffffff;
      //data_rdata_i = HRDATA & 32'ffffff00;
     default :begin
               addr_offset <= 0;
               hsize <= 3'b010;
      end
     
      endcase
    end
  end
      

  assign HADDR = data_addr_o | addr_offset; 

  assign HTRANS = 2'b10; //non-sequential;
  assign HSIZE =  hsize;

//arbiter
  
 always @(posedge HCLK )
  begin
  // data_req =1 , inst_req =0
   if (data_req_o &&  !instr_req_o)
     begin
        data_gnt_i =1;
        instr_gnt_i =0;
        gnt_toggle = 1;
     end

  //data_req = 0, Inst_req =1
    
     else  if (!data_req_o &&  instr_req_o)
     begin
        data_gnt_i =0;
        instr_gnt_i =1;
        gnt_toggle = 0;
     end
  // data_req =1, Inst_req =1
   
     else if (data_req_o &&  instr_req_o)
     begin
        data_gnt_i = ~ gnt_toggle;
        instr_gnt_i =gnt_toggle;
     end
  // data_req =0, Inst_req =0
    else
    begin
        data_gnt_i =0;
        instr_gnt_i =0;
    end

  end
  

endmodule
  