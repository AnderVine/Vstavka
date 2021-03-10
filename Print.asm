section .text
    global print_str
    global print_int
    global print_char


print_int:
	push ebp	; запоминаем адрес возврата
	mov ebp, esp	; запоминаем вершину стека
   	sub esp, 32	; память под локальные переменные

    	pushad		; все регистры в стек

    	mov eax, [ebp+8]; num в eax	
    	cmp eax, 0             
   	jnl .positive
    	neg eax

	push dword '-'
    	call print_char	; если число отрицательное - печатаем "-" и инвертируем eax (умножаем на -1)
    	add esp, 4

    .positive:
			
	xor esi, esi	; берем остаток от деления числа на(dl) 10          
    	mov ecx, 10	; и записываем в ebp - 4 + 32 - 1 что эквивалентно конец - текущая позиция
    .itoc:               
        xor edx, edx	; продолжаем c числом деленным на 10(eax)
        div ecx           
        add dl, '0'
        lea edi, [ebp-4+32-1]
        sub edi, esi 	
        mov [edi], dl		; пример 
							; ________________________________ - пустая строка
        inc esi            	; -12345 - eax
							; добавляем в стек '-'
							; 1: 12345 % 10 = 5 -> _______________________________5 
        cmp eax, 0			; 2: 1234 % 10 = 4 -> ______________________________45
        jle .break			; 3: 123 % 10 = 3 -> _____________________________345
    	jmp .itoc			; 4: 12 % 10 = 2 -> ____________________________2345
    .break:					; 5: 1 % 10 =  -> ___________________________12345
				  
	lea edi, [ebp-4+32]	
	sub edi, esi		; в edi адрес первого символа (тут 1-ки) (т.е адрес конца - кол-во символов в строке)
    
	push esi
	push edi
	call print_str		; на печать идет итоговая строка (тут "-12345")
	add esp, 8	
    
	popad

	mov esp, ebp	; восстанавливаем вершину стека

	pop ebp		; восстанавливаем адрес возврата
	ret		; вызод из функции


; print_str(const char* str, int len)
print_str:
	push ebp	; запоминаем адрес возврата
	mov ebp, esp	; запоминаем вершину стека
    	pushad		; все регистры в стек

	mov eax, 0x4
	mov ebx, 0x1
	mov ecx, [ebp+8]
	mov edx, [ebp+12]
	int 0x80
			; печатаем len байт по адресу первой переменной
	popad		; восстанавливаем регистры

	pop ebp		; восстанавливаем адрес возврата
	ret		; вызод из функции


; print_char(char c)
print_char:
	push ebp	; запоминаем адрес вызова
	mov ebp, esp	; запоминаем вершину стека
    	pushad		; все регистры в стек

	mov eax, 0x4
	mov ebx, 0x1
	lea ecx, [ebp+8]
	mov edx, 0x1
	int 0x80
			; печатаем 1 байт по адресу первой переменной
	popad		; восстанавливаем регистры

	pop ebp		; восстанавливаем адрес возврата
	ret		; выход из функции