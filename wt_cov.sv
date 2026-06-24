class wt_cov;
wt_tx tx;
	covergroup WT_CG;
		coverpoint tx.wt_en{
			bins WRITES ={1};
	}	
	endgroup

	function new();
		WT_CG=new();
	endfunction

	task  run();
		forever begin
			fifo_common::wt_mon2cov.get(tx);
			WT_CG.sample();	
		end
	endtask
endclass
