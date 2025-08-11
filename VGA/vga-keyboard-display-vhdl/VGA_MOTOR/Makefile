# (Or proj2.simc, proj2.sim, etc, depending on the name of the
# project)

XILINX_INIT = source /opt/xilinx_ise/14.7/settings64.sh;
PART=xc6slx16-3-csg324


VGA_MOTOR.%: S=VGA_lab.vhd VGA_MOTOR.vhd CHAR_ROM.vhd ../VIDEO_RAM.vhd
VGA_MOTOR.%: T=VGA_lab_tb.vhd
VGA_MOTOR.%: U=Nexys3.ucf


# Det här är ett exempel på hur man kan skriva en testbänk som är
# relevant, även om man kör en simulering i batchläge (make batchlab.simc)
#batchlab.%: S=lab.vhd leddriver.vhd
#batchlab.%: T=batchlab_tb.vhd tb_print7seg.vhd
#batchlab.%: U=lab.ucf


# Misc functions that are good to have
include build/util.mk
# Setup simulation environment
include build/vsim.mk
# Setup synthesis environment
include build/xst.mk
# Setup backend flow environment
include build/xilinx-par.mk
# Setup tools for programming the FPGA
include build/digilentprog.mk



# Alternative synthesis methods
# The following is for ASIC synthesis
#include design_compiler.mk
# The following is for synthesis to a Xilinx target using Precision.
#include precision-xilinx.mk



