module fifo(
	input wt_en,rd_en,wt_clk,rd_clk,rst,[`WIDTH-1:0]w_data,
	output reg full,overflow,underflow,empty,[`WIDTH-1:0]r_data
);
reg [`WIDTH-1:0]fifo[`FIFO_SIZE-1:0];
reg [`PTR_WIDTH-1:0]wt_ptr;
reg [`PTR_WIDTH-1:0]rd_ptr;
reg wt_toggle_f;
reg rd_toggle_f;
reg wt_ptr_rd_clk;
reg rd_ptr_wt_clk;
reg wt_toggle_f_rd_clk;
reg rd_toggle_f_wt_clk;
integer i;
always @(posedge wt_clk)begin
	if(rst)begin
		full<=0;
		overflow<=0;
		wt_ptr<=0;
		wt_toggle_f<=0;
		rd_ptr_wt_clk<=0;
		rd_toggle_f_wt_clk<=0;
		for(i=0;i<`FIFO_SIZE-1;i=i+1) fifo[i]=0;
	end
	else begin
		if(wt_en==1)begin
			if(full==1)
				overflow<=1;
			else begin
				fifo[wt_ptr]<=w_data;
				if(wt_ptr==`FIFO_SIZE-1)begin
					wt_ptr<=0;
					wt_toggle_f<=~wt_toggle_f;
				end
				else wt_ptr<=wt_ptr+1;
			end
		end
	end
end

always @(posedge rd_clk)begin
	if(rst)begin
		empty<=1;
		underflow<=0;
		rd_ptr<=0;
		rd_toggle_f<=0;
		wt_ptr_rd_clk<=0;
		wt_toggle_f_rd_clk<=0;
	end
	else begin
		if(rd_en==1)begin
			if(empty==1)
				underflow<=1;
			else begin
			underflow<=0;
				r_data<=fifo[rd_ptr];
				if(rd_ptr==`FIFO_SIZE-1)begin
					rd_ptr<=0;
					rd_toggle_f<=~rd_toggle_f;
				end
				else rd_ptr<=rd_ptr+1;
			end
		end
	end
end

always @(posedge wt_clk)begin
	rd_ptr_wt_clk<=rd_ptr;
	rd_toggle_f_wt_clk<=rd_toggle_f;
end
always @(posedge rd_clk)begin
	wt_ptr_rd_clk<=wt_ptr;
	wt_toggle_f_rd_clk<=wt_toggle_f;
end

always @(*)begin
	if(wt_ptr==rd_ptr_wt_clk && wt_toggle_f!=rd_toggle_f_wt_clk) full=1;
	else full=0;
	if(rd_ptr==wt_ptr_rd_clk && rd_toggle_f==wt_toggle_f_rd_clk) empty=1;
	else empty=0;
end
endmodule
