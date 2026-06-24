class rd_cov;
rd_tx tx;
	covergroup RD_CG;
		coverpoint tx.rd_en{
			bins READ ={1};
		}
	endgroup

	function new();
		RD_CG=new();
	endfunction

	task  run();
		forever begin
			fifo_common::rd_mon2cov.get(tx);
			RD_CG.sample();	
		end
	endtask
endclass
