class fifo_rd_agent;
	rd_gen gen;
	rd_bfm bfm;
	rd_mon mon;
	rd_cov cov;
	
	function new();
		cov=new();
		gen=new();
		bfm=new();
		mon=new();
	endfunction

	task run();
	fork
		cov.run();
       	gen.run();
       	bfm.run();
       	mon.run();
	join
	endtask

endclass
