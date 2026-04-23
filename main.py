import numpy as np
from scipy import signal
import matplotlib.pyplot as plt

class CICFIRConfig:
    def __init__(self, R=10, N=3, M=4, taps=64):
        self.R = R      # decimação do CIC
        self.N = N      # estágios do CIC
        self.M = M      # decimação do FIR
        self.taps = taps  # total taps FIR (múltiplo de M)

def cic_response(f, R, N):
    H = (R * np.sinc(f * R) / np.sinc(f))**N
    H /= np.max(H)
    return H

def design_fir_compensator(cfg, f):
    Hcic = cic_response(f, cfg.R, cfg.N)

    # banda útil (anti-alias)
    f_pass = 0.4 * (0.5 / cfg.M)

    H_desired = np.zeros_like(f)

    mask = f <= f_pass
    H_desired[mask] = 1 / Hcic[mask]

    # FIR
    fir = signal.firwin2(cfg.taps, f*2, H_desired)

    return fir, Hcic, H_desired, f_pass

def polyphase_decompose(h, M):
    phases = []
    for k in range(M):
        phases.append(h[k::M])
    return phases

def simulate_system(f, fir, Hcic):
    w, h = signal.freqz(fir, worN=len(f))

    H_total = np.abs(Hcic * np.abs(h))

    return h, H_total

def plot_response(f, Hcic, h, H_total, f_pass):
    eps = 1e-12

    plt.figure(figsize=(10,6))
    plt.plot(f, 20*np.log10(np.abs(Hcic)+eps), label="CIC")
    plt.plot(f, 20*np.log10(np.abs(h)+eps), label="FIR")
    plt.plot(f, 20*np.log10(H_total+eps), label="CIC+FIR")

    plt.axvline(f_pass, linestyle="--", label="f_pass")

    plt.legend()
    plt.grid()
    plt.title("Resposta do sistema")
    plt.xlabel("Frequência normalizada")
    plt.ylabel("dB")
    plt.show()

def quantize(phases, bits=16):
    scale = 2**(bits-1)
    return [np.round(p * scale).astype(int) for p in phases]

def generate_verilog(phases, M, filename="fir_poly.v"):
    taps = len(phases[0])
    WIDTH = 16

    with open(filename, "w") as f:

        f.write(f"""
module fir_polyphase (
    input clk,
    input rst,
    input signed [{WIDTH-1}:0] x_in,
    input valid_in,
    output reg signed [{WIDTH-1}:0] y_out,
    output reg valid_out
);

reg signed [{WIDTH-1}:0] x [0:{taps-1}];
integer i;
""")

        # coeficientes
        for p, phase in enumerate(phases):
            f.write(f"\n// Fase {p}\n")
            f.write(f"reg signed [{WIDTH-1}:0] h{p}[0:{taps-1}];\n")
            f.write("initial begin\n")
            for i, c in enumerate(phase):
                f.write(f"    h{p}[{i}] = 16'h{c};\n")
            f.write("end\n")

        f.write(f"""
reg [{int(np.ceil(np.log2(M)))-1}:0] phase;

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
""")

        for p in range(M):
            f.write(f"{p}: begin\n")
            for i in range(taps):
                f.write(f"    acc = acc + x[{i}] * h{p}[{i}];\n")
            f.write("end\n")

        f.write("""
    endcase
end
""")

        f.write(f"""
always @(posedge clk) begin
    if (rst) begin
        valid_out <= 0;
        y_out <= 0;
    end else if (valid_in) begin

        x[0] <= x_in;
        for (i = 1; i < {taps}; i = i + 1)
            x[i] <= x[i-1];

        if (phase == {M-1}) begin
            y_out <= acc[30:15];
            valid_out <= 1;
        end else
            valid_out <= 0;
    end
end

endmodule
""")

    print(f"Verilog gerado: {filename}")
    
if __name__ == "__main__":

    cfg = CICFIRConfig(R=25, N=3, M=4, taps=98)

    f = np.linspace(0, 0.5, 2048)

    fir, Hcic, H_desired, f_pass = design_fir_compensator(cfg, f)

    h, H_total = simulate_system(f, fir, Hcic)

    plot_response(f, Hcic, h, H_total, f_pass)

    phases = polyphase_decompose(fir, cfg.M)

    phases_q = quantize(phases)

    #generate_verilog_polyphase(phases_q, M=4)
    generate_verilog(phases_q, cfg.M)
