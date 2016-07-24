/*
 * LINKER SCRIPT
 * Combine files into a final output - big binary file!
 */

/* 
 * Main entry point for this executable
 */
ENTRY(start)

SECTIONS {

	/*
	 * Put sections at the one megabyte mark
	 */
	. = 1M;

	/*
	 * Section boot - content of multiboot_header
	 */
	.boot :
	{
		*(.multiboot_header)
	}

	/*
	 * Section text - content of boot
	 */
	.text :
	{
		*(.text)
	}
}
