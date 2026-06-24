class wt_mon;
	wt_tx tx;
	virtual wt_if vif;
	task  run();
	vif=top.wt_pif;
	forever begin
		@(vif.wt_mon_cb);
		if(vif.wt_mon_cb.wt_en==1) begin
			tx=new();
			tx.wt_en = vif.wt_mon_cb.wt_en;
			tx.overflow =vif.wt_mon_cb.overflow;
			tx.full=vif.wt_mon_cb.full;
			tx.w_data=vif.wt_mon_cb.w_data;
			fifo_common::wt_mon2cov.put(tx);
			fifo_common::wt_mon2sbd.put(tx);
		end

	end
	endtask

endclass
