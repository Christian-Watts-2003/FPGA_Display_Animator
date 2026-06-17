module hex7seg #(parameter ACTIVE_LOW = 1)(
  input logic  [3:0] hex,
  output logic [6:0] seg
);
  logic [6:0] patt;
  always_comb begin
    unique case (hex)
      4'h0: patt = 7'b011_1111;
      4'h1: patt = 7'b000_0110;
      4'h2: patt = 7'b101_1011;
      4'h3: patt = 7'b100_1111;
      4'h4: patt = 7'b110_0110;
      4'h5: patt = 7'b110_1101;
      4'h6: patt = 7'b111_1101;
      4'h7: patt = 7'b000_0111;
      4'h8: patt = 7'b111_1111;
      4'h9: patt = 7'b110_1111;
      4'hA: patt = 7'b111_0111;
      4'hB: patt = 7'b111_1100;
      4'hC: patt = 7'b011_1001;
      4'hD: patt = 7'b101_1110;
      4'hE: patt = 7'b111_1001;
      4'hF: patt = 7'b111_0001;
      default: patt = 7'b100_0000; // dash
    endcase
  end
  assign seg = (ACTIVE_LOW) ? ~patt : patt;
endmodule
