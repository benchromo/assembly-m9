; template to start a new project 
; 12/29/2017 Saad Biaz
INCLUDE c:\Irvine\Irvine\Irvine32.inc
.386
.model flat,stdcall
.stack 4096
ExitProcess proto,dwExitCode:dword

.data
	prompt1 BYTE "Enter a 32 bit hex number n less than 256",0dh,0ah,0
	prompt2 BYTE "Enter n 32 bit numbers",0dh,0ah,0
	prompt3 BYTE "Please enter a sentence S1 to search for",0dh,0ah,0
	prompt4 BYTE "Please enter a sentence S2 in which to search for S1",0dh,0ah,0
	num DWORD ?
	array DWORD 256 DUP (?)
	sentence1 BYTE 50 DUP (?)
	sentence2 BYTE 50 DUP (?)
	s1Length DWORD ?
	s2Length DWORD ?
	position DWORD ?
	loopEcx DWORD ?
	
.code
main proc
	call ex1
	call ex2
	invoke ExitProcess,0
	; procedure for ex 1
	; Intermediary Registers:
	; --- EAX: input from ReadHex, use to swap elements
	; --- EBX: contain temp
	; --- ECX: contain address of element
	; --- EDX: offset of prompts
	; --- ESI: contain address of array to store elements
	; --- EDI: contain address of element
	ex1 proc
		; save registers to stack
		push eax
		push ebx
		push ecx
		push edx
		push esi
		push edi
		; 1) prompt 1
		mov edx,OFFSET prompt1
		call WriteString
		; store n
		call ReadHex
		mov num,eax
		; 2) prompt 2
		mov edx,OFFSET prompt2
		call WriteString
		; 3) store n numbers in array A
		mov esi,OFFSET array
		mov ecx,num
		readArray: call ReadHex
		mov [esi],eax
		add esi,4			; mov esi to next array index
		loop readArray
		; 4) sort array A in increasing order
		sub esi,4
		mov ecx,OFFSET array		; outer loop from 1 to num-1
		outerLoop: mov edi,ecx
		innerLoop: add edi,4			; inner loop from ecx+1 to num
		; compare swap stuff
		mov eax,[ecx]
		cmp eax,[edi]
		jbe resume
		mov ebx,eax
		mov eax,[edi]
		mov [ecx],eax
		mov [edi],ebx
		; loop stuff
		resume: cmp edi,esi					; if ebx = num, innerLoop is done
		je innerDone
		jmp innerLoop
		innerDone: add ecx,4
		cmp ecx,esi							; if ecx = num, outerLoop is done
		je outerDone
		jmp outerLoop
		outerDone: mov esi,OFFSET array		; display array
		mov ecx,num
		displayLoop: mov eax,[esi]
		call WriteHex
		mov al,0Ah
		call WriteChar
		mov al,0Dh
		call WriteChar
		add esi,4
		loop displayLoop
		; restore registers
		pop edi
		pop esi
		pop edx
		pop ecx
		pop ebx
		pop eax
		ret
	ex1 endp
	; procedure for ex 2
	; Intermediary Registers:
	; --- EAX: input from ReadHex, use to swap elements
	; --- EBX: contain temp
	; --- ECX: contain address of element
	; --- EDX: offset of prompts
	; --- ESI: contain address of array to store elements
	; --- EDI: contain address of element
	ex2 proc
		; save registers to stack
		push eax
		push ebx
		push ecx
		push edx
		push esi
		push edi
		; 1) prompt 3
		mov edx,OFFSET prompt3
		call WriteString
		; 2) read sentence to search for S1
		mov edx,OFFSET sentence1
		mov ecx,31h
		call ReadString
		mov s1Length,eax			; store s1Length
		; 3) prompt 4
		mov edx,OFFSET prompt4
		call WriteString
		; 4) read sentence to search in S2
		mov edx,OFFSET sentence2
		mov ecx,31h
		call ReadString
		mov s2Length,eax			; store s2Length
		; 5) search S2 for S1
		mov esi,OFFSET sentence2
		mov edi,OFFSET sentence1
		mov ebx,1					; init position at 1
		mov ecx,s2Length
		myLoop: mov position,esi
		mov loopEcx,ecx
		mov ecx,s1Length
		cld
		repe cmpsb
		jz Done
		mov ecx,loopEcx
		mov esi,position
		inc esi
		mov edi,OFFSET sentence1
		inc ebx
		loop myLoop
		Done: mov eax,ebx			; 6) display position p if S1 inside S2 or 0 if not
		call WriteHex
		; restore registers
		pop edi
		pop esi
		pop edx
		pop ecx
		pop ebx
		pop eax
		ret
	ex2 endp
main endp
end main