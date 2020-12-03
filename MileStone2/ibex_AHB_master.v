// Copyright lowRISC contributors.
// Copyright 2018 ETH Zurich and University of Bologna, see also CREDITS.md.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

`ifdef RISCV_FORMAL
  `define RVFI
`endif

`include "prim_assert.sv"

/**
 * Top level module of the ibex RISC-V core
 */
module ibex_AHB_master #(
    parameter bit                 PMPEnable        = 1'b0,
    parameter int unsigned        PMPGranularity   = 0,
    parameter int unsigned        PMPNumRegions    = 4,
    parameter int unsigned        MHPMCounterNum   = 0,
    parameter int unsigned        MHPMCounterWidth = 40,
    parameter bit                 RV32E            = 1'b0,
    parameter ibex_pkg::rv32m_e   RV32M            = ibex_pkg::RV32MFast,
    parameter ibex_pkg::rv32b_e   RV32B            = ibex_pkg::RV32BNone,
    parameter ibex_pkg::regfile_e RegFile          = ibex_pkg::RegFileFF,
    parameter bit                 BranchTargetALU  = 1'b0,
    parameter bit                 WritebackStage   = 1'b0,
    parameter bit                 ICache           = 1'b0,
    parameter bit                 ICacheECC        = 1'b0,
    parameter bit                 BranchPredictor  = 1'b0,
    parameter bit                 DbgTriggerEn     = 1'b0,
    parameter int unsigned        DbgHwBreakNum    = 1,
    parameter bit                 SecureIbex       = 1'b0,
    parameter int unsigned        DmHaltAddr       = 32'h1A110800,
    parameter int unsigned        DmExceptionAddr  = 32'h1A110808
) (
    // Clock and Reset
    input          clk_i,
    input          rst_ni,

    input          test_en_i,     // enable all clock gates for testing

    input   [31:0] hart_id_i,
    input   [31:0] boot_addr_i,

    
    //AHB interface inputs 
    input	   HGRANT_x,
    input	   HREADY,
    input   [1:0]  HRESP,
    input	   HRESET_n,
    input	   HCLK,
    input  [31:0] HRDATA,
    
    //AHB interface outputs
    output	   HBUSREQ_x,
    output	   HLOCK_x,
    output [1:0]  HTRANS,
    output [31:0] HADDR,
    output 	   HWRITE,
    output [2:0]  HSIZE,
    output [2:0]  HBURST,
    output [3:0]  HPROT,
    output [31:0] HWDATA,
   

    // Interrupt inputs
    input          irq_software_i,
    input          irq_timer_i,
    input          irq_external_i,
    input   [14:0] irq_fast_i,
    input          irq_nm_i,       // non-maskeable interrupt

    // Debug Interface
    input          debug_req_i,

    // RISC-V Formal Interface
    // Does not comply with the coding standards of _i/_o suffixes, but follows
    // the convention of RISC-V Formal Interface Specification.
`ifdef RVFI
    output         rvfi_valid,
    output  [63:0] rvfi_order,
    output  [31:0] rvfi_insn,
    output         rvfi_trap,
    output         rvfi_halt,
    output         rvfi_intr,
    output  [ 1:0] rvfi_mode,
    output  [ 1:0] rvfi_ixl,
    output  [ 4:0] rvfi_rs1_addr,
    output  [ 4:0] rvfi_rs2_addr,
    output  [ 4:0] rvfi_rs3_addr,
    output  [31:0] rvfi_rs1_rdata,
    output  [31:0] rvfi_rs2_rdata,
    output  [31:0] rvfi_rs3_rdata,
    output  [ 4:0] rvfi_rd_addr,
    output  [31:0] rvfi_rd_wdata,
    output  [31:0] rvfi_pc_rdata,
    output  [31:0] rvfi_pc_wdata,
    output  [31:0] rvfi_mem_addr,
    output  [ 3:0] rvfi_mem_rmask,
    output  [ 3:0] rvfi_mem_wmask,
    output  [31:0] rvfi_mem_rdata,
    output  [31:0] rvfi_mem_wdata,
`endif

    // CPU Control Signals
    input          fetch_enable_i,
    output         alert_minor_o,
    output         alert_major_o,
    output         core_sleep_o
);

 // Instruction memory interface
    wire         instr_req_o,
    wire          instr_gnt_i,
    wire          instr_rvalid_i,
    wire  [31:0] instr_addr_o,
    wire   [31:0] instr_rdata_i,
    wire          instr_err_i,

// Data memory interface
    wire         data_req_o,
    wire         data_gnt_i,
    wire         data_rvalid_i,
    wire         data_we_o,
    wire  [3:0]  data_be_o,
    wire  [31:0] data_addr_o,
    wire  [31:0] data_wdata_o,
    wire   [31:0] data_rdata_i,
    wire          data_err_i,



