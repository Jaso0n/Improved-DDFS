#include <stdio.h>
#include "platform.h"
#include "xil_printf.h"

#include "xparameters.h"
#include "DDS_AXI.h"
#include "xil_io.h"
#include "xuartps_hw.h"

//#define XPAR_DDS_AXI_0_S00_AXI_BASEADDR 0x43C00000
//#define XPAR_DDS_AXI_0_S00_AXI_HIGHADDR 0x43C0FFFF

//#define DDS_AXI_S00_AXI_SLV_REG0_OFFSET 0
//#define DDS_AXI_S00_AXI_SLV_REG1_OFFSET 4
//#define DDS_AXI_S00_AXI_SLV_REG2_OFFSET 8
//#define DDS_AXI_S00_AXI_SLV_REG3_OFFSET 12

#define DDS_AXI_BASEADDR XPAR_DDS_AXI_0_S00_AXI_BASEADDR
#define DDS_AXI_HIGHADDR XPAR_DDS_AXI_0_S00_AXI_HIGHADDR

#define SLVR0 DDS_AXI_S00_AXI_SLV_REG0_OFFSET
#define SLVR1 DDS_AXI_S00_AXI_SLV_REG1_OFFSET
#define SLVR2 DDS_AXI_S00_AXI_SLV_REG2_OFFSET
#define SLVR3 DDS_AXI_S00_AXI_SLV_REG3_OFFSET
// 0000_0000_00/00_0000_0000_0000_0000_0000

void myuartsend(u32 data)
{
	char rds[4];
	for(int i = 0; i < 4; i++)
	{
		rds[3-i]= (u8)(data>>(i*8));
	}
	for(int i = 0; i < 4; i++)
	{
		while (XUartPs_IsTransmitFull(STDOUT_BASEADDRESS));
		XUartPs_WriteReg(STDOUT_BASEADDRESS, XUARTPS_FIFO_OFFSET, rds[i]);
	}

}
int main()
{
	u32 axi_data;
    init_platform();
    print("Hello World\n\r");

    DDS_AXI_mWriteReg(DDS_AXI_BASEADDR,SLVR1,0);//inital phase counter
    if((axi_data=DDS_AXI_mReadReg(DDS_AXI_BASEADDR,SLVR1) == 0))
    {
    	print("Initial phase counter successful!\n\r");

    }
    else
    {
    	print("Initial Failed\n\r");
    	return 0;
    }

    DDS_AXI_mWriteReg(DDS_AXI_BASEADDR,SLVR0,0x00800000);
    if((axi_data=DDS_AXI_mReadReg(DDS_AXI_BASEADDR,SLVR0) == 0x00800000))
    {
       	print("Initial phase ctl word successful!\n\r");
       	myuartsend(axi_data);
    }
    else
    {
       	print("Initial Failed\n\r");
       	return 0;
    }
    DDS_AXI_mWriteReg(DDS_AXI_BASEADDR,SLVR1,1);
    if((axi_data=DDS_AXI_mReadReg(DDS_AXI_BASEADDR,SLVR1) != 0))
    {
        print("Start counter successful!\n\r");
        outbyte((u8)axi_data);
    }
    else
    {
        print("Initial Failed\n\r");
        return 0;
    }

    axi_data=DDS_AXI_mReadReg(DDS_AXI_BASEADDR,SLVR1);
    myuartsend(axi_data);

    cleanup_platform();
    return 0;
}
