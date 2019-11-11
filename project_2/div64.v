`timescale 1ns / 1ps

module div64(
    input clk, 
    input reset,
    input [6:0] mb_cnt, //[cur_state[2:0], enable, cnt2, cnt1, cnt0]
    input [31:0] from_mb,
    output [31:0] out_chunk,
    output [6:0] cnt_div //cur_state[2:0], cnt_reg[3:0]
    );
    
    parameter   IDLE = 3'd0,
                IN_A = 3'd1, 
                IN_B = 3'd2, 
                DIV_1 = 3'd3,
                DIV_2 = 3'd4, 
                WB = 3'd5,
                SUB_I = 3'd6;
    
    reg [2:0] current_state;
    reg [2:0] next_state; 
    reg [3:0] cnt_reg = 3'd0; 
    
    reg[31:0] out_chunk_reg; 
    reg[63:0] result_q, result_r; 
    reg [63:0] div_n, div_d;
    
    integer i = 63; 
    
    // calculate stuff based on current state
    always @ (posedge clk) begin
        if(reset == 1'b1) begin
            div_n <= 64'd0;
            div_d <= 64'd0; 
            result_q <= 64'd0; 
            result_r <= 64'd0; 
            i = 63; 
        end
        else begin
            if(current_state == IDLE) begin
                div_n <= 64'd0;
                div_d <= 64'd0; 
                result_q <= 64'd0;
                result_r <= 64'd0;
                i = 63; 
            end 
            else if(current_state == IN_A) begin
                case(cnt_reg)
                4'd0: begin
                    if(mb_cnt[2:0] == 3'd1) begin
                        div_n[31:0] <= from_mb; 
                        cnt_reg <= cnt_reg + 1'b1;
                    end
                end
                4'd1: begin
                    if(mb_cnt[2:0] == 3'd2) begin
                        div_n[63:32] <= from_mb; 
                        cnt_reg <= 4'b0;
                    end
                end
                endcase
            end
            else if(current_state == IN_B) begin
                case(cnt_reg)
                4'd0: begin
                    if(mb_cnt[2:0] == 3'd0) begin
                        div_d[31:0] <= from_mb; 
                        cnt_reg <= cnt_reg + 1'b1;
                    end
                end
                4'd1: begin
                    if(mb_cnt[2:0] == 3'd1) begin
                        div_d[63:32] <= from_mb; 
                        cnt_reg <= 4'b0;
                    end
                end
                endcase
            end
            else if(current_state == DIV_1) begin
                result_r <= {result_r[62:0], 1'b0}; 
                result_r[0] <= div_n[i];
            end
            else if(current_state == DIV_2) begin
                result_r <= result_r - div_d; 
                result_q[i] <= 1; 
            end
            else if(current_state == SUB_I) begin
                if(next_state != DIV_2) begin
                    i <= i - 1'b1;
                end 
            end
            else if(current_state == WB) begin
                //TODO: temp change later
                case(mb_cnt[2:0])
                    3'd3: begin
                        if(mb_cnt[2:0] == 3'd3) begin
                            out_chunk_reg <= result_r[31:0];
//                            out_chunk_reg <= 32'h00000123;
                            cnt_reg <= 4'b0011;
                        end
                    end
                    3'd2: begin
                        if(mb_cnt[2:0] == 3'd2) begin
                            out_chunk_reg <= result_r[63:32];
//                            out_chunk_reg <= 32'h00000000;
                            cnt_reg <= 4'b0010;
                        end
                    end
                    3'd1: begin
                        if(mb_cnt[2:0] == 3'd1) begin
                            out_chunk_reg <= result_q[31:0]; 
//                            out_chunk_reg <= 32'h00000321;
                            cnt_reg <= 4'b0001;
                        end
                    end
                    3'd0: begin
                        if(mb_cnt[2:0] == 3'd0) begin
                            out_chunk_reg <= result_q[63:32];
//                            out_chunk_reg <= 32'h00000000;
                            cnt_reg <= 4'b0000;
                        end
                    end
                endcase
            end
        end
    end
    
    // set current state
    always @ (posedge clk) begin
        if(reset)
            current_state <= IDLE;
        else
            current_state <= next_state; 
    end
    
    // calculate next state
    always @ (*) begin
        case(current_state)
            IDLE:
                if(mb_cnt[3:0] == 4'b0111 && cnt_reg == 0) begin
                    next_state = IN_A;
                end
                else begin
                    next_state = IDLE; 
                end
            IN_A:
                if(mb_cnt[6:4] == 3'd1) begin
                    next_state = IN_A;
                end
                else begin
                    next_state = IN_B; 
                end
            IN_B:
                if(mb_cnt[6:4] == 3'd3 && cnt_reg == 0) begin
                    next_state = DIV_1;
                end
                else begin
                    next_state = IN_B; 
                end
            DIV_1:
                if(i != 64'b0) begin
                    if(result_r >= div_d) begin
                        next_state = DIV_2;
                    end
                    else begin
                        next_state = SUB_I;
                    end
                end
                else begin
                    next_state = WB; 
                end
            DIV_2:
                next_state = SUB_I; 
            SUB_I: begin
                if(result_r >= div_d) begin
                    next_state = DIV_2;
                end
                else begin
                    next_state = DIV_1; 
                end
            end
            WB: 
                if(mb_cnt[6:4] == 3'd0) begin
                    next_state = IDLE;
                end
                else begin
                    next_state = WB; 
                end
            default:
                next_state = IDLE; 
        endcase
    end
    
    assign out_chunk = out_chunk_reg; 
    assign cnt_div = {current_state, cnt_reg}; 
    
endmodule
