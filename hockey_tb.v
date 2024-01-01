module hockey_tb();


parameter HP = 5;       // Half period of our clock signal
parameter FP = (2*HP);  // Full period of our clock signal

reg clk, rst, BTN_A, BTN_B;
reg [1:0] DIR_A;
reg [1:0] DIR_B;
reg [2:0] Y_in_A;
reg [2:0] Y_in_B;

wire [2:0] X_COORD, Y_COORD;
wire [3:0] Current_State;
wire [1:0] A_Score;
wire [1:0] B_score;
wire flag;

// Our design-under-test is the DigiHockey module
hockey dut(clk, rst, BTN_A, BTN_B, DIR_A, DIR_B, Y_in_A, Y_in_B, X_COORD,Y_COORD, Current_State, A_Score, B_score, flag);

// This always statement automatically cycles between clock high and clock low in HP (Half Period) time. Makes writing test-benches easier.
always #HP clk = ~clk;

initial begin
	
	$dumpfile("res.vcd"); //  * Our waveform is saved under this file.
    $dumpvars(0,hockey_tb); // * Get the variables from the module.
    
    $display("Simulation started.");

    clk = 0; 
    rst = 0;
    BTN_A = 0;
	BTN_B = 0;
	DIR_A = 0;
	DIR_B = 0;
    Y_in_A = 0;
    Y_in_B = 0;
    
	// Reset the circuit
	rst = 1; 
	#FP
	rst = 0;
	#FP

	//Select who will start the game by pressing BTN_A or BTN_B (assume Player A starts the game) and go to HIT_A state
	BTN_A = 1;
	#FP

	//Take inputs Y_IN_A and DIR_A and after pressing BTN_A go to SEND_B state
	Y_in_A = 1;
	DIR_A = 1;
	BTN_A = 1;
	#(20*FP)
	Y_in_A = 0;
	DIR_A = 0;
	BTN_A = 0;
	//Take inputs Y_IN_B and BTN_B, Y_IN_B not equal to Puck's Y position, go to GOAL_A state
	//Check A has 3 goals, go to HIT_B state (score : 1-0)
	
	//Take inputs Y_IN_B and BTN_B, go to SEND_A state
	Y_in_B = 0;
	BTN_B = 1;
	#(13*FP)

	//Take inputs Y_IN_A and BTN_A, Y_IN_A  equal to Puck's Y position, go to SEND_B state
	BTN_B = 0;
	Y_in_A = 0;
	BTN_A = 1;
	#(9*FP)

	//Take inputs Y_IN_B and BTN_B, Y_IN_B  equal to Puck's Y position, go to SEND_A state
	BTN_A = 0;
	Y_in_B = 0;
	BTN_B = 1;
	#(16*FP)
	//Take inputs Y_IN_A and BTN_A, Y_IN_A not equal to Puck's Y position, go to GOAL_B state
	//Check B has 3 goals, go to HIT_A state (score : 1-1)

	//Take inputs Y_IN_A and BTN_A, go to SEND_B state
	Y_in_A = 2;
	BTN_A = 1;
	#(20*FP)
	//Take inputs Y_IN_B and BTN_B, Y_IN_B not equal to Puck's Y position, go to GOAL_A state
	//Check A has 3 goals, go to HIT_B state (score : 2-1)

	//Take inputs Y_IN_B and BTN_B, go to SEND_A state
	Y_in_B = 0;
	BTN_B = 1;
	#(16*FP)

	//Take inputs Y_IN_A and BTN_A, Y_IN_A  equal to Puck's Y position, go to SEND_B state
	BTN_B = 0;
	Y_in_A = 0;
	BTN_A = 1;
	#(20*FP)
	//Take inputs Y_IN_B and BTN_B, Y_IN_B  equal to Puck's Y position, go to SEND_A state
	//Take inputs Y_IN_B and BTN_B, Y_IN_B not equal to Puck's Y position, go to GOAL_A state
	//Check A has 3 goals, go to END state (score : 3-1)
	
	// Here, you are asked to write your test scenario.
	
	$display("Simulation finished.");
    $finish(); // Finish simulation.
end


endmodule
