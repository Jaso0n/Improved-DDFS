## What's Xilinx SDK(XSDK) for?

XSDK is used to program the C code to control the ZYNQ and our improved DDFS IP.

`DDS_AXI_mReadReg(u32 BASEADDR, int OFFSET)` is a rededine function of `XilOut32(BASEADDR+OFFSET)` included in `xil_io.h`

`DDS_AXI_mReadReg(u32 BASEADDR, int OFFSET)` is a redefine function of `XilIn32(BASEADDR+OFFSET)` included in `xil_io.h`

