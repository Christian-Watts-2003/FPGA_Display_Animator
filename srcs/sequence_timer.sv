`timescale 1ns / 1ps

module sequence_timer #(parameter base_period = 1000000)(
    input clk,
    input sfs,
    input s_reset,
    input enable,
    output logic ce
    );
    //registers
    logic[28:0] counter;
    logic period_double;
    //other logic
    logic internal_reset, strike;
    
    assign strike = (counter >= base_period);
    assign ce = sfs ? (strike) : (strike & period_double);
    always_ff @ (posedge clk) begin
        if(s_reset) begin
            counter <= 0;
            period_double <= 0;
        end else if (enable) begin
            counter <= counter + 1;
            if(strike) begin
                counter <= 0;
                period_double <= period_double + 1;
            end
        end
    end
    
endmodule
