import numpy as np
from scipy import signal
import matplotlib.pyplot as plt

# =========================
# Parâmetros
# =========================
fs = 1.0        # normalizado (Nyquist = 0.5)
R  = 25         # decimação do CIC
N  = 3          # estágios do CIC
M  = 4          # decimação do FIR

num_taps = 9   # FIR (ímpar!)

# =========================
# Eixo de frequência
# =========================
f = np.linspace(0, 0.5, 1024)

# =========================
# Resposta do CIC (robusta)
# =========================
H_cic = (R * np.sinc(f * R) / np.sinc(f))**N

# normaliza
H_cic = H_cic / np.max(H_cic)

# =========================
# Banda útil (anti-aliasing)
# =========================
f_pass = 0.4 * (0.5 / M)   # margem de segurança

# =========================
# Resposta desejada
# =========================
H_desired = np.zeros_like(f)

# dentro da banda → compensa CIC
mask = f <= f_pass
H_desired[mask] = 1 / H_cic[mask]

# fora da banda → zero (anti-alias)
H_desired[~mask] = 0

# =========================
# Projeto do FIR
# =========================
fir_coeffs = signal.firwin2(num_taps, f*2, H_desired)

# =========================
# Visualização
# =========================
w, h = signal.freqz(fir_coeffs, worN=len(f))

plt.plot(w/np.pi*0.5, 20*np.log10(np.abs(h)), label="FIR")
plt.plot(f, 20*np.log10(np.abs(H_cic)), label="CIC")
plt.plot(f, 20*np.log10(np.abs(H_cic * np.abs(h))), label="CIC + FIR")

plt.axvline(f_pass, linestyle='--', label="f_pass")

plt.legend()
plt.grid()
plt.title("Compensação CIC + Decimação FIR")
plt.xlabel("Frequência normalizada")
plt.ylabel("dB")
plt.show()

# =========================
# Export para FPGA
# =========================
scale = 2**15
coeffs_fixed = np.round(fir_coeffs * scale).astype(int)

for i, c in enumerate(coeffs_fixed):
    print(f"h[{i}] = 16'd{c};")
