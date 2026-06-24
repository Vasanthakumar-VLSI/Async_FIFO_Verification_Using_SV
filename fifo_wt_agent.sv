class fifo_wt_agent;
	wt_gen gen;
	wt_bfm bfm;
	wt_mon mon;
	wt_cov cov;
	
	function new();
		gen=new();
		bfm=new();
		mon=new();
		cov=new();
	endfunction

	task run();
	fork
       	gen.run();
       	bfm.run();
       	mon.run();
		cov.run();
	join
	endtask

endclass
