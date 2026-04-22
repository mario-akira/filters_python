module fir_1_compat (
    input clk,
    input reset,

    input clk_enable,          // equivalente ao valid_in
    input signed [15:0] filter_in,

    output reg signed [15:0] filter_out,
    output reg filter_out_valid
);

    // ============================
    // Sinal interno
    // ============================
    wire signed [15:0] y_internal;
    wire valid_internal;

    // ============================
    // Gerador de decimação
    // (substitui lógica polifásica)
    // ============================
    reg [1:0] decim_cnt;

    wire decim_en = (decim_cnt == 2'd3); // decim=4

    always @(posedge clk) begin
        if (reset) begin
            decim_cnt <= 0;
        end else if (clk_enable) begin
            if (decim_cnt == 3)
                decim_cnt <= 0;
            else
                decim_cnt <= decim_cnt + 1;
        end
    end

    // ============================
    // Instância do seu FIR
    // ============================
    fir_decimator fir_inst (
        .clk(clk),
        .rst(reset),
        .x_in(filter_in),
        .valid_in(clk_enable),
        .decim_en(decim_en),
        .y_out(y_internal),
        .valid_out(valid_internal)
    );

    // ============================
    // Saída compatível
    // ============================
    always @(posedge clk) begin
        if (reset) begin
            filter_out <= 0;
            filter_out_valid <= 0;
        end else begin
            filter_out_valid <= valid_internal;

            if (valid_internal)
                filter_out <= y_internal;
        end
    end

endmodule
