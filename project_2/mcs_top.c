/******************************************************************************
*
* Copyright (C) 2009 - 2014 Xilinx, Inc.  All rights reserved.
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* Use of the Software is limited solely to applications:
* (a) running on a Xilinx device, or
* (b) that interact with a Xilinx device through a bus or interconnect.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
* XILINX  BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
* WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF
* OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
* SOFTWARE.
*
* Except as contained in this notice, the name of the Xilinx shall not be used
* in advertising or otherwise to promote the sale, use or other dealings in
* this Software without prior written authorization from Xilinx.
*
******************************************************************************/

/*
 * helloworld.c: simple test application
 *
 * This application configures UART 16550 to baud rate 9600.
 * PS7 UART (Zynq) is not initialized by this application, since
 * bootrom/bsp configures it to baud rate 115200
 *
 * ------------------------------------------------
 * | UART TYPE   BAUD RATE                        |
 * ------------------------------------------------
 *   uartns550   9600
 *   uartlite    Configurable only in HW design
 *   ps7_uart    115200 (configured by bootrom/bsp)
 */

#include <stdio.h>
#include "platform.h"
#include "xil_printf.h"
#include "xiomodule.h" // add this file
int main()
{
	 init_platform();

	 u32 data;
	 u32 color;
	 u32 xypos = 0b0000000000;

	 u8 rx_buf;

	 XIOModule gpi;
	 XIOModule gpo;

	 print("Austin Hartshorn - November 6, 2019\n\r");
	 print("Reading switches and writing to LED port\n\r");

	 // switch gpi module
	 data = XIOModule_Initialize(&gpi, XPAR_IOMODULE_0_DEVICE_ID);
	 data = XIOModule_Start(&gpi);

	 // led gpo module
	 data = XIOModule_Initialize(&gpo, XPAR_IOMODULE_0_DEVICE_ID);
	 data = XIOModule_Start(&gpo);


	 while (1) {
		 while(XIOModule_IsReceiveEmpty(STDIN_BASEADDRESS)){
			 data = XIOModule_DiscreteRead(&gpi, 1); // read switches (channel 1)
			 switch (data){
				 case 0:
					 color = 0xF00;
					 break;
				 case 1:
					 color = 0x0F0;
					 break;
				 case 2:
					 color = 0xFF0;
					 break;
				 case 3:
					 color = 0x00F;
					 break;
				 default:
					 color = 0xFFF;
			 }
			 XIOModule_DiscreteWrite(&gpo, 1, data); // turn on LEDs (channel 1)
			 XIOModule_DiscreteWrite(&gpo, 3, color); // write block color (channel 3)
		 }
		 rx_buf = inbyte();
		 xil_printf("Recv: The received char was %c\n\r", rx_buf);
		 if(rx_buf == 'a'){
			 if((0b0000011111 & xypos >> 5) != 0){
				 xypos = xypos - 32;
			 }
		 }
		 else if(rx_buf == 'd'){
			 if((0b0000011111 & xypos >> 5) != 19){
				 xypos = xypos + 32;
			 }
		 }
		 else if(rx_buf == 'w'){
			 if ((0b0000011111 & xypos) != 0){
				 xypos = xypos - 1;
			 }
		 }
		 else if(rx_buf == 's'){
			 if((0b0000011111 & xypos) != 19){
				 xypos = xypos + 1;
			 }
		 }
		 XIOModule_DiscreteWrite(&gpo, 2, xypos); // write block xypos (channel 2)
		 xil_printf("New XY Position: (%d, %d)\n\r", xypos >> 5, xypos & 0b0000011111);
	 }

	 cleanup_platform();
	 return 0;
}
