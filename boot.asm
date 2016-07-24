global start

section .text ; Code in a new section
bits 32 	  ; Specify the protected mode (32 bits)
start:
	mov word [0xb8000], 0x0248 ; Copy 'H' (0x0248) to the up-left corner of the screen
	mov word [0xb8002], 0x0265 ; 'e'
	mov word [0xb8004], 0x026c ; 'l'
	mov word [0xb8006], 0x026c ; 'l'
	mov word [0xb8008], 0x026f ; 'o'
	mov word [0x8000a], 0x0220 ; ',' 
	mov word [0xb800c], 0x0220 ; ' '
	mov word [0xb800e], 0x0277 ; 'w'
	mov word [0xb8010], 0x026f ; 'o'
	mov word [0xb8012], 0x0272 ; 'r'
	mov word [0xb8014], 0x026c ; 'l'
	mov word [0xb8016], 0x0264 ; 'd'
	mov word [0xb8018], 0x0221 ; '!'
	hlt		  ; Halt
