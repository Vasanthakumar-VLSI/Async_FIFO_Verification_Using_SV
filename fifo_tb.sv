module top;
	reg wt_clk,rd_clk;
	bit rst;
	fifo_env env;
	wt_if wt_pif(.wt_clk(wt_clk),.rst(rst));
	rd_if rd_pif(.rd_clk(rd_clk),.rst(rst));

	fifo dut(
		.rst(rst),
		.wt_clk(wt_pif.wt_clk),
		.rd_clk(rd_pif.rd_clk),
		.w_data(wt_pif.w_data),
		.wt_en(wt_pif.wt_en),
		.full(wt_pif.full),
		.overflow(wt_pif.overflow),
		.empty(rd_pif.empty),
		.rd_en(rd_pif.rd_en),
		.underflow(rd_pif.underflow),
		.r_data(rd_pif.r_data)
		);

always #5 wt_clk=~wt_clk;
always #5 rd_clk=~rd_clk;

	initial begin
		assert($value$plusargs("Test_name=%0s",fifo_common::test_name));
		assert($value$plusargs("N=%0d",fifo_common::N));
		wt_clk=0;
		rd_clk=0;
		rst=1;
		repeat(2) @(posedge wt_clk);
		rst=0;
		env=new();
		env.run();
		end
	initial begin 
		#1000;
		if(fifo_common::matching!=0 && fifo_common::mismatching==0)
			$display("Test Passed");
		else
			$display("Test Failed");

		$finish;
	end

endmodule
