class wt_bfm;
	wt_tx tx;
	virtual wt_if vif;
	task  run();
		int i=0;
		vif=top.wt_pif;
		forever begin
			fifo_common::wt_gen2bfm.get(tx);
			drive_tx(tx);	
			tx.print($sformatf("Wt_bfm_%0d",++i));
		end
	endtask

	task drive_tx(input wt_tx tx);
	@(vif.wt_bfm_cb);
			vif.wt_bfm_cb.wt_en  <=tx.wt_en;
			vif.wt_bfm_cb.w_data <=tx.w_data;
			tx.full              =vif.wt_bfm_cb.full;
			tx.overflow          =vif.wt_bfm_cb.overflow;
			@(vif.wt_bfm_cb);
			vif.wt_bfm_cb.wt_en<=0;
			vif.wt_bfm_cb.w_data<=0;	
	endtask

endclass
