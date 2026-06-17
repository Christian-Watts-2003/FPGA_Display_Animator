module animation_sequences (
    input  logic         clk, rst, ce, load_user_word,
    input  logic [1:0]   ssl,
    input  logic [7:0]   user_input,
    output logic [15:0]  current_word
);

    logic [1:0] word_idx;
    always_ff @(posedge clk or posedge rst) begin
        if (rst)
            word_idx <= 0;
        else if (ce)
            word_idx <= word_idx + 1;
    end

    function logic [3:0] decoder(input logic [1:0] v);
        case (v)
            2'b00: decoder = 4'hA;
            2'b01: decoder = 4'hB;
            2'b10: decoder = 4'hC;
            2'b11: decoder = 4'hD;
        endcase
    endfunction

    logic [15:0] user_word;

    always_ff @(posedge clk or posedge rst) begin
        if (rst)
            user_word <= 16'h0000;
        else if (load_user_word)
            user_word <= {
                decoder(user_input[7:6]),
                decoder(user_input[5:4]),
                decoder(user_input[3:2]),
                decoder(user_input[1:0])
            };
    end


    // Sequence 0 - SCROLLING 'A'
    localparam logic [15:0] SEQ0 [0:3] = '{
        16'h000A, 16'h00A0, 16'h0A00, 16'hA000
    };

    // Sequence 1 - BLINKING 'B'
    localparam logic [15:0] SEQ1 [0:3] = '{
        16'hBBBB, 16'h0000, 16'hBBBB, 16'h0000
    };

    // Sequence 2 - COUNTING
    localparam logic [15:0] SEQ2 [0:3] = '{
        16'h0000, 16'h1111, 16'h2222, 16'h3333
    };

    // Sequence 3 - USER WORD ROTATION
    logic [15:0] SEQ3 [0:3];

    always_comb begin
        SEQ3[0] = user_word;
        SEQ3[1] = { user_word[11:0], user_word[15:12] };
        SEQ3[2] = { user_word[7:0],  user_word[15:8]  };
        SEQ3[3] = { user_word[3:0],  user_word[15:4]  };
    end

    logic [15:0] selected_sequence [0:3];

    always_comb begin
        case (ssl)
            2'd0: selected_sequence = SEQ0;
            2'd1: selected_sequence = SEQ1;
            2'd2: selected_sequence = SEQ2;
            2'd3: selected_sequence = SEQ3;
            default: selected_sequence = SEQ0;
        endcase
    end

    assign current_word = selected_sequence[word_idx];

endmodule
