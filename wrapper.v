`timescale 1ns/1ps

module alu_fpga_wrapper(
    input         CLK100MHZ,
    input  [15:0] SW,          
    input         BTNC,         
    input         BTNU,         // Load A (Up)
    input         BTND,         // Load B (Down)
    input         BTNL,         // Next Op (Left)
    input         BTNR,         // Calculate (Right)
    output [15:0] LED,          
    output [7:0]  AN,           
    output        CA, CB, CC, CD, CE, CF, CG, DP
    );

    wire clk = CLK100MHZ;
    wire rst_n = ~BTNC;

    reg [19:0] db_cnt;
    always @(posedge clk) db_cnt <= db_cnt + 1;
    wire db_tick = (db_cnt == 0);

    reg btn_u_clean, btn_d_clean, btn_l_clean, btn_r_clean;
    reg btn_u_prev, btn_d_prev, btn_l_prev, btn_r_prev;

    always @(posedge clk) begin
        if (db_tick) begin
            btn_u_clean <= BTNU;
            btn_d_clean <= BTND;
            btn_l_clean <= BTNL;
            btn_r_clean <= BTNR;
        end
    end

    always @(posedge clk) begin
        btn_u_prev <= btn_u_clean;
        btn_d_prev <= btn_d_clean;
        btn_l_prev <= btn_l_clean;
        btn_r_prev <= btn_r_clean;
    end

    wire load_a_pressed  = btn_u_clean & ~btn_u_prev;
    wire load_b_pressed  = btn_d_clean & ~btn_d_prev;
    wire next_op_pressed = btn_l_clean & ~btn_l_prev;
    wire calc_pressed    = btn_r_clean & ~btn_r_prev;

    reg [15:0] reg_a;
    reg [15:0] reg_b;
    reg [1:0]  reg_op;
    reg        show_result_mode; 

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            reg_a  <= 16'd0;
            reg_b  <= 16'd0;
            reg_op <= 2'b00;
            show_result_mode <= 1'b0;
        end else begin
            if (load_a_pressed) begin
                reg_a <= SW;
                show_result_mode <= 1'b0;
            end
            if (load_b_pressed) begin
                reg_b <= SW;
                show_result_mode <= 1'b0;
            end
            if (next_op_pressed) begin
                reg_op <= reg_op + 1;
            end
            if (calc_pressed) begin
                show_result_mode <= 1'b1;
            end
        end
    end

    wire [31:0] alu_result;
    wire alu_valid_out;

    alu(
        .clk(clk),
        .rst_n(rst_n),
        .op_sel(reg_op),
        .a_in(reg_a),
        .b_in(reg_b),
        .a_valid_in(calc_pressed), 
        .result_out(alu_result),
        .data_valid_out(alu_valid_out)
    );

    assign LED[1:0]  = reg_op; 
    assign LED[15:2] = 14'd0; 

    reg [31:0] display_data;
    always @(*) begin
        if (show_result_mode)
            display_data = alu_result;           
        else
            display_data = {reg_a, reg_b};      
    end
    
    sev_seg_driver u_disp (
        .clk(clk),
        .data_in(display_data),
        .AN(AN),
        .seg({CA, CB, CC, CD, CE, CF, CG, DP})
    );

endmodule

module sev_seg_driver(
    input wire clk,
    input wire [31:0] data_in,
    output reg [7:0] AN,
    output reg [7:0] seg
    );

    reg [19:0] refresh_counter;
    always @(posedge clk) refresh_counter <= refresh_counter + 1;

    wire [2:0] digit_sel = refresh_counter[19:17];
    reg [3:0] hex_digit;

    always @(*) begin
        AN = 8'b11111111; 
        AN[digit_sel] = 1'b0; 

        case(digit_sel)
            3'd0: hex_digit = data_in[3:0];  
            3'd1: hex_digit = data_in[7:4];
            3'd2: hex_digit = data_in[11:8];
            3'd3: hex_digit = data_in[15:12];
            3'd4: hex_digit = data_in[19:16];
            3'd5: hex_digit = data_in[23:20];
            3'd6: hex_digit = data_in[27:24];
            3'd7: hex_digit = data_in[31:28]; 
        endcase
    end

    // 0 = ON, 1 = OFF
    always @(*) begin
        case(hex_digit)
            4'h0: seg = 8'b00000011; 
            4'h1: seg = 8'b10011111; 
            4'h2: seg = 8'b00100101;
            4'h3: seg = 8'b00001101;
            4'h4: seg = 8'b10011001;
            4'h5: seg = 8'b01001001;
            4'h6: seg = 8'b01000001;
            4'h7: seg = 8'b00011111;
            4'h8: seg = 8'b00000001;
            4'h9: seg = 8'b00001001;
            4'hA: seg = 8'b00010001;
            4'hB: seg = 8'b11000001;
            4'hC: seg = 8'b01100011;
            4'hD: seg = 8'b10000101;
            4'hE: seg = 8'b01100001;
            4'hF: seg = 8'b01110001;
            default: seg = 8'b11111111;
        endcase
    end
endmodule