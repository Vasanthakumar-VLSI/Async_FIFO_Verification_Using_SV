class wt_tx;
	rand bit [`WIDTH-1:0]w_data;
	rand bit wt_en;
		 bit full;
		 bit overflow;

	function void print(input string str="");
		$display("%0t ---%s---",$time,str);
		$display("Wt_en=%0d",wt_en);
		$display("W_data=%0d",w_data);
		$display("Full=%0d",full);
		$display("Overflow=%0d",overflow);
	endfunction

endclass
