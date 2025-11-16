# 🎶 ECE 451s — Digital Filter Design Project  
*Ain Shams University — Faculty of Engineering*  
*Course: ECE 451s — Digital Signal Processing*  
*Instructor: Dr. Michael Ibrahim*

## 👥 Team Members
- [Amr Khaled](https://github.com/AK35-0)
- [Abdelrahman Momen](https://github.com/Abdelrahman-Momen)
- [Mr Mahdy](https://github.com/crash1218)
- [Student Name 4](https://github.com/username4)

---

## 📝 Project Overview
This project covers the complete design, analysis, and implementation of digital filters using **MATLAB/GNU-Octave**, without relying on GUI tools (e.g., `filterDesigner`, `fvtool`).  
You will:

1. Analyze and process a sample audio file.  
2. Build a digital echo system and an equalizer.  
3. Design and compare four IIR lowpass filters (Butterworth, Chebyshev I, Chebyshev II, Elliptic).  
4. Apply frequency transformations (LPF → HPF/BPF) using pole-zero rotation.

All results, plots, and derivations are included in the final report.

---

## 📂 Repository Structure
```
.
├── README.md
├── task_0_audio.m        # Audio analysis
├── task_1_echo.m         # Echo system + equalizer
├── task_2_lpf.m          # LPF design (Butter/Chebyshev/Elliptic)
├── task_3_transform.m    # LPF → HPF/BPF transformations
├── audio_file/
│   └── sample_audio.wav
└── report/
    └── ECE451s_Project_Report_Group[Num].pdf
```

---

## 📋 Project Tasks

### **Task 0 — Audio File Analysis 🎧**
- Load the audio file and obtain the sampling frequency.  
- Plot the time-domain signal $begin:math:text$ x\[n\] $end:math:text$.  
- Plot the magnitude spectrum.  
- Compute total signal energy in time and frequency domains.

---

### **Task 1 — Digital Echo System 🔊**
- Derive the system LCCDE and $begin:math:text$ H\(z\) $end:math:text$.  
- Implement the echo system and generate plots.  
- Filter the input audio → echoed signal $begin:math:text$ y\_1\[n\] $end:math:text$; compute $begin:math:text$ \\text\{MSE\}\_\{y1\} $end:math:text$.  
- Derive the equalizer LCCDE and $begin:math:text$ G\(z\) $end:math:text$.  
- Implement the equalizer and generate plots.  
- Filter $begin:math:text$ y\_1\[n\] $end:math:text$ → equalized signal $begin:math:text$ y\_2\[n\] $end:math:text$; compute $begin:math:text$ \\text\{MSE\}\_\{y2\} $end:math:text$.

---

### **Task 2 — IIR Lowpass Filter Design 🎛️**
Design a **minimum-order** LPF meeting:  
- Passband: $begin:math:text$ f\_p \= 3 $end:math:text$ kHz  
- Stopband: $begin:math:text$ f\_s \= 4 $end:math:text$ kHz  
- $begin:math:text$ A\_p \\le 1 $end:math:text$ dB  
- $begin:math:text$ A\_s \\ge 50 $end:math:text$ dB  

Design all four types:
1. Butterworth  
2. Chebyshev Type I  
3. Chebyshev Type II  
4. Elliptic  

For each:
- Compute the required order.  
- Generate magnitude/phase and pole-zero plots.  
- Filter $begin:math:text$ x\[n\] $end:math:text$, compute MSE, and compute % energy loss.  

Conclude which filter performs best.

---

### **Task 3 — Frequency Transformation 🔄**
- Convert the Butterworth LPF → HPF via pole-zero rotation by $begin:math:text$ \\pi $end:math:text$.  
- Generate plots for the HPF.  
- Convert the LPF → BPF centered at $begin:math:text$ \\pi\/2 $end:math:text$.  
- Explain how real-valued coefficients are ensured.  
- Generate all BPF plots.

---

## 🚀 Running the Code
1. Clone the repository.  
2. Add the provided audio file inside `audio_file/`.  
3. Update the `audioread` path in `task_0_audio.m` if needed.  
4. Run each `task_*.m` file sequentially in MATLAB or GNU-Octave.

---

## 📦 Final Deliverables
Submit a single compressed file containing:
- All `.m` files  
- The final PDF report (including plots, derivations, and results)
