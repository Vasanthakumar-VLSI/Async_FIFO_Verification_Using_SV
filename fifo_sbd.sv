class fifo_sbd;
	wt_tx tx;
	rd_tx tx1;
	int que[$];	
	int temp;

	task wt_run();
	forever begin
		fifo_common::wt_mon2sbd.get(tx);
		if(tx.wt_en==1) que.push_back(tx.w_data);
	end
	endtask

	task rd_run();
	forever begin
		fifo_common::rd_mon2sbd.get(tx1);
		if(que.size()!=0)begin
			temp=que.pop_front();
			if(temp==tx1.r_data)
				fifo_common::matching++;
			else
				fifo_common::mismatching++;
		end
	end
	endtask
endclass
