interface wt_if(input reg wt_clk,rst);
	logic wt_en;
	logic [`WIDTH-1:0]w_data;
	logic full;
	logic overflow;

	clocking wt_bfm_cb @(posedge wt_clk);
		default input #0 output #1;
		input full,overflow;
		output wt_en,w_data;
	endclocking

	clocking wt_mon_cb @(posedge wt_clk);
		default input #1;
		input full,overflow,wt_en,w_data;

	endclocking
endinterface
