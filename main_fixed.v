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
                    begin
                        if (BTN_A) 
                        begin
                            turn <= 2'b01;
                            state <= DISPLAY;
                        end
                        else 
                        begin
                            turn <= 2'b10;
                            state <= DISPLAY;
                        end
                    end 
                    else 
                    begin
                        state <= IDLE;
                    end
                end
                DISPLAY: begin
                    if(timer < 2) begin
                        timer <= timer + 1;
                        state <= DISPLAY;
                        //burada led med yakmak gerekebilir ben bilmeyen
			            //simulation kısmı için led'e gerek yok gibi algıladım 
                    end
                    else begin
                        timer <= 0;
                        if(turn == 2'b01) begin
                            state <= HIT_A;
                        end
                        else begin
                            state <= HIT_B;
			                //timer'ları sıfıra eşitledim, asm chartta öyle yazmış şair
                        end
                    end
                end
                HIT_A: begin
                    if (BTN_A && (Y_in_A <5)) begin
                        X_COORD <= 0;
                        Y_COORD <= Y_in_A;
                        dirY <= DIR_A;
                        STATE <= SEND_B;
                    end
                    else begin
                        state <= HIT_A;
                    end
                end
                HIT_B: begin
                    if (BTN_B && (Y_in_B <5)) begin
                        X_COORD <= 7;
                        Y_COORD <= Y_in_B;
                        dirY <= DIR_B;
                        STATE <= SEND_A;
                    end
                    else begin
                        state <= HIT_B;
                    end
                end
                SEND_A: begin
                    if(timer < 2) begin
                        timer <= timer + 1;
                        state <= SEND_A;
                    end
                    else begin
                        timer <= 0;

                        if(dirY == 2'b10) begin
                            if(Y_COORD == 0) begin
                                dirY <= 2'b01;
                                Y_COORD <= Y_COORD + 1;
                            end
                            else begin
                                Y_COORD <= Y_COORD - 1;
                            end
                        end

                        else if (dirY == 2'b01) begin
                            if(Y_COORD == 4) begin
                                dirY <= 2'b10;
                                Y_COORD <= Y_COORD - 1;
                            end
                            else begin
                                Y_COORD <= Y_COORD + 1;
                            end
                        end
                        else begin
                            Y_COORD <= Y_COORD;
                        end
                        
                        if (X_COORD > 1) begin
                            X_COORD <= X_COORD - 1;
                            state <= SEND_A;
                        end
                        else begin
                            X_COORD <= 0;
                            state <= RESP_A;
                        end
                    end
                end
                SEND_B: begin
                    if(timer < 2) begin
                        timer <= timer + 1;
                        state <= SEND_B;
                    end
                    else begin
                        timer <= 0;
                        if(dirY == 2'b10) begin
                            if(Y_COORD == 0) begin
                                dirY <= 2'b01;
                                Y_COORD <= Y_COORD + 1;
                            end
                            else begin
                                Y_COORD <= Y_COORD - 1;
                            end
                        end

                        else if (dirY == 2'b01) begin
                            if(Y_COORD == 4) begin
                                dirY <= 2'b10;
                                Y_COORD <= Y_COORD - 1;
                            end
                            else begin
                                Y_COORD <= Y_COORD + 1;
                            end
                        end
                        else begin
                            Y_COORD <= Y_COORD;
                        end
                        if (X_COORD < 3) begin
                                X_COORD <= X_COORD + 1;
                                state <= SEND_B;
                        end
                        else begin
                                X_COORD <= 4;
                                state <= RESP_B;
                        end    
                    end
                end
                RESP_A: begin
                    if(timer < 2) begin
                        if(BTN_A && (Y_COORD == Y_in_A)) begin
                            X_COORD <= 1;
                            timer <= 0;
                            if (DIR_B == 2'b00) begin
                                dirY <= DIR_B;
                                state <= SEND_B;
                            end
                            else if(DIR_B == 2'b01) begin
                                if(Y_COORD == 4) begin
                                    dirY <= 2'b10;
                                    Y_COORD <= Y_COORD - 1;
                                    STATE <= SEND_B;
                                end
                                else begin
                                    dirY <= DIR_A;
                                    Y_COORD <= Y_COORD + 1;
                                    STATE <= SEND_B;
                                end
                            end
                            else begin
                                if(Y_COORD == 0) begin
                                    dirY <= 2'b01;
                                    Y_COORD <= Y_COORD + 1;
                                    STATE <= SEND_B;
                                end
                                else begin
                                    dirY <= DIR_A;
                                    Y_COORD <= Y_COORD - 1;
                                    STATE <= SEND_B;
                                end
                            end
                        end
                        else begin
                            timer <= timer + 1;
                            state <= RESP_A;
                        end
                    end
                    else begin
                        timer <= 0;
                        score_B <= score_B + 1;
                        state <= GOAL_B;
                    end
                end
                RESP_B: begin
                    if(timer < 2) begin
                        if(BTN_B && (Y_COORD == Y_in_B)) begin
                            X_COORD <= 3;
                            timer <= 0;
                            if (DIR_A == 2'b00) begin
                                dirY <= DIR_A;
                                state <= SEND_A;
                            end
                            else if(DIR_A == 2'b01) begin
                                if(Y_COORD == 4) begin
                                    dirY <= 2'b10;
                                    Y_COORD <= Y_COORD - 1;
                                    STATE <= SEND_A;
                                end
                                else begin
                                    dirY <= DIR_B;
                                    Y_COORD <= Y_COORD + 1;
                                    STATE <= SEND_A;
                                end
                            end
                            else begin
                                if(Y_COORD == 0) begin
                                    dirY <= 2'b01;
                                    Y_COORD <= Y_COORD + 1;
                                    STATE <= SEND_A;
                                end
                                else begin
                                    dirY <= DIR_A;
                                    Y_COORD <= Y_COORD - 1;
                                    STATE <= SEND_A;
                                end
                            end
                        end
                        else begin 
                            timer <= timer + 1;
                            state <= RESP_B;
                        end
                    end
                    else 
                        timer <= 0;
                        score_A <= score_A + 1;
                        state <= GOAL_A;
                end
                GOAL_A: begin
                    if (timer < 2) begin
                        timer <= timer + 1;
                        state <= GOAL_A;
                    end
                    else begin
                        timer <= 0;
                        if (score_A==3) begin
                            turn <= 2'b01;
                            state <= GAME_OVER;
                        end
                        else begin
                            state <= HIT_B;
                        end
                    end
                end
                GOAL_B: begin
                    if (timer < 2) begin
                        timer <= timer + 1;
                        state <= GOAL_B;
                    end
                    else begin
                        timer <= 0;
                        if (score_B==3) begin
                            turn <= 2'b10;
                            state <= GAME_OVER;
                        end
                        else begin
                            state <= HIT_A;
                        end
                    end
                end
                GAME_OVER: begin
                    if (timer < 2) begin
                        timer <= timer + 1;
                        state <= GAME_OVER;
                    end
                    else begin
                        timer <= 0;
                        state <= IDLE;
                    end
                end
                default: state <= IDLE;
            endcase
        end
    end

endmodule
