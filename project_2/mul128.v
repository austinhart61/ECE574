`timescale 1ns / 1ps

module mul128(
    input clk, 
    input reset,
    input [31:0] from_mb,
    input [6:0] mb_cnt, //[cur_state[2:0], enable, cnt2, cnt1, cnt0]
    output [6:0] cnt,   //{cur_state[2:0], cnt_reg[3:0]}
    output [31:0] out_chunk
    );
    
    parameter   IDLE = 3'd0,
                IN_A = 3'd1, 
                IN_B = 3'd2, 
                MUL = 3'd3, 
                WB = 3'd4; 
    
    reg [2:0] next_state; 
    reg [2:0] current_state = IDLE; 
    reg [3:0] cnt_reg = 4'd0; 
    reg [4:0] mul_reg = 5'd0; 
    reg[31:0] mul_x, mul_y;
    reg[31:0] out_chunk_reg; 
    //reg [63:0] temp_1, temp_2, temp_3, temp_4; 
    reg [127:0] mul_a, mul_b;
    reg [255:0] result = 256'b0; 
    
    wire[63:0] mul_result;
    
    // calculate stuff based on current state
    always @ (posedge clk) begin
        if(reset == 1'b1) begin
            cnt_reg <= 4'd0;
            mul_a <= 128'd0;
            mul_b <= 128'd0; 
            result <= 256'd0; 
            mul_reg <= 5'd0; 
        end
        else begin
            if(current_state == IDLE) begin
                cnt_reg <= 4'd0;
                mul_a <= 128'd0;
                mul_b <= 128'd0; 
                result <= 256'd0; 
                mul_reg <= 5'd0; 
            end
            else if(current_state == IN_A) begin
                case(cnt_reg)
                4'd0: begin
                    if(mb_cnt[2:0] == 3'd0) begin
                        mul_a[31:0] <= from_mb; 
                        cnt_reg <= cnt_reg + 1'b1;
                    end
                end
                4'd1: begin
                    if(mb_cnt[2:0] == 3'd1) begin
                        mul_a[63:32] = from_mb; 
                        cnt_reg <= cnt_reg + 1'b1;
                    end
                end
                4'd2: begin
                    if(mb_cnt[2:0] == 3'd2) begin
                        mul_a[95:64] = from_mb;
                        cnt_reg <= cnt_reg + 1'b1;
                    end
                end
                4'd3: begin
                    if(mb_cnt[2:0] == 3'd3) begin
                        mul_a[127:96] = from_mb;
                        cnt_reg <= 4'd0;
                    end
                end
                endcase
            end
            else if(current_state == IN_B) begin
                case(cnt_reg)
                4'd0: begin
                    if(mb_cnt[2:0] == 3'd0) begin
                        mul_b[31:0] <= from_mb; 
                        cnt_reg <= cnt_reg + 1'b1;
                    end
                end
                4'd1: begin
                    if(mb_cnt[2:0] == 3'd1) begin
                        mul_b[63:32] = from_mb; 
                        cnt_reg <= cnt_reg + 1'b1;
                    end
                end
                4'd2: begin
                    if(mb_cnt[2:0] == 3'd2) begin
                        mul_b[95:64] = from_mb;
                        cnt_reg <= cnt_reg + 1'b1;
                    end
                end
                4'd3: begin
                    if(mb_cnt[2:0] == 3'd3) begin
                        mul_b[127:96] = from_mb;
                        cnt_reg <= 4'd0;
                    end
                end
                endcase
            end
            else if(current_state == MUL) begin
                case(mul_reg)
                5'd0: begin
                    result <= result + (mul_result << 192);
                    mul_reg <= 5'b00001;
                end
                5'd1: begin
                    result <= result + (mul_result << 160); 
                    mul_reg <= 5'b00010;
                end
                5'd2: begin
                    result <= result + (mul_result << 160);
                    mul_reg <= 5'b00011; 
                end
                5'd3: begin
                    result <= result + (mul_result << 128);
                    mul_reg <= 5'b00100; 
                end   
                5'd4: begin
                    result <= result + (mul_result << 128);
                    mul_reg <= 5'b00101; 
                end    
                5'd5: begin
                    result <= result + (mul_result << 128);
                    mul_reg <= 5'b00110;
                end 
                5'd6: begin
                    result <= result + (mul_result << 96);
                    mul_reg <= 5'b00111;
                end    
                5'd7: begin
                    result <= result + (mul_result << 96);
                    mul_reg <= 5'b01000;
                end 
                5'd8: begin
                    result <= result + (mul_result << 96);
                    mul_reg <= 5'b01001;
                end 
                5'd9: begin
                    result <= result + (mul_result << 96);
                    mul_reg <= 5'b01010;
                end
                5'd10: begin
                    result <= result + (mul_result << 64);
                    mul_reg <= 5'b01011;
                end
                5'd11: begin
                    result <= result + (mul_result << 64);
                    mul_reg <= 5'b01100;
                end
                5'd12: begin
                    result <= result + (mul_result << 64);
                    mul_reg <= 5'b01101;
                end
                5'd13: begin
                    result <= result + (mul_result << 32);
                    mul_reg <= 5'b01110;
                end
                5'd14: begin
                    result <= result + (mul_result << 32);
                    mul_reg <= 5'b01111;
                end
                5'd15: begin
                    result <= result + mul_result;
                    mul_reg <= 5'b11111;
                end
                5'b11111: begin
                    cnt_reg = 4'b1111; 
                end
                endcase
            end
            else if(current_state == WB) begin
                //TODO: temp change later
                case(mb_cnt[2:0])
                    3'd7: begin
                        if(mb_cnt[2:0] == 3'd7) begin
                            out_chunk_reg <= result[31:0];
                            cnt_reg <= 4'b0111;
                        end
                    end
                    3'd6: begin
                        if(mb_cnt[2:0] == 3'd6) begin
                            out_chunk_reg <= result[63:32];
                            cnt_reg <= 4'b0110;
                        end
                    end
                    3'd5: begin
                        if(mb_cnt[2:0] == 3'd5) begin
                            out_chunk_reg <= result[95:64]; 
                            cnt_reg <= 4'b0101;
                        end
                    end
                    3'd4: begin
                        if(mb_cnt[2:0] == 3'd4) begin
                            out_chunk_reg <= result[127:96];
                            cnt_reg <= 4'b0100;
                        end
                    end
                    3'd3: begin
                        if(mb_cnt[2:0] == 3'd3) begin
                            out_chunk_reg <= result[159:128];
                            cnt_reg <= 4'b0011;
                        end
                    end
                    3'd2: begin
                        if(mb_cnt[2:0] == 3'd2) begin
                            out_chunk_reg <= result[191:160];
                            cnt_reg <= 4'b0010;
                        end
                    end
                    3'd1: begin
                        if(mb_cnt[2:0] == 3'd1) begin
                            out_chunk_reg <= result[223:192];
                            cnt_reg <= 4'b0001;
                        end
                    end
                    3'd0: begin
                        if(mb_cnt[2:0] == 3'd0) begin
                            out_chunk_reg <= result[255:224];
                            cnt_reg <= 4'b0;
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
                if(mb_cnt[3:0] == 4'b1111 && cnt_reg == 0) begin
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
                    next_state = MUL;
                end
                else begin
                    next_state = IN_B; 
                end
            MUL:
                if(mb_cnt[6:4] == 3'd4) begin
                    next_state = WB;
                end
                else begin
                    next_state = MUL; 
                end
            WB: 
                if(mb_cnt[6:4] == 3'd4) begin
                    next_state = WB;
                end
                else begin
                    next_state = IDLE; 
                end
            default:
                next_state = IDLE; 
        endcase
    end 
    
    // combinationally set the multiplier. 
    always @(*) begin
    if(current_state == MUL) begin
        case(mul_reg)
        4'd0: begin
            mul_x = mul_a[127:96];
            mul_y = mul_b[127:96];
        end
        4'd1: begin
            mul_x = mul_a[127:96];
            mul_y = mul_b[95:64];
        end
        4'd2: begin
            mul_x = mul_b[127:96];
            mul_y = mul_a[95:64];
        end
        4'd3: begin
            mul_x = mul_a[127:96];
            mul_y = mul_b[63:32];
        end   
        4'd4: begin
            mul_x = mul_b[127:96];
            mul_y = mul_a[63:32];
        end    
        4'd5: begin
            mul_x = mul_a[95:64];
            mul_y = mul_b[95:64];
        end 
        4'd6: begin
            mul_x = mul_a[127:96];
            mul_y = mul_b[31:0];
        end    
        4'd7: begin
            mul_x = mul_a[31:0];
            mul_y = mul_b[127:96];
        end 
        4'd8: begin
            mul_x = mul_a[95:64];
            mul_y = mul_b[63:32];
        end 
        4'd9: begin
            mul_x = mul_b[95:64];
            mul_y = mul_a[63:32];
        end
        4'd10: begin
            mul_x = mul_a[95:64];
            mul_y = mul_b[31:0];
        end
        4'd11: begin
            mul_x = mul_b[95:64];
            mul_y = mul_a[31:0];
        end
        4'd12: begin
            mul_x = mul_a[63:32];
            mul_y = mul_b[63:32];
        end
        4'd13: begin
            mul_x = mul_a[63:32];
            mul_y = mul_b[31:0];
        end
        4'd14: begin
            mul_x = mul_b[63:32];
            mul_y = mul_a[31:0];
        end
        4'd15: begin
            mul_x = mul_b[31:0];
            mul_y = mul_a[31:0];
        end
        default: begin
            mul_x = 32'd0;
            mul_y = 32'd0;
        end
        endcase
        end
        else begin
            mul_x = 32'd0;
            mul_y = 32'd0; 
        end
    end
        
    mult mul32(.in0(mul_x), .in1(mul_y), .res(mul_result)); 
    assign cnt = {current_state, cnt_reg}; 
    assign out_chunk = out_chunk_reg; 
    
endmodule
