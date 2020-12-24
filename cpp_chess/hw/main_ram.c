/*
This program demonstrate how to use hps communicate with FPGA through light AXI Bridge.
uses should program the FPGA by GHRD project before executing the program
refer to user manual chapter 7 for details about the demo
*/

// #include <stdint.h>
#include <stdio.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/mman.h>
#include "hwlib.h"
#include "socal/socal.h"
#include "socal/hps.h"
#include "socal/alt_gpio.h"
#include "hps_0.h"

#define HW_REGS_BASE ( ALT_STM_OFST )
#define HW_REGS_SPAN ( 0x04000000 )
#define HW_REGS_MASK ( HW_REGS_SPAN - 1 )

int main() {

	void *virtual_base;
	int fd;
	int loop_count;
	int led_direction;
	int led_mask;
	void *h2p_lw_led_addr;

	// uint64_t* ovals = { -1, -1, 0, 0, 1, 2, 3, 4, 5, 6, 1 << 63, 1 << 62, 1 << 61, 1 << 31, 1 << 30, 1 << 29 };
	// uint64_t  ivals[16];
	
	// map the address space for the LED registers into user space so we can interact with them.
	// we'll actually map in the entire CSR span of the HPS since we want to access various registers within that span

	if( ( fd = open( "/dev/mem", ( O_RDWR | O_SYNC ) ) ) == -1 ) {
		printf( "ERROR: could not open \"/dev/mem\"...\n" );
		return( 1 );
	}

	virtual_base = mmap( NULL, HW_REGS_SPAN, ( PROT_READ | PROT_WRITE ), MAP_SHARED, fd, HW_REGS_BASE );

	if( virtual_base == MAP_FAILED ) {
		printf( "ERROR: mmap() failed...\n" );
		close( fd );
		return( 1 );
	}
	
	h2p_lw_led_addr=virtual_base + ( ( unsigned long  )( ALT_LWFPGASLVS_OFST + MEM1_BASE ) & ( unsigned long)( HW_REGS_MASK ) );
	
	// write values to memory
    /*
    for (int i = 0; i < 16; i++) {
        *((uint64_t*)h2p_lw_addr + i) = ovals[i];
    }
    
    // read the values back from memory
    for (int i = 15; i >= 0; i--) {
        ivals[i] = *((uint64_t*)h2p_lw_addr - i)
    }
    
    // check nobody got butchered
    for (int i = 0; i < 16; i++) {
        if (ovals[i] != ivals[i]) {
            printf("ERROR: values at index %d did not match! ovals (%d) != ivals(%d)\n", i, ovals[i], ivals[i]);
        }
    }
    */

	// clean up our memory mapping and exit
	
	if( munmap( virtual_base, HW_REGS_SPAN ) != 0 ) {
		printf( "ERROR: munmap() failed...\n" );
		close( fd );
		return( 1 );
	}

	close( fd );

	return( 0 );
}
