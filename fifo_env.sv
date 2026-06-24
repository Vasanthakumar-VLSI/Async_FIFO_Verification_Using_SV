class fifo_env;
	fifo_wt_agent wt_agent;
	fifo_rd_agent rd_agent;
	fifo_sbd sbd;
	function new();
		wt_agent=new();
		rd_agent=new();
		sbd=new();
	endfunction

	task run();
		fork
			wt_agent.run();
			rd_agent.run();
			sbd.wt_run();
			sbd.rd_run();
		join
	endtask
endclass
