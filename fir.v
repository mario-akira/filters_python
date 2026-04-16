 module fir_decimator #(
    parameter WIDTH = 16,
    parameter TAPS  = 9
)(
    input clk,
    input rst,

    input signed [WIDTH-1:0] x_in,
    input valid_in,

    input decim_en,   // <<< NOVO

    output reg signed [WIDTH-1:0] y_out,
    output reg valid_out
);

    // ============================
    // Coeficientes
    // ============================
    reg signed [WIDTH-1:0] h [0:TAPS-1];

    initial begin
       	h[0] = 16'd6767;
	h[1] = 16'd21318;
	h[2] = 16'd59508;
	h[3] = 16'd101171;
	h[4] = 16'd119195;
	h[5] = 16'd101171;
	h[6] = 16'd59508;
	h[7] = 16'd21318;
	h[8] = 16'd6767; 
    end

    // ============================
    // Delay line
    // ============================
    reg signed [WIDTH-1:0] x [0:TAPS-1];
    integer i;

    always @(posedge clk) begin
        if (rst) begin
            for (i = 0; i < TAPS; i = i + 1)
                x[i] <= 0;
        end else if (valid_in) begin
            x[0] <= x_in;
            for (i = 1; i < TAPS; i = i + 1)
                x[i] <= x[i-1];
        end
    end

    // ============================
    // MAC
    // ============================
    reg signed [31:0] acc;

    always @(*) begin
        acc = 0;
        for (i = 0; i < TAPS; i = i + 1)
            acc = acc + x[i] * h[i];
    end

    // ============================
    // Saída com decimação externa
    // ============================
    always @(posedge clk) begin
        if (rst) begin
            y_out <= 0;
            valid_out <= 0;
        end else begin
            valid_out <= 0;

            if (valid_in && decim_en) begin
                y_out <= acc[30:15]; // ajuste Q-format
                valid_out <= 1;
            end
        end
    end

endmodule
