class rd_mon;
	rd_tx tx;
	virtual rd_if vif;
	task  run();
	vif=top.rd_pif;
	forever begin
		@(vif.rd_mon_cb);
		if(vif.rd_en==1) begin
			tx=new();
			tx.rd_en = vif.rd_mon_cb.rd_en;
			wait(vif.rd_mon_cb.r_data!=0);
			tx.underflow =vif.rd_mon_cb.underflow;
			tx.empty=vif.rd_mon_cb.empty;
			tx.r_data=vif.rd_mon_cb.r_data;
			fifo_common::rd_mon2cov.put(tx);
			fifo_common::rd_mon2sbd.put(tx);
		end
	end
	endtask

endclass
