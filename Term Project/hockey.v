module hockey(

input clk,
input rst,

input BTNA,
input BTNB,

input [1:0] DIRA,
input [1:0] DIRB,

input [2:0] YA,
input [2:0] YB,

output reg LEDA,
output reg LEDB,
output reg [4:0] LEDX,

output reg [6:0] SSD7,
output reg [6:0] SSD6,
output reg [6:0] SSD5,
output reg [6:0] SSD4, 
output reg [6:0] SSD3,
output reg [6:0] SSD2,
output reg [6:0] SSD1,
output reg [6:0] SSD0   

);

parameter IDLE = 0, DISPLAY = 1, HIT_A = 2, 
HIT_B = 3, SEND_A = 4, SEND_B = 5, RESP_A = 6, 
RESP_B = 7, GOAL_A = 8, GOAL_B = 9, GAME_OVER = 10;

reg [3:0] state;
reg [1:0] score_A, score_B;
reg [1:0] turn;
reg [1:0] dirY;
reg [32:0] timer;
reg [2:0] X_COORD, Y_COORD;
reg [1:0] A_Score, B_Score;


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
        A_Score <= score_A;
        B_Score <= score_B;
        case (state)
            IDLE: begin
                if (BTNA || BTNB) 
                begin
                    if (BTNA) 
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
                if(timer < 100) begin
                    timer <= timer + 1;
                    state <= DISPLAY;
                end
                else begin
                    timer <= 0;
                    if(turn == 2'b01) begin
                        state <= HIT_A;
                    end
                    else begin
                        state <= HIT_B;
                    end
                end
            end
            HIT_A: begin
                if (BTNA && (YA <5)) begin
                    X_COORD <= 0;
                    Y_COORD <= YA;
                    dirY <= DIRA;
                    state <= SEND_B;
                end
                else begin
                    state <= HIT_A;
                end
            end
            HIT_B: begin
                if (BTNB && (YB <5)) begin
                    X_COORD <= 4;
                    Y_COORD <= YB;
                    dirY <= DIRB;
                    state <= SEND_A;
                end
                else begin
                    state <= HIT_B;
                end
            end
            SEND_A: begin
                if(timer < 100) begin
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
                if(timer < 100) begin
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
                if(timer < 100) begin
                    if(BTNA && (Y_COORD == YA)) begin
                        X_COORD <= 1;
                        timer <= 0;
                        if (DIRA == 2'b00) begin
                            dirY <= DIRA;
                            state <= SEND_B;
                        end
                        else if(DIRA == 2'b01) begin
                            if(Y_COORD == 4) begin
                                dirY <= 2'b10;
                                Y_COORD <= Y_COORD - 1;
                                state <= SEND_B;
                            end
                            else begin
                                dirY <= DIRA;
                                Y_COORD <= Y_COORD + 1;
                                state <= SEND_B;
                            end
                        end
                        else begin
                            if(Y_COORD == 0) begin
                                dirY <= 2'b01;
                                Y_COORD <= Y_COORD + 1;
                                state <= SEND_B;
                            end
                            else begin
                                dirY <= DIRA;
                                Y_COORD <= Y_COORD - 1;
                                state <= SEND_B;
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
                if(timer < 100) begin
                    if(BTNB && (Y_COORD == YB)) begin
                        X_COORD <= 3;
                        timer <= 0;
                        if (DIRB == 2'b00) begin
                            dirY <= DIRB;
                            state <= SEND_A;
                        end
                        else if(DIRB == 2'b01) begin
                            if(Y_COORD == 4) begin
                                dirY <= 2'b10;
                                Y_COORD <= Y_COORD - 1;
                                state <= SEND_A;
                            end
                            else begin
                                dirY <= DIRB;
                                Y_COORD <= Y_COORD + 1;
                                state <= SEND_A;
                            end
                        end
                        else begin
                            if(Y_COORD == 0) begin
                                dirY <= 2'b01;
                                Y_COORD <= Y_COORD + 1;
                                state <= SEND_A;
                            end
                            else begin
                                dirY <= DIRB;
                                Y_COORD <= Y_COORD - 1;
                                state <= SEND_A;
                            end
                        end
                    end
                    else begin
                        timer <= timer + 1;
                        state <= RESP_B;
                    end
                end
                else begin
                    timer <= 0;
                    score_A <= score_A + 1;
                    state <= GOAL_A;
                end
            end
            GOAL_A: begin
                if (timer < 100) begin
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
                if (timer < 100) begin
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
                if (timer < 100) begin
                    timer <= timer + 1;
                    state <= GAME_OVER;
                end
                else begin
                    timer <= 0;
                    state <= GAME_OVER;
                end
            end
            default: begin
                state <= IDLE;
            end
        endcase
    end
end   

// for LEDs
always @ (*)
begin
    case (state)
        IDLE: begin
            LEDA = 1;
            LEDB = 1;
            LEDX = 5'b00000;
        end
        DISPLAY, GOAL_A, GOAL_B: begin
            LEDA = 0;
            LEDB = 0;
            LEDX = 5'b11111;
        end
        HIT_A: begin
            LEDA = 1;
            LEDB = 0;
            LEDX = 5'b00000;
        end
        HIT_B: begin
            LEDA = 0;
            LEDB = 1;
            LEDX = 5'b00000;
        end
        RESP_A: begin
            LEDA = 1;
            LEDB = 0;
            LEDX = 5'b10000;
        end
        RESP_B: begin
            LEDA = 0;
            LEDB = 1;
            LEDX = 5'b00001;
        end
        SEND_A: begin
            LEDA = 0;
            LEDB = 0;
            case (X_COORD)
            0: LEDX = 5'b10000;
            1: LEDX = 5'b01000;
            2: LEDX = 5'b00100;
            3: LEDX = 5'b00010;
            4: LEDX = 5'b00001;
            endcase
        end
        SEND_B: begin
            LEDA = 0;
            LEDB = 0;
            case (X_COORD)
            0: LEDX = 5'b10000;
            1: LEDX = 5'b01000;
            2: LEDX = 5'b00100;
            3: LEDX = 5'b00010;
            4: LEDX = 5'b00001;
            endcase
        end
        GOAL_A: begin
            LEDA = 1;
            LEDB = 0;
            LEDX = 5'b00000;
        end
        GOAL_B: begin
            LEDA = 0;
            LEDB = 1;
            LEDX = 5'b00000;
        end
        GAME_OVER: begin
            if (timer < 50) begin
                LEDA = 0;
                LEDB = 0;
                LEDX = 5'b10101;
            end
            else begin
                LEDA = 0;
                LEDB = 0;
                LEDX = 5'b01010;
            end
        end
        default: begin
            LEDA = 0;
            LEDB = 0;
            LEDX = 5'b11111;
        end
    endcase

end

//for SSDs
always @ (*)
begin
    SSD1 = 7'b1111111;
    SSD6 = 7'b1111111;
    SSD3 = 7'b1111111;
    SSD5 = 7'b1111111;
    SSD7 = 7'b1111111;
    SSD2 = 7'b1111111;
    SSD0 = 7'b1111111;
    SSD4 = 7'b1111111;


    case(state)
        IDLE: begin
            SSD2 = 7'b0001000;
            SSD0 = 7'b1100000;
            SSD1 = 7'b1111110;
            SSD6 = 7'b1111111;
            SSD3 = 7'b1111111;
            SSD5 = 7'b1111111;
            SSD7 = 7'b1111111;
            SSD4 = 7'b1111111;
        end
        DISPLAY: begin
            case (score_A)
                0: SSD2 = 7'b0000001;
                1: SSD2 = 7'b1001111;
                2: SSD2 = 7'b0010010;
                3: SSD2 = 7'b0000110;
                default: SSD2 = 7'b1111111;
            endcase
            case (score_B)
                0: SSD0 = 7'b0000001;
                1: SSD0 = 7'b1001111;
                2: SSD0 = 7'b0010010;
                3: SSD0 = 7'b0000110;
                default: SSD0 = 7'b1111111;
            endcase
            SSD1 = 7'b1111110;
            SSD6 = 7'b1111111;
            SSD3 = 7'b1111111;
            SSD5 = 7'b1111111;
            SSD7 = 7'b1111111;
            SSD4 = 7'b1111111;
        end
        HIT_A: begin
            case (YA)
                0: SSD4 = 7'b0000001;
                1: SSD4 = 7'b1001111;
                2: SSD4 = 7'b0010010;
                3: SSD4 = 7'b0000110;
                4: SSD4 = 7'b1001100;
                default: SSD4 = 7'b1111110;
            endcase
        end
        HIT_B: begin
            case (YB)
                0: SSD4 = 7'b0000001;
                1: SSD4 = 7'b1001111;
                2: SSD4 = 7'b0010010;
                3: SSD4 = 7'b0000110;
                4: SSD4 = 7'b1001100;
                default: SSD4 = 7'b1111110;
            endcase
        end
        RESP_A, SEND_A, RESP_B, SEND_B: begin
            case (Y_COORD)
                0: SSD4 = 7'b0000001;
                1: SSD4 = 7'b1001111;
                2: SSD4 = 7'b0010010;
                3: SSD4 = 7'b0000110;
                4: SSD4 = 7'b1001100;
                default: SSD4 = 7'b1111110;
            endcase
        end
        GOAL_A, GOAL_B: begin
            case (score_A)
                0: SSD2 = 7'b0000001;
                1: SSD2 = 7'b1001111;
                2: SSD2 = 7'b0010010;
                3: SSD2 = 7'b0000110;
                default: SSD2 = 7'b1111111;
            endcase
            case (score_B)
                0: SSD0 = 7'b0000001;
                1: SSD0 = 7'b1001111;
                2: SSD0 = 7'b0010010;
                3: SSD0 = 7'b0000110;
                default: SSD0 = 7'b1111111;
            endcase
            SSD1 = 7'b1111110;
            SSD6 = 7'b1111111;
            SSD3 = 7'b1111111;
            SSD5 = 7'b1111111;
            SSD7 = 7'b1111111;
            SSD4 = 7'b1111111;
        end
        GAME_OVER: begin
            case (score_A)
                0: SSD2 = 7'b0000001;
                1: SSD2 = 7'b1001111;
                2: SSD2 = 7'b0010010;
                3: SSD2 = 7'b0000110;
                default: SSD2 = 7'b1111111;
            endcase
            case (score_B)
                0: SSD0 = 7'b0000001;
                1: SSD0 = 7'b1001111;
                2: SSD0 = 7'b0010010;
                3: SSD0 = 7'b0000110;
                default: SSD0 = 7'b1111111;
            endcase
            SSD1 = 7'b1111110;
            SSD6 = 7'b1111111;
            SSD3 = 7'b1111111;
            SSD5 = 7'b1111111;
            SSD7 = 7'b1111111;
            if (score_A == 3) begin
                SSD4 = 7'b0001000;
            end
            else if (score_B == 3) begin
                SSD4 = 7'b1100000;
            end
            else begin
                SSD4 = 7'b1111111;
        end
        end
        default: begin
            case (score_A)
                0: SSD2 = 7'b0000001;
                1: SSD2 = 7'b1001111;
                2: SSD2 = 7'b0010010;
                3: SSD2 = 7'b0000110;
                default: SSD2 = 7'b1111111;
            endcase
            case (score_B)
                0: SSD0 = 7'b0000001;
                1: SSD0 = 7'b1001111;
                2: SSD0 = 7'b0010010;
                3: SSD0 = 7'b0000110;
                default: SSD0 = 7'b1111111;
            endcase
            SSD1 = 7'b1111110;
            SSD6 = 7'b1111111;
            SSD3 = 7'b1111111;
            SSD5 = 7'b1111111;
            SSD7 = 7'b1111111;
            SSD4 = 7'b1111111;
        end
    endcase
end


endmodule