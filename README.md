
- **KBD_ENC** – Decodes PS/2 keyboard scan codes.
- **PRET_CPU** – Pretend CPU logic that interprets scan codes into VRAM write commands.
- **VIDEO_RAM** – Dual-port video memory storing display tiles/characters.
- **VGA_MOTOR** – Generates VGA timing signals and fetches data from VRAM for display.
- **VGA_lab** – Top-level entity connecting all components.
- **VGA_lab_tb** – Testbench that simulates PS/2 keyboard inputs.

---

## 📂 File Structure

| File / Folder | Purpose |
|---------------|---------|
| `src/VIDEO_RAM.vhd` | Dual-port VRAM storing 8-bit character/tile codes. |
| `src/VGA_lab.vhd` | Top-level module connecting keyboard, CPU, VRAM, and VGA motor. |
| `tb/VGA_lab_tb.vhd` | Testbench simulating keyboard input sequences and VGA output timing. |
| `external/KBD_ENC.vhd` | PS/2 keyboard decoder (not included, assumed from course). |
| `external/PRET_CPU.vhd` | Pretend CPU logic (not included, assumed from course). |
| `external/VGA_MOTOR.vhd` | VGA timing and display driver (not included, assumed from course). |

---

## ⚙️ Requirements

- **Simulator:** ModelSim, GHDL, Riviera-PRO, or equivalent VHDL simulator
- **FPGA board (optional for hardware test):** With VGA output & PS/2 input
- **VHDL standard:** IEEE VHDL-2008 (works with VHDL-93 if adjusted)
- External components (`KBD_ENC`, `PRET_CPU`, `VGA_MOTOR`) must be provided from the lab/course materials.

---

## 🚀 How to Simulate

### 1️⃣ Compile all sources
Make sure your simulator knows where `src/` and `tb/` are.

Example with **GHDL**:
```bash
ghdl -a src/VIDEO_RAM.vhd src/VGA_lab.vhd tb/VGA_lab_tb.vhd
