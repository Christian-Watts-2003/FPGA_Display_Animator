`timescale 1ns / 1ps
//new addition: synchronous reset is triggered during idle

module fsm_top 
    #(
      parameter base_seq_period = 100000000,
      parameter base_ref_delay = 150000 
     ) 
    (
    input logic[12:0] sw,
    input logic clk,
    output logic[3:0] an,
    output logic[6:0] seg
    );
    
    //internal signals from switch inputs (more readable names)
    logic sfs, rfs, on_off;
    logic[1:0] ssl;
    logic[7:0] user_word;
    
    assign rfs = sw[12];
    assign sfs = sw[11];
    assign on_off = sw[10];
    assign ssl = sw[9:8];
    assign user_word = sw[7:0];
   
    //other internal signals
    logic ce;
    logic[15:0] seq_bank_out;
    //states
    typedef enum logic[1:0] {
        IDLE,
        LOAD,
        DISPLAY
    } state_t;
    state_t next_state, current_state;
    
    //sequential state change logic
    always_ff @ (posedge clk) begin
        current_state <= next_state;
    end
    
    //flags
    logic load_word,
          display_enable,
          s_reset,
          timer_enable;
    
    //sequence timer
    sequence_timer #(.base_period(base_seq_period)) seq_timer (
        .clk(clk),
        .sfs(sfs),
        .s_reset(s_reset),
        .enable(timer_enable),
        .ce(ce)
    );
    //sequence generator
    animation_sequences seq_bank (
        .clk(clk),
        .rst(s_reset), //probably not an issue?
        .ce(ce),
        .load_user_word(load_word),
        .ssl(ssl),
        .user_input(user_word),
        .current_word(seq_bank_out)
    );
    //display driver
    sseg_driver #(.base_ref_delay(base_ref_delay)) display_driver(
        .clk(clk),
        .s_reset(s_reset),
        .hex0(seq_bank_out[3:0]),
        .hex1(seq_bank_out[7:4]),
        .hex2(seq_bank_out[11:8]),
        .hex3(seq_bank_out[15:12]),
        .rfs(rfs),
        .an(an),
        .seg(seg)
    );
    //combinational FSM logic / next state determination
    always_comb begin
        //defaults
        next_state = current_state;
        s_reset = 1'b0;
        load_word = 1'b0;
        display_enable = 1'b0;
        timer_enable = 1'b0;
        unique case(current_state)
            IDLE: begin
                s_reset = 1'b1;
                if(on_off) begin
                    next_state = LOAD;
                end
            end
            LOAD: begin
                load_word = 1'b1;
                if(on_off) begin
                    next_state = DISPLAY;
                end else begin
                    next_state = IDLE;
                end
            end
            DISPLAY: begin
                display_enable = 1'b1;
                timer_enable = 1'b1;
                if(~on_off) begin
                    next_state = IDLE;
                end
            end
            default: begin //should catch the reset?
                next_state = IDLE;
            end
        endcase
    end
endmodule
