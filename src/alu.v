`timescale 1ns/1ps

module alu(
    input  wire        clk,
    input  wire        rst_n,          // Active low asynchronous reset
    input  wire [1:0]  op_sel,         // 00=ADD, 01=SUB, 10=MUL, 11=PASS B
    input  wire [15:0] a_in,
    input  wire [15:0] b_in,
    input  wire        a_valid_in,
    output wire [31:0] result_out,
    output wire        data_valid_out
);

    localparam OP_ADD  = 2'b00;
    localparam OP_SUB  = 2'b01;
    localparam OP_MUL  = 2'b10;
    localparam OP_PASS = 2'b11;

    
    integer i;
    reg [17:0] pipe_a [0:3]; 
    reg [17:0] pipe_b [0:3];
    reg [1:0]  pipe_op [0:5];
    reg        pipe_v  [0:5];
    reg [47:0] mult_res_s3;
    reg [31:0] alu_result_s4;
    reg [31:0] final_out_s5;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (i = 0; i <= 3; i = i + 1) begin
                pipe_a[i] <= 18'd0;
                pipe_b[i] <= 18'd0;
            end
            for (i = 0; i <= 5; i = i + 1) begin
                pipe_op[i] <= OP_ADD;
                pipe_v[i]  <= 1'b0;
            end
            mult_res_s3   <= 48'd0;
            alu_result_s4 <= 32'd0;
            final_out_s5  <= 32'd0;
        end 
        else begin
            pipe_a[0]  <= {2'b00, a_in};
            pipe_b[0]  <= {2'b00, b_in};
            pipe_op[0] <= op_sel;
            pipe_v[0]  <= a_valid_in;

            for (i = 1; i <= 3; i = i + 1) begin
                pipe_a[i] <= pipe_a[i-1];
                pipe_b[i] <= pipe_b[i-1];
            end

            for (i = 1; i <= 5; i = i + 1) begin
                pipe_op[i] <= pipe_op[i-1];
                pipe_v[i]  <= pipe_v[i-1];
            end

            mult_res_s3 <= $unsigned(pipe_a[2]) * $unsigned(pipe_b[2]);

            case (pipe_op[3])
                OP_MUL: begin
                    alu_result_s4 <= mult_res_s3[31:0];
                end
                OP_ADD: begin
                    alu_result_s4 <= {14'd0, pipe_a[3]} + {14'd0, pipe_b[3]};
                end
                OP_SUB: begin
                    alu_result_s4 <= {14'd0, pipe_a[3]} - {14'd0, pipe_b[3]};
                end
                OP_PASS: begin
                    alu_result_s4 <= {14'd0, pipe_b[3]};
                end
                default: alu_result_s4 <= 32'd0;
            endcase

            final_out_s5 <= alu_result_s4;
        end
    end

    assign result_out     = final_out_s5;
    assign data_valid_out = pipe_v[5];

endmodule
