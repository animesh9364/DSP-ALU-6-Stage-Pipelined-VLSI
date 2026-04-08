`timescale 1ns/1ps

module tb_alu16;
    reg clk;
    reg rst_n;
    reg [1:0] op_sel;
    reg [15:0] a_in;
    reg [15:0] b_in;
    reg a_valid_in;
    wire [31:0] result_out;
    wire data_valid_out;

    alu(
        .clk(clk),
        .rst_n(rst_n),
        .op_sel(op_sel),
        .a_in(a_in),
        .b_in(b_in),
        .a_valid_in(a_valid_in),
        .result_out(result_out),
        .data_valid_out(data_valid_out)
    );

    always #5 clk = ~clk;

    localparam OP_ADD  = 2'b00;
    localparam OP_SUB  = 2'b01;
    localparam OP_MUL  = 2'b10;
    localparam OP_PASS = 2'b11;

    initial begin
        clk = 0;
        rst_n = 0;
        op_sel = 0;
        a_in = 0;
        b_in = 0;
        a_valid_in = 0;

        // Apply Reset
        $display("--- Simulation Start ---");
        #20 rst_n = 1;

        @(posedge clk); 
        a_in <= 16'd100; b_in <= 16'd50; op_sel <= OP_ADD; a_valid_in <= 1;
        $display("[Time %0t] INPUT  : ADD 100 + 50", $time);

        @(posedge clk);
        a_in <= 16'd200; b_in <= 16'd50; op_sel <= OP_SUB; a_valid_in <= 1;
        $display("[Time %0t] INPUT  : SUB 200 - 50", $time);

        @(posedge clk);
        a_in <= 16'd10;  b_in <= 16'd10; op_sel <= OP_MUL; a_valid_in <= 1;
        $display("[Time %0t] INPUT  : MUL 10 * 10", $time);

        @(posedge clk);
        a_in <= 16'd0;   b_in <= 16'd1234; op_sel <= OP_PASS; a_valid_in <= 1;
        $display("[Time %0t] INPUT  : PASS 1234", $time);

        @(posedge clk);
        a_valid_in <= 0;
        a_in <= 0; b_in <= 0;

        #100;
        $display("--- Simulation End ---");
        $finish;
    end

    always @(posedge clk) begin
        if (data_valid_out) begin
            $display("[Time %0t] OUTPUT : Result = %0d", $time, result_out);
        end
    end

endmodule