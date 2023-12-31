module hockey(

    input clk,
    input rst,
    
    input BTN_A,
    input BTN_B,
    
    input [1:0] DIR_A,
    input [1:0] DIR_B,
    
    input [2:0] Y_in_A,
    input [2:0] Y_in_B,
   
    /*output reg LEDA,
    output reg LEDB,
    output reg [4:0] LEDX,
    
    output reg [6:0] SSD7,
    output reg [6:0] SSD6,
    output reg [6:0] SSD5,
    output reg [6:0] SSD4, 
    output reg [6:0] SSD3,
    output reg [6:0] SSD2,
    output reg [6:0] SSD1,
    output reg [6:0] SSD0   */
	
	output reg [2:0] X_COORD,
	output reg [2:0] Y_COORD
    
    );
    
    parameter IDLE = 0, DISPLAY = 1, HIT_A = 2, HIT_B = 3, SEND_A = 4, SEND_B = 5, RESP_A = 6, RESP_B = 7, GOAL_A = 8, GOAL_B = 9, GAME_OVER = 10;
    reg [3:0] state;
    reg [1:0] score_A, score_B;
    reg [1:0] turn;

    initial begin
        state <= IDLE;
        score_A <= 0;
        score_B <= 0;
        X_COORD <= 3'b0;
        Y_COORD <= 3'b0;
        timer <= 0;
    end



    always @(posedge clk or posedge rst)
    begin
        if (rst)
        begin
            state <= IDLE;
            score_A <= 0;
            score_B <= 0;
            X_COORD <= 3'b0;
            Y_COORD <= 3'b0;
            timer <= 0;
        end
        else
        begin
            case (state)
                IDLE: begin
                    if (BTN_A || BTN_B)
                        if (BTN_A)
                            turn <= 2'b01;
                            state <= DISPLAY;
                        else
                            turn <= 2'b10;
                            state <= DISPLAY;
                    else
                        state <= IDLE;
                end
                DISPLAY: begin
                    if(timer < 2)
                        timer <= timer + 1;
                        state <= DISPLAY;
                        //burada led med yakmak gerekebilir ben bilmeyen
                    else
                        if(turn == 2'b01)
                            state <= HIT_A;
                        else
                            state <= HIT_B;
                end
                HIT_A: begin
                    if (BTN_A && (Y_in_A <5))
                        X_COORD <= 0;
                        Y_COORD <= Y_in_A;
                        dirY <= DIR_A;
                        STATE <= SEND_B;
                    else 
                        state <= HIT_A;
                end
                HIT_B: begin
                    if (BTN_B && (Y_in_B <5))
                        X_COORD <= 7;
                        Y_COORD <= Y_in_B;
                        dirY <= DIR_B;
                        STATE <= SEND_A;
                    else 
                        state <= HIT_B;
                end
                end
                SEND_A: begin
                    if(timer < 2)
                        timer <= timer + 1;
                        state <= SEND_A;
                    else
                        timer <= 0;

                        if(dirY == 2'b10)
                            if(Y_COORD == 0)
                                dirY <= 2'b01;
                                Y_COORD <= Y_COORD + 1;
                            else 
                                Y_COORD <= Y_COORD - 1;

                        else if (dirY == 2'b01)
                            if(Y_COORD == 4)
                                dirY <= 2'b10;
                                Y_COORD <= Y_COORD - 1;
                            else 
                                Y_COORD <= Y_COORD + 1;
                        else
                            Y_COORD <= Y_COORD;
                        
                        if (X_COORD > 1)
                            X_COORD <= X_COORD - 1;
                            state <= SEND_A;
                        else
                            X_COORD <= 0;
                            state <= RESP_A;
                end
                SEND_B: begin
                    if(timer < 2)
                        timer <= timer + 1;
                        state <= SEND_B;
                    else
                        timer <= 0;

                        if(dirY == 2'b10)
                            if(Y_COORD == 0)
                                dirY <= 2'b01;
                                Y_COORD <= Y_COORD + 1;
                            else 
                                Y_COORD <= Y_COORD - 1;

                        else if (dirY == 2'b01)
                            if(Y_COORD == 4)
                                dirY <= 2'b10;
                                Y_COORD <= Y_COORD - 1;
                            else 
                                Y_COORD <= Y_COORD + 1;
                        else
                            Y_COORD <= Y_COORD;
                        
                        if (X_COORD < 6)
                            X_COORD <= X_COORD + 1;
                            state <= SEND_B;
                        else
                            X_COORD <= 7;
                            state <= RESP_B;
                end
                end
                RESP_A: begin
                    if(timer < 2)
                        if(BTN_A && (Y_COORD == Y_in_A))
                            X_COORD <= 1;
                            timer <= 0;
                            if (DIR_B == 2'b00)
                                dirY <= DIR_B;
                                state <= SEND_B;
                            else if(DIR_B == 2'b01)
                                if(Y_COORD == 4)
                                    dirY <= 2'b10;
                                    Y_COORD <= Y_COORD - 1;
                                    STATE <= SEND_B;
                                else 
                                    dirY <= DIR_A;
                                    Y_COORD <= Y_COORD + 1;
                                    STATE <= SEND_B;
                            else 
                                if(Y_COORD == 0)
                                    dirY <= 2'b01;
                                    Y_COORD <= Y_COORD + 1;
                                    STATE <= SEND_B;
                                else 
                                    dirY <= DIR_A;
                                    Y_COORD <= Y_COORD - 1;
                                    STATE <= SEND_B;
                        else 
                            timer <= timer + 1;
                            state <= RESP_A;
                    else 
                        timer <= 0;
                        score_B <= score_B + 1;
                        state <= GOAL_B;
                end
                RESP_B: begin
                    if(timer < 2)
                        if(BTN_B && (Y_COORD == Y_in_B))
                            X_COORD <= 6;
                            timer <= 0;
                            if (DIR_A == 2'b00)
                                dirY <= DIR_A;
                                state <= SEND_A;
                            else if(DIR_A == 2'b01)
                                if(Y_COORD == 4)
                                    dirY <= 2'b10;
                                    Y_COORD <= Y_COORD - 1;
                                    STATE <= SEND_A;
                                else 
                                    dirY <= DIR_A;
                                    Y_COORD <= Y_COORD + 1;
                                    STATE <= SEND_A;
                            else 
                                if(Y_COORD == 0)
                                    dirY <= 2'b01;
                                    Y_COORD <= Y_COORD + 1;
                                    STATE <= SEND_A;
                                else 
                                    dirY <= DIR_A;
                                    Y_COORD <= Y_COORD - 1;
                                    STATE <= SEND_A;
                        else 
                            timer <= timer + 1;
                            state <= RESP_B;
                    else 
                        timer <= 0;
                        score_A <= score_A + 1;
                        state <= GOAL_A;
                end
                end
                GOAL_A: begin
                    if timer < 2
                        timer <= timer + 1;
                        state <= GOAL_A;
                    else
                        timer <= 0;
                        if (score_A==3)
                            turn <= 2'b01;
                            state <= GAME_OVER;
                        else
                            state <= HIT_B;
                end
                end
                GOAL_B: begin
                    if timer < 2
                        timer <= timer + 1;
                        state <= GOAL_B;
                    else
                        timer <= 0;
                        if (score_B==3)
                            turn <= 2'b10;
                            state <= GAME_OVER;
                        else
                            state <= HIT_A;
                end
                GAME_OVER: begin
                    if timer < 2
                        timer <= timer + 1;
                        state <= GAME_OVER;
                    else
                        timer <= 0;
                        state <= IDLE;
                end
                end
            end

endmodule
