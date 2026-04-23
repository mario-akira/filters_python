
module fir_polyphase (
    input clk,
    input rst,
    input signed [15:0] x_in,
    input valid_in,
    output reg signed [15:0] y_out,
    output reg valid_out
);

reg signed [15:0] x [0:24];
integer i;

// Fase 0
reg signed [15:0] h0[0:24];
initial begin
    h0[0] = 16'h-18117953;
    h0[1] = 16'h26727404;
    h0[2] = 16'h-45694558;
    h0[3] = 16'h62640834;
    h0[4] = 16'h-94041856;
    h0[5] = 16'h135435125;
    h0[6] = 16'h-166136573;
    h0[7] = 16'h226215925;
    h0[8] = 16'h-268182405;
    h0[9] = 16'h267136682;
    h0[10] = 16'h-307357321;
    h0[11] = 16'h318968748;
    h0[12] = 16'h-291508217;
    h0[13] = 16'h302769753;
    h0[14] = 16'h-267961914;
    h0[15] = 16'h219471371;
    h0[16] = 16'h-211682204;
    h0[17] = 16'h156891117;
    h0[18] = 16'h-100919025;
    h0[19] = 16'h79861040;
    h0[20] = 16'h-47257576;
    h0[21] = 16'h27901906;
    h0[22] = 16'h-19294964;
    h0[23] = 16'h5274022;
    h0[24] = 16'h371016;
end

// Fase 1
reg signed [15:0] h1[0:24];
initial begin
    h1[0] = 16'h371016;
    h1[1] = 16'h5274022;
    h1[2] = 16'h-19294964;
    h1[3] = 16'h27901906;
    h1[4] = 16'h-47257576;
    h1[5] = 16'h79861040;
    h1[6] = 16'h-100919025;
    h1[7] = 16'h156891117;
    h1[8] = 16'h-211682204;
    h1[9] = 16'h219471371;
    h1[10] = 16'h-267961914;
    h1[11] = 16'h302769753;
    h1[12] = 16'h-291508217;
    h1[13] = 16'h318968748;
    h1[14] = 16'h-307357321;
    h1[15] = 16'h267136682;
    h1[16] = 16'h-268182405;
    h1[17] = 16'h226215925;
    h1[18] = 16'h-166136573;
    h1[19] = 16'h135435125;
    h1[20] = 16'h-94041856;
    h1[21] = 16'h62640834;
    h1[22] = 16'h-45694558;
    h1[23] = 16'h26727404;
    h1[24] = 16'h-18117953;
end

// Fase 2
reg signed [15:0] h2[0:24];
initial begin
    h2[0] = 16'h20427365;
    h2[1] = 16'h-23938440;
    h2[2] = 16'h22861195;
    h2[3] = 16'h-32082414;
    h2[4] = 16'h37366327;
    h2[5] = 16'h-29176635;
    h2[6] = 16'h36441978;
    h2[7] = 16'h-7868812;
    h2[8] = 16'h-37774237;
    h2[9] = 16'h37230616;
    h2[10] = 16'h-77019876;
    h2[11] = 16'h122301179;
    h2[12] = 16'h-121574315;
    h2[13] = 16'h162981125;
    h2[14] = 16'h-179766765;
    h2[15] = 16'h159325671;
    h2[16] = 16'h-182284758;
    h2[17] = 16'h172479918;
    h2[18] = 16'h-132387512;
    h2[19] = 16'h114290278;
    h2[20] = 16'h-84238963;
    h2[21] = 16'h57953677;
    h2[22] = 16'h-45720900;
    h2[23] = 16'h31685112;
end

// Fase 3
reg signed [15:0] h3[0:24];
initial begin
    h3[0] = 16'h31685112;
    h3[1] = 16'h-45720900;
    h3[2] = 16'h57953677;
    h3[3] = 16'h-84238963;
    h3[4] = 16'h114290278;
    h3[5] = 16'h-132387512;
    h3[6] = 16'h172479918;
    h3[7] = 16'h-182284758;
    h3[8] = 16'h159325671;
    h3[9] = 16'h-179766765;
    h3[10] = 16'h162981125;
    h3[11] = 16'h-121574315;
    h3[12] = 16'h122301179;
    h3[13] = 16'h-77019876;
    h3[14] = 16'h37230616;
    h3[15] = 16'h-37774237;
    h3[16] = 16'h-7868812;
    h3[17] = 16'h36441978;
    h3[18] = 16'h-29176635;
    h3[19] = 16'h37366327;
    h3[20] = 16'h-32082414;
    h3[21] = 16'h22861195;
    h3[22] = 16'h-23938440;
    h3[23] = 16'h20427365;
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
    acc = acc + x[18] * h0[18];
    acc = acc + x[19] * h0[19];
    acc = acc + x[20] * h0[20];
    acc = acc + x[21] * h0[21];
    acc = acc + x[22] * h0[22];
    acc = acc + x[23] * h0[23];
    acc = acc + x[24] * h0[24];
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
    acc = acc + x[18] * h1[18];
    acc = acc + x[19] * h1[19];
    acc = acc + x[20] * h1[20];
    acc = acc + x[21] * h1[21];
    acc = acc + x[22] * h1[22];
    acc = acc + x[23] * h1[23];
    acc = acc + x[24] * h1[24];
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
    acc = acc + x[18] * h2[18];
    acc = acc + x[19] * h2[19];
    acc = acc + x[20] * h2[20];
    acc = acc + x[21] * h2[21];
    acc = acc + x[22] * h2[22];
    acc = acc + x[23] * h2[23];
    acc = acc + x[24] * h2[24];
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
    acc = acc + x[18] * h3[18];
    acc = acc + x[19] * h3[19];
    acc = acc + x[20] * h3[20];
    acc = acc + x[21] * h3[21];
    acc = acc + x[22] * h3[22];
    acc = acc + x[23] * h3[23];
    acc = acc + x[24] * h3[24];
end

    endcase
end

always @(posedge clk) begin
    if (rst) begin
        valid_out <= 0;
        y_out <= 0;
    end else if (valid_in) begin

        x[0] <= x_in;
        for (i = 1; i < 25; i = i + 1)
            x[i] <= x[i-1];

        if (phase == 3) begin
            y_out <= acc[30:15];
            valid_out <= 1;
        end else
            valid_out <= 0;
    end
end

endmodule
