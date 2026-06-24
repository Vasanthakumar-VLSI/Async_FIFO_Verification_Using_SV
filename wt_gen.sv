class wt_gen;
	wt_tx tx;	
	task  run();
	int i=0;
	case(fifo_common::test_name)
		"N_times":begin
			repeat(fifo_common::N)begin
				tx=new();
				tx.randomize() with{tx.wt_en==1;};
				tx.print($sformatf("Wt_gen_%0d",++i));
				fifo_common::wt_gen2bfm.put(tx);
			end
		end

	endcase
	endtask

endclass
