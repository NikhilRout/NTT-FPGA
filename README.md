# NTT_FPGA
Verilog Implementation of the Number Theoretic Transform (NTT) and its inverse operation (INTT), utilizing modulo arithmetic, for developing lattice-based Post Quantum Cryptography (PQC) and Homomorphic Encryption (HE) on FPGAs as desribed in the paper
 > A. Satriawan, I. Syafalni, R. Mareta, I. Anshori, W. Shalannanda and A. Barra, "Conceptual Review on Number Theoretic Transform and Comprehensive Review on Its Implementations," in IEEE Access, vol. 11, pp. 70288-70316, 2023, doi: 10.1109/ACCESS.2023.3294446

# Worked Out Example
## Number Theoretic Transform (NTT)
A four-point NTT structure with **ψ** = 1925 in the ring **Z**<sub>7681</sub> is considered. A Cooley-Tukey butterfly unit based fast-NTT requires log<sub>2</sub>(n) stages. This implies our example shall need 2 stages\
<img width="640" alt="image" src= "https://github.com/user-attachments/assets/6e29ce19-14b7-4d09-b381-5b2e24c81306">\
Note: Inputs are in Normal order, Outputs are in Bit-reversed Order

## Inverse Number Theoretic Transform (INTT)
Likewise a four-point INTT structure based on Gentleman-Sande Butterfly units shall require 2 stages\
<img width="640" alt="image" src= "https://github.com/user-attachments/assets/659d9de8-f150-41b6-aec3-f22129ffeb58">\
Note: Inputs are in Bit-reversed Order, Outputs are in Normal order
