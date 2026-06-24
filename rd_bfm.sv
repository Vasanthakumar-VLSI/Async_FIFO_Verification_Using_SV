class rd_bfm;
	rd_tx tx;
	virtual rd_if vif;
	task  run();
		int i=0;
		vif=top.rd_pif;
		forever begin
			fifo_common::rd_gen2bfm.get(tx);
			drive_tx(tx);
			tx.print($sformatf("Rd_bfm_%0d",++i));
		end
	endtask

	task drive_tx(input rd_tx tx);
			@(vif.rd_bfm_cb);
			vif.rd_bfm_cb.rd_en	<=tx.rd_en;
			wait(vif.rd_bfm_cb.r_data!=0);
			tx.r_data   		=vif.rd_bfm_cb.r_data;
			tx.empty	   		=vif.rd_bfm_cb.empty;
			tx.underflow		=vif.rd_bfm_cb.underflow;
			@(vif.rd_bfm_cb);
			vif.rd_bfm_cb.rd_en	<=0;
	endtask

endclass
