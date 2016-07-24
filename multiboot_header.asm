section .multiboot_header
header_start:						; label to point to the beginning of the following magic number
	dd 0xe85250d6 					; 32-bit data as a magic number
	dd 0 		  					; boot into protected mode
	dd header_end - header_start	; header length

	; checksum
	dd 0x100000000 - (0xe85250d6 + 0 + (header_end - header_start))
	
	; end tags
	dw 0 ; define word for type
	dw 0 ; define word for flags
	dw 8 ; define word for size
header_end:							; label to compute the header length
