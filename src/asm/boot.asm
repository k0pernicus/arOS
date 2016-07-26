global start

; Rust code, extern to boot.asm
extern kernel_main

section .text ; Code in a new section
bits 32 	  ; Specify the protected mode (32 bits)
start:
	;; VALID INITIAL PAGE TABLE

	; Point the first entry of the p4 table to the 1rst
	; entry in the p3 table
	mov eax, p3_table
	or eax, 0b11
	mov dword [p4_table + 0], eax

	; Point the first entry of the p3 table to the 1rst
	; entry in the p2 table
	mov eax, p2_table
	or eax, 0b11
	mov dword [p3_table + 0], eax

	; Set up the level two page table to have valid
	; references to pages
	mov ecx, 0 ; counter variable
.map_p2_table:
	mov eax, 0x200000 ; 2MiB
	mul ecx	; Multiply ecx with eax, which store the
			; result in eax
	or eax, 0b10000011 ; Each entry is 8 bits in size
	mov [p2_table + ecx * 8], eax ; Store eax in the
								  ; exact location for
								  ; p2_table
	inc ecx	; Increment ecx value
	cmp ecx, 512 ; Compare ecx with 512
	jne .map_p2_table ; If not ok, jump to .map_p2_table subsection

	;; NOW, INFORM THE HARWARE ABOUT IT
	;; 4 steps:
	;; * Put the address of the p4 table in a special register
	;; * enable 'physical address extension'
	;; * set the 'long mode bit'
	;; * enable paging

	; Step 1: move p4 table address to cr3
	mov eax, p4_table
	mov cr3, eax ; cr3: control register number 3
				 ; canno't move directly p4_table to cr3 because
				 ; cr3 is a special register - cr3 needs to hold
				 ; a value from another register ONLY, like eax
	
	; Step 2: enabling PAE
	mov eax, cr4
	or eax, 1 << 5
	mov cr4, eax

	; Step 3: setting LMB
	mov ecx, 0xC0000080
	rdmsr ; read to a model specific register
	or eax, 1 << 8
	wrmsr ; write to a model specific register

	; Step 4: enabling paging
	mov eax, cr0
	or eax, 1 << 31 ; Set bit 31
	or eax, 1 << 16 ; Set bit 16
	mov cr0, eax
	
	lgdt [gdt64.pointer] ; pass to the load gdt instruction the
					 ; value of our pointer

	;; ENABLE SEGMENT REGISTERS
	; updating selectors
	mov ax, gdt64.data ; sixteen-bit register ('e' in eax is for extended: 32 bits)
	mov ss, ax ; stack segment register
	mov ds, ax ; data segment register - points to the data segment of our GDT
	mov es, ax ; extra segment register - needs to be set

	jmp gdt64.code:kernel_main ; jump to kernel_main, call it to run Rust code

	hlt

section .bss ; bss = block started by symbol
			 ; entries in this section are automatically
			 ; set to zero by the linker
align 4096	 ; set alignment to 4096 bytes for our tables
p4_table:
	resb 4096; implement the p4 table, and reserver 4096
			 ; bytes space for each entries
p3_table:
	resb 4096
p2_table:
	resb 4096

; First entry in the GDT: zero value
section .rodata ; Section for 'read only data'
gdt64:
	dq 0 ; 64-bit value
.code: equ $ - gdt64 ; get the offset of that entry, minus
					 ; the address of gdt64
	; 44th: descriptor type (1 for code and data segments)
	; 47th: present (1 if the entry is valid)
	; 41th: read/write (1 for readable)
	; 43th: executable (1 for code segments)
	; 53th: 64-bit (1 to set 64-bit GDT)
	dq (1<<44) | (1<<47) | (1<<41) | (1 << 43) | (1 << 53)
.data: equ $ - gdt64 ; data segment
	; 41th here is for writable
	dq (1<<44) | (1<<47) | (1<<41)
.pointer:
	dw .pointer - gdt64 - 1 ; calculate the length
	dq gdt64 ; address of our table
