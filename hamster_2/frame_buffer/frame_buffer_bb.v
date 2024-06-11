
module frame_buffer (
	alt_vip_cl_vfb_0_main_reset_reset,
	alt_vip_cl_vfb_0_mem_reset_reset,
	clk_clk,
	reset_reset_n,
	alt_vip_cl_vfb_0_din_data,
	alt_vip_cl_vfb_0_din_valid,
	alt_vip_cl_vfb_0_din_startofpacket,
	alt_vip_cl_vfb_0_din_endofpacket,
	alt_vip_cl_vfb_0_din_ready,
	alt_vip_cl_vfb_0_mem_master_wr_address,
	alt_vip_cl_vfb_0_mem_master_wr_burstcount,
	alt_vip_cl_vfb_0_mem_master_wr_waitrequest,
	alt_vip_cl_vfb_0_mem_master_wr_write,
	alt_vip_cl_vfb_0_mem_master_wr_writedata,
	alt_vip_cl_vfb_0_mem_master_wr_byteenable,
	alt_vip_cl_vfb_0_mem_clock_clk,
	alt_vip_cl_vfb_0_main_clock_clk,
	alt_vip_cl_vfb_0_dout_data,
	alt_vip_cl_vfb_0_dout_valid,
	alt_vip_cl_vfb_0_dout_startofpacket,
	alt_vip_cl_vfb_0_dout_endofpacket,
	alt_vip_cl_vfb_0_dout_ready,
	alt_vip_cl_vfb_0_mem_master_rd_address,
	alt_vip_cl_vfb_0_mem_master_rd_burstcount,
	alt_vip_cl_vfb_0_mem_master_rd_waitrequest,
	alt_vip_cl_vfb_0_mem_master_rd_read,
	alt_vip_cl_vfb_0_mem_master_rd_readdata,
	alt_vip_cl_vfb_0_mem_master_rd_readdatavalid,
	alt_vip_cl_vfb_0_control_address,
	alt_vip_cl_vfb_0_control_byteenable,
	alt_vip_cl_vfb_0_control_write,
	alt_vip_cl_vfb_0_control_writedata,
	alt_vip_cl_vfb_0_control_read,
	alt_vip_cl_vfb_0_control_readdata,
	alt_vip_cl_vfb_0_control_readdatavalid,
	alt_vip_cl_vfb_0_control_waitrequest);	

	input		alt_vip_cl_vfb_0_main_reset_reset;
	input		alt_vip_cl_vfb_0_mem_reset_reset;
	input		clk_clk;
	input		reset_reset_n;
	input	[11:0]	alt_vip_cl_vfb_0_din_data;
	input		alt_vip_cl_vfb_0_din_valid;
	input		alt_vip_cl_vfb_0_din_startofpacket;
	input		alt_vip_cl_vfb_0_din_endofpacket;
	output		alt_vip_cl_vfb_0_din_ready;
	output	[31:0]	alt_vip_cl_vfb_0_mem_master_wr_address;
	output	[5:0]	alt_vip_cl_vfb_0_mem_master_wr_burstcount;
	input		alt_vip_cl_vfb_0_mem_master_wr_waitrequest;
	output		alt_vip_cl_vfb_0_mem_master_wr_write;
	output	[255:0]	alt_vip_cl_vfb_0_mem_master_wr_writedata;
	output	[31:0]	alt_vip_cl_vfb_0_mem_master_wr_byteenable;
	input		alt_vip_cl_vfb_0_mem_clock_clk;
	input		alt_vip_cl_vfb_0_main_clock_clk;
	output	[11:0]	alt_vip_cl_vfb_0_dout_data;
	output		alt_vip_cl_vfb_0_dout_valid;
	output		alt_vip_cl_vfb_0_dout_startofpacket;
	output		alt_vip_cl_vfb_0_dout_endofpacket;
	input		alt_vip_cl_vfb_0_dout_ready;
	output	[31:0]	alt_vip_cl_vfb_0_mem_master_rd_address;
	output	[5:0]	alt_vip_cl_vfb_0_mem_master_rd_burstcount;
	input		alt_vip_cl_vfb_0_mem_master_rd_waitrequest;
	output		alt_vip_cl_vfb_0_mem_master_rd_read;
	input	[255:0]	alt_vip_cl_vfb_0_mem_master_rd_readdata;
	input		alt_vip_cl_vfb_0_mem_master_rd_readdatavalid;
	input	[3:0]	alt_vip_cl_vfb_0_control_address;
	input	[3:0]	alt_vip_cl_vfb_0_control_byteenable;
	input		alt_vip_cl_vfb_0_control_write;
	input	[31:0]	alt_vip_cl_vfb_0_control_writedata;
	input		alt_vip_cl_vfb_0_control_read;
	output	[31:0]	alt_vip_cl_vfb_0_control_readdata;
	output		alt_vip_cl_vfb_0_control_readdatavalid;
	output		alt_vip_cl_vfb_0_control_waitrequest;
endmodule
