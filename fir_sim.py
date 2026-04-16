import numpy as np
from scipy import signal
import matplotlib.pyplot as plt

fs = 100000000      # frequência de amostragem (Hz)
fc = 100000       # cutoff (Hz)

num_taps = 24  # ordem do filtro

# Projeto do FIR
coeffs = signal.firwin(num_taps, fc, fs=fs)

# Plot resposta em frequência
w, h = signal.freqz(coeffs, worN=8000)

plt.plot(w * fs / (2*np.pi), 20*np.log10(abs(h)))
plt.title("Resposta em frequência")
plt.xlabel("Hz")
plt.ylabel("dB")
plt.grid()
plt.show()

print(coeffs)
