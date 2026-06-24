class rd_tx;
		 bit [`WIDTH-1:0]r_data;
	rand bit rd_en;
		 bit empty;
		 bit underflow;

	function void print(input string str="");
		$display("%0t ---%s---",$time,str);
		$display("Rd_en=%0d",rd_en);
		$display("r_data=%0d",r_data);
		$display("Empty=%0d",empty);
		$display("Underflow=%0d",underflow);
	endfunction

endclass
