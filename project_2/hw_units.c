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
#include "xiomodule.h"
#include "xparameters.h"


void mult128(u32* a1, u32* a2, u32* a3, u32* a4,
		u32* b1, u32* b2, u32* b3, u32* b4,
		u32* mb_cnt, XIOModule* iomodule){
    u32 res1, res2, res3, res4, res5, res6, res7, res8 = 0;

    u32 cnt;

	print("Begin MULT execution\r\n");
    while(1){
    	//send operands
		cnt = XIOModule_DiscreteRead(iomodule, 1);
    	// check hw unit in state IN_A
    	if((cnt & 0b1110000) == 0b0010000 && (*mb_cnt & 1111000) == 0b0011000){
    		print("Entered state IN_A\r\n");
        	// sync with hw unit to write 32 bit chunks
        	if((cnt & 0b0001111) == 0b0000000){
        		XIOModule_DiscreteWrite(iomodule, 1, *a1);
        		*mb_cnt = 0b0011000;
        	}
        	else if((cnt & 0b0001111) == 0b0000001){
        		XIOModule_DiscreteWrite(iomodule, 1, *a2);
        		*mb_cnt = 0b0011001;
        	}
        	else if((cnt & 0b0001111) == 0b0000010){
        		XIOModule_DiscreteWrite(iomodule, 1, *a3);
        		*mb_cnt = 0b0011010;
        	}
        	else if((cnt & 0b0001111) == 0b0000011){
        		XIOModule_DiscreteWrite(iomodule, 1, *a4);
        		*mb_cnt = 0b0101011;
        	}
        	XIOModule_DiscreteWrite(iomodule, 2, *mb_cnt);
    	}
    	// check hw unit in state IN_B
    	else if((cnt & 0b1110000) == 0b0100000 && (*mb_cnt & 1110000) == 0b0100000){
    		print("Entered stat IN_B\r\n");
        	// sync with hw unit to write 32 bit chunks
        	if((cnt & 0b0001111) == 0b0000000){
        		XIOModule_DiscreteWrite(iomodule, 1, *b1);
        		*mb_cnt = 0b0101000;
        	}
        	else if((cnt & 0b0001111) == 0b0000001){
        		XIOModule_DiscreteWrite(iomodule, 1, *b2);
        		*mb_cnt = 0b0101001;
        	}
        	else if((cnt & 0b0001111) == 0b0000010){
        		XIOModule_DiscreteWrite(iomodule, 1, *b3);
        		*mb_cnt = 0b0101010;
        	}
        	else if((cnt & 0b0001111) == 0b0000011){
        		XIOModule_DiscreteWrite(iomodule, 1, *b4);
        		*mb_cnt = 0b0111011;
        	}
        	XIOModule_DiscreteWrite(iomodule, 2, *mb_cnt);
    	}
    	else if((cnt & 0b1110000) == 0b0110000){
    		xil_printf("Entered state MUL: %d\r\n", cnt);
    		if((cnt & 0b0001111) == 0b0001111){
				print("INIT MUL \r\n");
    			*mb_cnt = 0b1001000;
    		}
    		else {
    			*mb_cnt = 0b0111111;
    		}
        	XIOModule_DiscreteWrite(iomodule, 2, *mb_cnt);
    	}
    	// check hw unit in state WB (after MUL finishes)
    	//&& (mb_cnt & 1110000) == 0b1000000
		else if((cnt & 0b1110000) == 0b1000000){
    		xil_printf("Entered state WB, cnt: %d, mb_cnt: %d\r\n", cnt, *mb_cnt);
			// sync with hw unit to read 32 bit chunks
			if((cnt & 0b0001111) == 0b0000000 && *mb_cnt == 0b1001000){
				res1 = XIOModule_DiscreteRead(iomodule, 2);
				*mb_cnt = 0b1001001;
				xil_printf("Read res1: %d\r\n", res1);
			}
			else if((cnt & 0b0001111) == 0b0000001 && *mb_cnt == 0b1001001){
				print("Read res2\r\n");
				res2 = XIOModule_DiscreteRead(iomodule, 2);
				*mb_cnt = 0b1001010;
			}
			else if((cnt & 0b0001111) == 0b0000010 && *mb_cnt == 0b1001010){
				print("Read res3\r\n");
				res3 = XIOModule_DiscreteRead(iomodule, 2);
				*mb_cnt = 0b1001011;
			}
			else if((cnt & 0b0001111) == 0b0000011 && *mb_cnt == 0b1001011){
				print("Read res4\r\n");
				res4 = XIOModule_DiscreteRead(iomodule, 2);
				*mb_cnt = 0b1001100;
			}
			else if((cnt & 0b0001111) == 0b0000100 && *mb_cnt == 0b1001100){
				print("Read res5\r\n");
				res5 = XIOModule_DiscreteRead(iomodule, 2);
				*mb_cnt = 0b1001101;
			}
			else if((cnt & 0b0001111) == 0b0000101 && *mb_cnt == 0b1001101){
				print("Read res6\r\n");
				res6 = XIOModule_DiscreteRead(iomodule, 2);
				*mb_cnt = 0b1001110;
			}
			else if((cnt & 0b0001111) == 0b0000110 && *mb_cnt == 0b1001110){
				print("Read res7\r\n");
				res7 = XIOModule_DiscreteRead(iomodule, 2);
				*mb_cnt = 0b1001111;
			}
			else if((cnt & 0b0001111) == 0b0000111 && *mb_cnt == 0b1001111){
				print("Read res8\r\n");
				res8 = XIOModule_DiscreteRead(iomodule, 2);
				*mb_cnt = 0b0000000;
			}
        	XIOModule_DiscreteWrite(iomodule, 2, *mb_cnt);
		}
		else if((cnt & 0b1110000) == 0b0000000 && (*mb_cnt & 1110000) == 0b0000000){
    		print("Entered state IDLE\r\n");
    		*mb_cnt = 0b0000000;
        	XIOModule_DiscreteWrite(iomodule, 2, *mb_cnt);
			xil_printf("Result: %u %u %u %u %u %u %u %u\r\n",
					res1, res2, res3, res4, res5, res6, res7, res8);
			return;
		}
    }
}

void div64(u32* a1, u32* a2, u32* b1, u32* b2,
		u32* mb_cnt, XIOModule* iomodule){
	u32 res1, res2, res3, res4 = 0;
	u32 cnt;

	print("\r\nBegin DIV execution\r\n");
	while(1){
		//send operands
		cnt = XIOModule_DiscreteRead(iomodule, 4);
		// check hw unit in state IN_A
		if((cnt & 0b1110000) == 0b0010000 && (*mb_cnt & 1111000) == 0b0010000){
			print("Entered state IN_A\r\n");
			// sync with hw unit to write 32 bit chunks
			if((cnt & 0b0001111) == 0b0000000){
				XIOModule_DiscreteWrite(iomodule, 1, *a1);
				*mb_cnt = 0b0010001;
			}
			else if((cnt & 0b0001111) == 0b0000001){
				XIOModule_DiscreteWrite(iomodule, 1, *a2);
				*mb_cnt = 0b0100010;
			}
			XIOModule_DiscreteWrite(iomodule, 2, *mb_cnt);
		}
		// check hw unit in state IN_B
		else if((cnt & 0b1110000) == 0b0100000 && (*mb_cnt & 1110000) == 0b0100000){
			print("Entered stat IN_B\r\n");
			// sync with hw unit to write 32 bit chunks
			if((cnt & 0b0001111) == 0b0000000){
				XIOModule_DiscreteWrite(iomodule, 1, *b1);
				*mb_cnt = 0b0100000;
			}
			else if((cnt & 0b0001111) == 0b0000001){
				XIOModule_DiscreteWrite(iomodule, 1, *b2);
				*mb_cnt = 0b0110001;
			}
			XIOModule_DiscreteWrite(iomodule, 2, *mb_cnt);
		}
		else if((cnt & 0b1110000) == 0b0110000){
			xil_printf("Entered state DIV_1: %d\r\n", cnt);
			*mb_cnt = 0b0110000;
			XIOModule_DiscreteWrite(iomodule, 2, *mb_cnt);
		}
		else if((cnt & 0b1110000) == 0b1000000){
			xil_printf("Entered state DIV_2: %d\r\n", cnt);
		}
		// check hw unit in state WB (after DIV finishes)
		//&& (mb_cnt & 1110000) == 0b1000000
		else if((cnt & 0b1110000) == 0b1010000){
			xil_printf("Entered state WB, cnt: %d, mb_cnt: %d\r\n", cnt, *mb_cnt);
			if((*mb_cnt & 0b1110000) != 0b1010000){
				*mb_cnt = 0b1010000;
			}
			// sync with hw unit to read 32 bit chunks
			if((cnt & 0b0001111) == 0b0000000 && *mb_cnt == 0b1010000){
				res1 = XIOModule_DiscreteRead(iomodule, 3);
				*mb_cnt = 0b1010001;
				xil_printf("Read res1: %d\r\n", res1);
			}
			else if((cnt & 0b0001111) == 0b0000001 && *mb_cnt == 0b1010001){
				print("Read res2\r\n");
				res2 = XIOModule_DiscreteRead(iomodule, 3);
				*mb_cnt = 0b1010010;
			}
			else if((cnt & 0b0001111) == 0b0000010 && *mb_cnt == 0b1010010){
				print("Read res3\r\n");
				res3 = XIOModule_DiscreteRead(iomodule, 3);
				*mb_cnt = 0b1010011;
			}
			else if((cnt & 0b0001111) == 0b0000011 && *mb_cnt == 0b1010011){
				print("Read res4\r\n");
				res4 = XIOModule_DiscreteRead(iomodule, 3);
				*mb_cnt = 0b0000000;
			}
			XIOModule_DiscreteWrite(iomodule, 2, *mb_cnt);
		}
		else if((cnt & 0b1110000) == 0b0000000 && (*mb_cnt & 1111000) == 0b0000000){
			print("Entered state IDLE\r\n");
			*mb_cnt = 0b0000000;
			XIOModule_DiscreteWrite(iomodule, 2, *mb_cnt);
			xil_printf("Quotient: %u %u Remainder: %u %u\r\n",
					res1, res2, res3, res4);
			return;
		}
	}
}

/*
 * Get the operation to perform, either multiplication or division
 */
u8 get_op(){
	u8 rx_buf;

	print("\r\nEnter 'x' for multiplication or '/' for division\r\n");
	while(1){
		rx_buf = inbyte();
		xil_printf("%c", rx_buf);
		if(rx_buf == 'x' || rx_buf == '/'){
			return rx_buf;
		}
	}
}


/*
 * Check that the character received is a valid hexadecimal character
 */
u8 is_valid_hex(u8* val){
	if(*val < 58 && *val > 47){
		return 1;
	}
	else if(*val < 103 && *val > 96){
		return 1;
	}
	else {
		return 0;
	}
}

/*
 * Convert the character to a number.
 */
u32 convert_char_to_num(u8 val){
	if (val >= '0' && val <= '9')
		return val - '0';
	else if (val >= 'a' && val <= 'f')
		return val - 'a' + 10;
	else {
		// shouldnt get here
		return 0;
	}
}

/*
 * Read the mul operands. Operands are read in as characters and will have
 * to be concatenated into binary representation.
 */
void read_mul_operands(u32* a1, u32* a2, u32* a3, u32* a4,
		u32* b1, u32* b2, u32* b3, u32* b4){
	u8 rx_buf;
    u8 in_a[32];
    u8 in_b[32];

	print("\r\nEnter 32 hex values (128 bits) for operand A\r\n");
	u8 i = 0;
	while(i < 32){
		rx_buf = inbyte();
		if(is_valid_hex(&rx_buf)){
			in_a[i] = rx_buf;
			xil_printf("%c", rx_buf);
			i++;
		}
	}
	print("\r\nEnter 32 hex values (128 bits) for operand B\r\n");
	i = 0;
	while(i < 32){
		rx_buf = inbyte();
		if(is_valid_hex(&rx_buf)){
			in_b[i] = rx_buf;
			xil_printf("%c", rx_buf);
			i++;
		}
	}
	*a4 = ((convert_char_to_num(in_a[0]) << 28) | (convert_char_to_num(in_a[1]) << 24) | (convert_char_to_num(in_a[2]) << 20) | (convert_char_to_num(in_a[3]) << 16) |
			(convert_char_to_num(in_a[4]) << 12) | (convert_char_to_num(in_a[5]) << 8) | (convert_char_to_num(in_a[6]) << 4) | (convert_char_to_num(in_a[7])));
	*a3 = ((convert_char_to_num(in_a[8]) << 28) | (convert_char_to_num(in_a[9]) << 24) | (convert_char_to_num(in_a[10]) << 20) | (convert_char_to_num(in_a[11]) << 16) |
			(convert_char_to_num(in_a[12]) << 12) | (convert_char_to_num(in_a[13]) << 8) | (convert_char_to_num(in_a[14]) << 4) | (convert_char_to_num(in_a[15])));
	*a2 = ((convert_char_to_num(in_a[16]) << 28) | (convert_char_to_num(in_a[17]) << 24) | (convert_char_to_num(in_a[18]) << 20) | (convert_char_to_num(in_a[19]) << 16) |
			(convert_char_to_num(in_a[20]) << 12) | (convert_char_to_num(in_a[21]) << 8) | (convert_char_to_num(in_a[22]) << 4) | (convert_char_to_num(in_a[23])));
	*a1 = ((convert_char_to_num(in_a[24]) << 28) | (convert_char_to_num(in_a[25]) << 24) | (convert_char_to_num(in_a[26]) << 20) | (convert_char_to_num(in_a[27]) << 16) |
			(convert_char_to_num(in_a[28]) << 12) | (convert_char_to_num(in_a[29]) << 8) | (convert_char_to_num(in_a[30]) << 4) | (convert_char_to_num(in_a[31])));
	*b4 = ((convert_char_to_num(in_b[0]) << 28) | (convert_char_to_num(in_b[1]) << 24) | (convert_char_to_num(in_b[2]) << 20) | (convert_char_to_num(in_b[3]) << 16) |
			(convert_char_to_num(in_b[4]) << 12) | (convert_char_to_num(in_b[5]) << 8) | (convert_char_to_num(in_b[6]) << 4) | (convert_char_to_num(in_b[7])));
	*b3 = ((convert_char_to_num(in_b[8]) << 28) | (convert_char_to_num(in_b[9]) << 24) | (convert_char_to_num(in_b[10]) << 20) | (convert_char_to_num(in_b[11]) << 16) |
			(convert_char_to_num(in_b[12]) << 12) | (convert_char_to_num(in_b[13]) << 8) | (convert_char_to_num(in_b[14]) << 4) | (convert_char_to_num(in_b[15])));
	*b2 = ((convert_char_to_num(in_b[16]) << 28) | (convert_char_to_num(in_b[17]) << 24) | (convert_char_to_num(in_b[18]) << 20) | (convert_char_to_num(in_b[19]) << 16) |
			(convert_char_to_num(in_b[20]) << 12) | (convert_char_to_num(in_b[21]) << 8) | (convert_char_to_num(in_b[22]) << 4) | (convert_char_to_num(in_b[23])));
	*b1 = ((convert_char_to_num(in_b[24]) << 28) | (convert_char_to_num(in_b[25]) << 24) | (convert_char_to_num(in_b[26]) << 20) | (convert_char_to_num(in_b[27]) << 16) |
			(convert_char_to_num(in_b[28]) << 12) | (convert_char_to_num(in_b[29]) << 8) | (convert_char_to_num(in_b[30]) << 4) | (convert_char_to_num(in_b[31])));

}

/*
 * Read the div operands. Operands are read in as characters and will have
 * to be concatenated into binary representation.
 */
void read_div_operands(u32* a1, u32* a2, u32* b1, u32* b2){
	u8 rx_buf;
	    u8 in_a[16];
	    u8 in_b[16];

		print("\r\nEnter 16 hex values (64 bits) for operand A\r\n");
		u8 i = 0;
		while(i < 16){
			rx_buf = inbyte();
			if(is_valid_hex(&rx_buf)){
				in_a[i] = rx_buf;
				xil_printf("%c", rx_buf);
				i++;
			}
		}
		print("\r\nEnter 16 hex values (64 bits) for operand B\r\n");
		i = 0;
		while(i < 16){
			rx_buf = inbyte();
			if(is_valid_hex(&rx_buf)){
				in_b[i] = rx_buf;
				xil_printf("%c", rx_buf);
				i++;
			}
		}
		*a2 = ((convert_char_to_num(in_a[0]) << 28) | (convert_char_to_num(in_a[1]) << 24) | (convert_char_to_num(in_a[2]) << 20) | (convert_char_to_num(in_a[3]) << 16) |
				(convert_char_to_num(in_a[4]) << 12) | (convert_char_to_num(in_a[5]) << 8) | (convert_char_to_num(in_a[6]) << 4) | (convert_char_to_num(in_a[7])));
		*a1 = ((convert_char_to_num(in_a[8]) << 28) | (convert_char_to_num(in_a[9]) << 24) | (convert_char_to_num(in_a[10]) << 20) | (convert_char_to_num(in_a[11]) << 16) |
				(convert_char_to_num(in_a[12]) << 12) | (convert_char_to_num(in_a[13]) << 8) | (convert_char_to_num(in_a[14]) << 4) | (convert_char_to_num(in_a[15])));
		*b2 = ((convert_char_to_num(in_b[0]) << 28) | (convert_char_to_num(in_b[1]) << 24) | (convert_char_to_num(in_b[2]) << 20) | (convert_char_to_num(in_b[3]) << 16) |
				(convert_char_to_num(in_b[4]) << 12) | (convert_char_to_num(in_b[5]) << 8) | (convert_char_to_num(in_b[6]) << 4) | (convert_char_to_num(in_b[7])));
		*b1 = ((convert_char_to_num(in_b[8]) << 28) | (convert_char_to_num(in_b[9]) << 24) | (convert_char_to_num(in_b[10]) << 20) | (convert_char_to_num(in_b[11]) << 16) |
				(convert_char_to_num(in_b[12]) << 12) | (convert_char_to_num(in_b[13]) << 8) | (convert_char_to_num(in_b[14]) << 4) | (convert_char_to_num(in_b[15])));
}

int main()
{
    init_platform();

    u32 data;
    u8 operation;
    u32 mb_cnt;

    u32 a1, a2, a3, a4, b1, b2, b3, b4;

    XIOModule iomodule; // iomodule variable for gpi, gpo, and uart

    // Initialize module to obtain base address
    data = XIOModule_Initialize(&iomodule, XPAR_IOMODULE_0_DEVICE_ID);
    data = XIOModule_Start(&iomodule);
//  data = XIOModule_CfgInitialize(&iomodule, NULL, 1);
//  xil_printf("CFInitialize returned (0 = success) %d\n\r", data);

	// start by initializing the control signal

    while(1) {
    	//get operation:
    	operation = get_op();
    	if(operation == 'x'){
        	read_mul_operands(&a1, &a2, &a3, &a4, &b1, &b2, &b3, &b4);
    		mb_cnt = 0b0011111;
			XIOModule_DiscreteWrite(&iomodule, 2, mb_cnt);
    		mult128(&a1, &a2, &a3, &a4,
    				&b1, &b2, &b3, &b4,
					&mb_cnt, &iomodule);
        	xil_printf("\r\nEntered Number A: %x%x%x%x\r\n", a1, a2, a3, a4);
        	xil_printf("\r\nEntered Number B: %x%x%x%x\r\n", b1, b2, b3, b4);
    	}
    	else if(operation == '/'){
    		read_div_operands(&a1, &a2, &b1, &b2);
			mb_cnt = 0b0010111;
			XIOModule_DiscreteWrite(&iomodule, 2, mb_cnt);
			div64(&a1, &a2, &b1, &b2,
					&mb_cnt, &iomodule);
	    	xil_printf("\r\nEntered Number A: %x%x\r\n", a2, a1);
	    	xil_printf("\r\nEntered Number B: %x%x\r\n", b2, b1);
    	}
    }

    cleanup_platform();
    return 0;
}
