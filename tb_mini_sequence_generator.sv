`timescale 1ns/1ps

module tb_animation_sequences;

    logic clk, rst;
    logic ce;
    logic load_user_word;
    logic [1:0] ssl;
    logic [7:0] user_input;
    logic [15:0] current_word;

    animation_sequences dut (
        .clk(clk),
        .rst(rst),
        .ce(ce),
        .ssl(ssl),
        .load_user_word(load_user_word),
        .user_input(user_input),
        .current_word(current_word)
    );

    always #5 clk = ~clk;

    logic div;

always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
        div <= 0;
        ce  <= 0;
    end else begin
        div <= ~div;
        ce  <= div;
    end
end


    initial begin
        clk = 0;
        rst = 1;
        ssl = 0;
        load_user_word = 0;
        user_input = 8'b00_01_10_11;

        #20; rst = 0;

        ssl = 0;
        #200;

        ssl = 1;
        #200;

        ssl = 2;
        #200;

        load_user_word = 1;
        #10 load_user_word = 0;

        ssl = 3;
        #200;

        $finish;
    end

endmodule
