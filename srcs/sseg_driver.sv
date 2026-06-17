`timescale 1ns / 1ps

module sseg_driver #(parameter base_ref_delay = 150000)(
  input logic clk, rfs, s_reset,
  input logic [3:0] hex0, hex1, hex2, hex3,
  output logic [3:0] an,
  output logic [6:0] seg
);

  logic [3:0] current_hex;

  seven_seg_anode_driver #(.base_ref_delay(base_ref_delay))anode_driver (
    .clk(clk),
    .reset(s_reset),
    .rfs(rfs),
    .an(an)
  );
  
  hex7seg seg_driver (
    .hex(current_hex),
    .seg(seg)
  );
  
  always_comb begin
    current_hex = '0;
    case (an)
      4'b1110:  begin
                  current_hex = hex0;
                end
      4'b1101:  begin
                  current_hex = hex1;
                end
      4'b1011:  begin
                  current_hex = hex2;
                end
      4'b0111:  begin
                  current_hex = hex3;
                end
      default:  begin
                  current_hex = 4'd0;
                end
    endcase
  end

endmodule
