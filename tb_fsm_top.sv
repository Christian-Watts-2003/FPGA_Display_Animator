`timescale 1ns / 1ps

module tb_fsm_top;

    logic [12:0] tb_sw;
    logic clk;
    logic [3:0] tb_an;
    logic [6:0] tb_seg;
    //change the parameters in display_animator.sv to something much
    //smaller for simulation purposes
    //base_ref_delay needs to be about 1/60 base_seq_period
    //both values are in # of clock cycles
    //and the clock is set to 100MHZ
    display_animator dut (
        .sw(tb_sw),
        .clk(clk),
        .an(tb_an),
        .seg(tb_seg)
    );

    initial begin
        clk = 1'b0;
        forever #5 clk = ~clk;
    end


    initial begin
        //slow refresh, slow sequence, off, sequence 0, user word 0000

        tb_sw = 13'b0000000000000;
        @(negedge clk); @(negedge clk);
        
        tb_sw[10] = 1'b1;
        #100000
        $finish;
    end
endmodule