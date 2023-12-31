module hockey_tb();


parameter HP = 5;       // Half period of our clock signal
parameter FP = (2*HP);  // Full period of our clock signal

reg clk, rst, BTN_A, BTN_B;
reg [1:0] DIR_A;
reg [1:0] DIR_B;
reg [2:0] Y_in_A;
reg [2:0] Y_in_B;

wire [2:0] X_COORD, Y_COORD;

// Our design-under-test is the DigiHockey module
hockey dut(clk, rst, BTN_A, BTN_B, DIR_A, DIR_B, Y_in_A, Y_in_B, X_COORD,Y_COORD);

// This always statement automatically cycles between clock high and clock low in HP (Half Period) time. Makes writing test-benches easier.
always #HP clk = ~clk;

initial begin
    
    clk = 0; 
    rst = 0;
    BTN_A = 0;
	BTN_B = 0;
	DIR_A = 0;
	DIR_B = 0;
    Y_in_A = 0;
    Y_in_B = 0;
    
	#FP;
	rst=1;
	#FP;
	rst=0;
	
	// Here, you are asked to write your test scenario.
	
	
	
	
end



endmodule