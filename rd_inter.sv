interface rd_if(input reg rd_clk,rst);
	logic rd_en;
	logic [`WIDTH-1:0]r_data;
	logic empty;
	logic underflow;	

	clocking rd_bfm_cb @(posedge rd_clk);
		default input #0 output #1;
		input empty,underflow,r_data;
		output rd_en;
	endclocking

	clocking rd_mon_cb @(posedge rd_clk);
		default input #1;
		input empty,underflow,r_data,rd_en;
	endclocking
endinterface
