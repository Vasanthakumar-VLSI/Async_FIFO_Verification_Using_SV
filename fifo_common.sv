`define WIDTH 8
`define FIFO_SIZE 16	
`define PTR_WIDTH $clog2(`FIFO_SIZE)



class fifo_common;
	static string test_name;		
	static int N;
	static int gen_count;
	static int rd_count;
	static mailbox wt_gen2bfm=new;
	static mailbox wt_mon2cov=new;
	static mailbox wt_mon2sbd=new;
	static mailbox rd_gen2bfm=new;
	static mailbox rd_mon2cov=new;
	static mailbox rd_mon2sbd=new;
	static int matching;
	static int mismatching;
endclass
