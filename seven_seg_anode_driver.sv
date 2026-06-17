`timescale 1ns / 1ps

module seven_seg_anode_driver #(parameter base_ref_delay = 150000) (
  input logic clk, reset, rfs,
  output logic [3:0] an
);
  //timer-related localparams
 
  localparam int N_BITS = $clog2(base_ref_delay) + 1;
  
  logic [1:0] an_count;
  logic timer_tick;
  
  always_ff @(posedge clk or posedge reset) begin
    if (reset) begin
      an_count <= 2'b00;
    end else if (timer_tick) begin
      an_count <= an_count + 1;
    end
  end
  
  //timer logic
  logic [N_BITS-1:0] counter;
  logic strike, period_double;
  assign timer_tick = rfs ? strike : (strike & period_double);
  
  always_ff @(posedge clk or posedge reset) begin
    if (reset) begin
      counter <= '0;
      strike <= 1'b0;
      period_double <= 1'b0;
    end else if (counter == base_ref_delay) begin
      counter <= '0;
      period_double <= period_double + 1;
      strike <= 1'b1;
    end else begin
      counter <= counter + 1;
      strike <= 1'b0;
    end
  end
  
  always_comb begin
    case (an_count)
      2'b00: an = 4'b1110; // digit 0
      2'b01: an = 4'b1101; // digit 1
      2'b10: an = 4'b1011; // digit 2
      2'b11: an = 4'b0111; // digit 3
    endcase
  end

endmodule
