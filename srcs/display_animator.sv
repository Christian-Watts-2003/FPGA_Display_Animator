`timescale 1ns / 1ps

//wrapper for fsm_top for synthesis etc

module display_animator(
    input logic[12:0] sw,
    input logic clk,
    output logic[3:0] an,
    output logic[6:0] seg
    );
    fsm_top #(.base_seq_period(5000000), .base_ref_delay(83000)) main (
        .sw(sw),
        .clk(clk),
        .an(an),
        .seg(seg)
    );
endmodule
