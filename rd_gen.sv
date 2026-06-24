class rd_gen;
	rd_tx tx;
	task run();
		int i=0;
		case(fifo_common::test_name)
			"N_times":begin
				repeat(fifo_common::N)begin
					tx=new();
					assert(tx.randomize() with{tx.rd_en==1;});
					tx.print($sformatf("Rd_gen_%0d",++i));
					fifo_common::rd_gen2bfm.put(tx);
				end
			end
		endcase
	endtask
endclass
