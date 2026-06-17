`timescale 1ns / 1ps


module tb_sequence_timer;
    logic clk, tb_sfs, tb_s_reset, tb_enable, tb_ce;
    
    sequence_timer #(.base_period(10))dut (
        .clk(clk),
        .sfs(tb_sfs),
        .s_reset(tb_s_reset),
        .enable(tb_enable),
        .ce(tb_ce)
    ); 
    initial begin
        clk = 1'b0;
        forever #5 clk = ~clk;
    end
    initial begin
        tb_s_reset = 1'b1; tb_sfs = 1'b0; tb_enable = 1'b0;
        @(negedge clk); @(negedge clk);
        tb_s_reset = 1'b0; tb_enable = 1'b1;
        #1000;
        tb_sfs = 1'b1;
        #1000;
        $finish;
    end
endmodule
