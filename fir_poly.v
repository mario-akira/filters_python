
module fir_polyphase (
    input clk,
    input rst,
    input signed [15:0] x_in,
    input valid_in,
    output reg signed [15:0] y_out,
    output reg valid_out
);

reg signed [15:0] x [0:17];
integer i;

// Fase 0
reg signed [15:0] h0[0:17];
initial begin
    h0[0] = 16'h75;
    h0[1] = 16'h109;
    h0[2] = 16'h203;
    h0[3] = 16'h352;
    h0[4] = 16'h543;
    h0[5] = 16'h754;
    h0[6] = 16'h956;
    h0[7] = 16'h1122;
    h0[8] = 16'h1227;
    h0[9] = 16'h1258;
    h0[10] = 16'h1208;
    h0[11] = 16'h1085;
    h0[12] = 16'h908;
    h0[13] = 16'h701;
    h0[14] = 16'h493;
    h0[15] = 16'h310;
    h0[16] = 16'h174;
    h0[17] = 16'h95;
end

// Fase 1
reg signed [15:0] h1[0:17];
initial begin
    h1[0] = 16'h78;
    h1[1] = 16'h127;
    h1[2] = 16'h235;
    h1[3] = 16'h397;
    h1[4] = 16'h595;
    h1[5] = 16'h806;
    h1[6] = 16'h1002;
    h1[7] = 16'h1155;
    h1[8] = 16'h1242;
    h1[9] = 16'h1253;
    h1[10] = 16'h1183;
    h1[11] = 16'h1045;
    h1[12] = 16'h858;
    h1[13] = 16'h648;
    h1[14] = 16'h444;
    h1[15] = 16'h271;
    h1[16] = 16'h148;
    h1[17] = 16'h85;
end

// Fase 2
reg signed [15:0] h2[0:17];
initial begin
    h2[0] = 16'h85;
    h2[1] = 16'h148;
    h2[2] = 16'h271;
    h2[3] = 16'h444;
    h2[4] = 16'h648;
    h2[5] = 16'h858;
    h2[6] = 16'h1045;
    h2[7] = 16'h1183;
    h2[8] = 16'h1253;
    h2[9] = 16'h1242;
    h2[10] = 16'h1155;
    h2[11] = 16'h1002;
    h2[12] = 16'h806;
    h2[13] = 16'h595;
    h2[14] = 16'h397;
    h2[15] = 16'h235;
    h2[16] = 16'h127;
    h2[17] = 16'h78;
end

// Fase 3
reg signed [15:0] h3[0:17];
initial begin
    h3[0] = 16'h95;
    h3[1] = 16'h174;
    h3[2] = 16'h310;
    h3[3] = 16'h493;
    h3[4] = 16'h701;
    h3[5] = 16'h908;
    h3[6] = 16'h1085;
    h3[7] = 16'h1208;
    h3[8] = 16'h1258;
    h3[9] = 16'h1227;
    h3[10] = 16'h1122;
    h3[11] = 16'h956;
    h3[12] = 16'h754;
    h3[13] = 16'h543;
    h3[14] = 16'h352;
    h3[15] = 16'h203;
    h3[16] = 16'h109;
    h3[17] = 16'h75;
end

reg [1:0] phase;

always @(posedge clk) begin
    if (rst)
        phase <= 0;
    else if (valid_in)
        phase <= phase + 1;
end

reg signed [31:0] acc;

always @(*) begin
    acc = 0;
    case(phase)
0: begin
    acc = acc + x[0] * h0[0];
    acc = acc + x[1] * h0[1];
    acc = acc + x[2] * h0[2];
    acc = acc + x[3] * h0[3];
    acc = acc + x[4] * h0[4];
    acc = acc + x[5] * h0[5];
    acc = acc + x[6] * h0[6];
    acc = acc + x[7] * h0[7];
    acc = acc + x[8] * h0[8];
    acc = acc + x[9] * h0[9];
    acc = acc + x[10] * h0[10];
    acc = acc + x[11] * h0[11];
    acc = acc + x[12] * h0[12];
    acc = acc + x[13] * h0[13];
    acc = acc + x[14] * h0[14];
    acc = acc + x[15] * h0[15];
    acc = acc + x[16] * h0[16];
    acc = acc + x[17] * h0[17];
end
1: begin
    acc = acc + x[0] * h1[0];
    acc = acc + x[1] * h1[1];
    acc = acc + x[2] * h1[2];
    acc = acc + x[3] * h1[3];
    acc = acc + x[4] * h1[4];
    acc = acc + x[5] * h1[5];
    acc = acc + x[6] * h1[6];
    acc = acc + x[7] * h1[7];
    acc = acc + x[8] * h1[8];
    acc = acc + x[9] * h1[9];
    acc = acc + x[10] * h1[10];
    acc = acc + x[11] * h1[11];
    acc = acc + x[12] * h1[12];
    acc = acc + x[13] * h1[13];
    acc = acc + x[14] * h1[14];
    acc = acc + x[15] * h1[15];
    acc = acc + x[16] * h1[16];
    acc = acc + x[17] * h1[17];
end
2: begin
    acc = acc + x[0] * h2[0];
    acc = acc + x[1] * h2[1];
    acc = acc + x[2] * h2[2];
    acc = acc + x[3] * h2[3];
    acc = acc + x[4] * h2[4];
    acc = acc + x[5] * h2[5];
    acc = acc + x[6] * h2[6];
    acc = acc + x[7] * h2[7];
    acc = acc + x[8] * h2[8];
    acc = acc + x[9] * h2[9];
    acc = acc + x[10] * h2[10];
    acc = acc + x[11] * h2[11];
    acc = acc + x[12] * h2[12];
    acc = acc + x[13] * h2[13];
    acc = acc + x[14] * h2[14];
    acc = acc + x[15] * h2[15];
    acc = acc + x[16] * h2[16];
    acc = acc + x[17] * h2[17];
end
3: begin
    acc = acc + x[0] * h3[0];
    acc = acc + x[1] * h3[1];
    acc = acc + x[2] * h3[2];
    acc = acc + x[3] * h3[3];
    acc = acc + x[4] * h3[4];
    acc = acc + x[5] * h3[5];
    acc = acc + x[6] * h3[6];
    acc = acc + x[7] * h3[7];
    acc = acc + x[8] * h3[8];
    acc = acc + x[9] * h3[9];
    acc = acc + x[10] * h3[10];
    acc = acc + x[11] * h3[11];
    acc = acc + x[12] * h3[12];
    acc = acc + x[13] * h3[13];
    acc = acc + x[14] * h3[14];
    acc = acc + x[15] * h3[15];
    acc = acc + x[16] * h3[16];
    acc = acc + x[17] * h3[17];
end

    endcase
end

always @(posedge clk) begin
    if (rst) begin
        valid_out <= 0;
        y_out <= 0;
    end else if (valid_in) begin

        x[0] <= x_in;
        for (i = 1; i < 18; i = i + 1)
            x[i] <= x[i-1];

        if (phase == 3) begin
            y_out <= acc[30:15];
            valid_out <= 1;
        end else
            valid_out <= 0;
    end
end

endmodule

