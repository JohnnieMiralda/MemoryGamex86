; #exec "/home/johnnie/Documents/orga2/x86/memory.asm"

;  orden en la pila
; || pos arrow izquierdo || pos arrow arriba || 1,4,2,3,7,2,4,1,3 || select 1 || select 2 || cuanto select || vidas
;
main:
    call print_cosas
    sub esp,60
    mov dword[esp],1
    mov dword[esp+4],0
    mov dword[esp+8],1
    mov dword[esp+12],4
    mov dword[esp+16],2
    mov dword[esp+20],3
    mov dword[esp+24],7
    mov dword[esp+28],2
    mov dword[esp+32],4
    mov dword[esp+36],1
    mov dword[esp+40],3
    mov dword[esp+44],0
    mov dword[esp+48],0
    mov dword[esp+52],0
    mov dword[esp+56],4
    mov ebx, esp
    push ebx
    call print_arrows
    

    $loop:
    
    call delay
    call print_arrows
    call print_tablero


    cmp [ebx+52],2
    jne saltar
        call print_tablero
        call delay
        call logica
    saltar:

    
    call print_falta

    cmp [ebx+56],0
    je $end_loop

        
    $test_keys:
        mov ah, byte [0xffff0004] ; Keypad
        mov al, ah
        
        ; Left key
        and al, 0x1
        test al, al
        jz $test_right
        sub [ebx],1
        mov ecx, [ebx]
        
    ; variable x = esi -4
    ;asi != 0

        jmp $loop
            
    $test_right:
        mov al, ah
        and al, 0x2
        test al, al
        jz $test_down
        add [ebx],1
        mov ecx, [ebx]
        jmp $loop

    $test_down:
        mov al, ah
        and al, 0x4
        test al, al
        jz $test_up
        add [ebx+4],3
        mov ecx, [ebx+4]
        jmp $loop

    $test_up:
        mov al, ah
        and al, 0x8
        test al, al
        jz $test_space
        sub [ebx+4],3
        mov ecx, [ebx+4]
        jmp $loop
    $test_space:
        mov al, ah
        and al, 0x80
        test al, al
        jz $test_q
        call logica_select
        ;call print_falta
        call print_tablero
        jmp $loop

    $test_q:
        mov al, ah
        and al, 0x10
        test al, al
        jnz $end_loop
        
        jmp $test_keys

    $end_loop:
        add esp, 60
        call print_cosas
        mov edx, 0xb800
        add edx, 2264
        ;g=47 a=41 n=4e a=41 s=53 t=54 e=45 !=21

        mov dword[edx],0x1e411e47
        add edx,4
        mov dword[edx],0x1e411e4e
        add edx,4
        mov dword[edx],0x1e541e53
        add edx,4
        mov dword[edx],0x1e211e45
        #stop



logica_select:
    mov edx, dword[esp+4]
    mov ecx, [edx]
    add ecx, [edx+4]

    cmp [edx+52],1
    je select2
select1:
    mov dword[edx+44],ecx
    jmp log_fin
select2:
    mov dword[edx+48],ecx
log_fin:
    add dword[edx+52],1
    ret

recet:

    mov edx, dword[esp+4]
    mov dword[edx+52],0
    mov dword[edx+44],0
    mov dword[edx+48],0
    ret
print_falta:
;f=46 a=41 l=4c  t=54  a=41  n=4e :=3a 4=34  3=33 2=32  1=31
    mov edx, 0xb800
    add edx, 1940
    mov ebp, dword[esp+4]
    mov ecx, [ebp+56]
  
    mov dword[edx],0x1e411e46
    add edx,4
    mov dword[edx],0x1e541e4c
    add edx,4
    mov dword[edx],0x1e4e1e41
    add edx,8
    
    cmp ecx,4
    je nu
    cmp ecx,3
    je ne
    cmp ecx,2
    je ni
    cmp ecx,1
    je np
    cmp ecx,0
    je npi

    nu:
    mov dword[edx],0x1e341e3a ;4
    ret
    ne:
    mov dword[edx],0x1e331e3a ;3
    ret
    ni:
    mov dword[edx],0x1e321e3a ;2
    ret
    np:
    mov dword[edx],0x1e311e3a ;1
    ret
    npi:
    mov dword[edx],0x1e301e3a ;0
    ret
    
logica:
    mov ebp, dword[esp+4]
   
    mov eax, 4
    imul [ebp+44]
    add eax, 4
    mov ecx, [ebp+eax]

    mov eax, 4
    imul [ebp+48]
    add eax, 4
    mov edx, [ebp+eax]

    cmp ecx, edx
    je si
    jmp no

    si:
        mov eax, 4
        imul [ebp+44]
        add eax, 4
        mov dword[ebp+eax],0  

        mov eax, 4
        imul [ebp+48]
        add eax, 4
        mov dword[ebp+eax],0


        mov dword[ebp+44],0
        mov dword[ebp+48],0
        mov dword[ebp+52],0
        dec dword[ebp+56]
        mov ebx,ebp
    ret
    no:
        mov dword[ebp+44],0
        mov dword[ebp+48],0
        mov dword[ebp+52],0
        mov ebx,ebp
    ret

print_cosas:
    mov ebx, 0xb800
    add ebx, 340
    mov dword[ebx],0x1e021e01
    add ebx, 160
    mov dword[ebx],0x1e041e03

    add ebx, 320
    mov dword[ebx],0x1e021e01
    add ebx, 160
    mov dword[ebx],0x1e041e03

    add ebx, 320
    mov dword[ebx],0x1e021e01
    add ebx, 160
    mov dword[ebx],0x1e041e03

    add ebx, 10
    mov dword[ebx],0x1e041e03
    sub ebx, 160
    mov dword[ebx],0x1e021e01

    sub ebx, 320
    mov dword[ebx],0x1e101e0f
    sub ebx, 160
    mov dword[ebx],0x1e0e1e0d

    sub ebx, 320
    mov dword[ebx],0x1e041e03
    sub ebx, 160
    mov dword[ebx],0x1e021e01

    add ebx, 8
    mov dword[ebx],0x1e021e01
    add ebx, 160
    mov dword[ebx],0x1e041e03

    add ebx, 320
    mov dword[ebx],0x1e021e01
    add ebx, 160
    mov dword[ebx],0x1e041e03

    add ebx, 320
    mov dword[ebx],0x1e021e01
    add ebx, 160
    mov dword[ebx],0x1e041e03

    mov edx, 0xb800
    add edx, 2264
        ;g=47 a=41 n=4e a=41 s=53 t=54 e=45 !=21
    mov dword[edx],0x00410047
    add edx,4
    mov dword[edx],0x0041004e
    add edx,4
    mov dword[edx],0x00540053
    add edx,4
    mov dword[edx],0x00210045

    ret

print_tablero:  ;1,4,2,3,7,2,4,1,3 
    mov ebp, dword[esp+4]
    mov eax, 0xb800
    mov ebx, 8
    mov ecx, [ebp+44]
    mov edx, [ebp+48]

    #show ecx
    #show edx
    #show [10] ascii

    add eax, 340
    cmp ecx,1
    je s1
    cmp edx,1
    je s1
    cmp [ebp+ebx],0
    je n1
    mov dword[eax],0x1e021e01
    add eax,160
    mov dword[eax],0x1e041e03
    sub eax,160
    jmp f1
    s1:
    mov dword[eax],0x1e061e05
    add eax,160
    mov dword[eax],0x1e061e05
    sub eax,160
    jmp f1
    n1:
    mov dword[eax],0x00060005
    add eax,160
    mov dword[eax],0x00060005
    sub eax,160
    f1:

    add eax, 10
    add ebx,4
    cmp ecx,2
    je s2
    cmp edx,2
    je s2
    cmp [ebp+ebx],0
    je n2
    mov dword[eax],0x1e021e01
    add eax,160
    mov dword[eax],0x1e041e03
    sub eax,160
    jmp f2
    s2:
    mov dword[eax],0x1e081e07
    add eax,160
    mov dword[eax],0x1e081e07
    sub eax,160
    jmp f2
    n2:
    mov dword[eax],0x00080007
    add eax,160
    mov dword[eax],0x00060005
    sub eax,160
    f2:

    add eax, 8
    add ebx,4
    cmp ecx,3
    je s3
    cmp edx,3
    je s3
    cmp [ebp+ebx],0
    je n3
    mov dword[eax],0x1e021e01
    add eax,160
    mov dword[eax],0x1e041e03
    sub eax,160
    jmp f3
    s3:
    mov dword[eax],0x1e0a1e09
    add eax,160
    mov dword[eax],0x1e0a1e09
    sub eax,160
    jmp f3
    n3:
    mov dword[eax],0x000a0009
    add eax,160
    mov dword[eax],0x00060005
    sub eax,160
    f3:

    add eax, 480
    add ebx,12
    cmp ecx,6
    je s6
    cmp edx,6
    je s6
    cmp [ebp+ebx],0
    je n6
    mov dword[eax],0x1e021e01
    add eax,160
    mov dword[eax],0x1e041e03
    sub eax,160
    jmp f6
    s6:
    mov dword[eax],0x1e0a1e09
    add eax,160
    mov dword[eax],0x1e0a1e09
    sub eax,160
    jmp f6
    n6:
    mov dword[eax],0x000a0009
    add eax,160
    mov dword[eax],0x00060005
    sub eax,160
    f6:

    sub eax, 18
    sub ebx, 8
    cmp ecx,4
    je s4
    cmp edx,4
    je s4
    cmp [ebp+ebx],0
    je n4
    mov dword[eax],0x1e021e01
    add eax,160
    mov dword[eax],0x1e041e03
    sub eax,160
    jmp f4
    s4:
    mov dword[eax],0x1e0c1e0b
    add eax,160
    mov dword[eax],0x1e0c1e0b
    sub eax,160
    jmp f4
    n4:
    mov dword[eax],0x000c000b
    add eax,160
    mov dword[eax],0x00060005
    sub eax,160
    f4:

    add eax, 480
    add ebx, 12
    cmp ecx,7
    je s7
    cmp edx,7
    je s7
    cmp [ebp+ebx],0
    je n7
    mov dword[eax],0x1e021e01
    add eax,160
    mov dword[eax],0x1e041e03
    sub eax,160
    jmp f7
    s7:
    mov dword[eax],0x1e081e07
    add eax,160
    mov dword[eax],0x1e081e07
    sub eax,160
    jmp f7
    n7:
    mov dword[eax],0x00080007
    add eax,160
    mov dword[eax],0x00060005
    sub eax,160
    f7:

    add eax, 10
    add ebx, 4
    cmp ecx,8
    je s8
    cmp edx,8
    je s8
    cmp [ebp+ebx],0
    je n8
    mov dword[eax],0x1e021e01
    add eax,160
    mov dword[eax],0x1e041e03
    sub eax,160
    jmp f8
    s8:
    mov dword[eax],0x1e061e05
    add eax,160
    mov dword[eax],0x1e061e05
    sub eax,160
    jmp f8
    n8:
    mov dword[eax],0x00060005
    add eax,160
    mov dword[eax],0x00060005
    sub eax,160
    f8:

    add eax, 8
    add ebx, 4
    cmp ecx,9
    je s9
    cmp edx,9
    je s9
    cmp [ebp+ebx],0
    je n9
    mov dword[eax],0x1e021e01
    add eax,160
    mov dword[eax],0x1e041e03
    sub eax,160
    jmp f9
    s9:
    mov dword[eax],0x1e0c1e0b
    add eax,160
    mov dword[eax],0x1e0c1e0b
    sub eax,160
    jmp f9
    n9:
    mov dword[eax],0x000c000b
    add eax,160
    mov dword[eax],0x00060005
    sub eax,160
    f9:
   
    mov ebx,ebp
    ret

print_arrows:
    mov edx, dword[esp+4]
    mov ecx, 0xb800

    cmp dword[edx+4],0
    je al_0
    cmp dword[edx+4],3
    je al_3
    cmp dword[edx+4],6
    je al_6


    al_0:
        add ecx, 336
        mov dword[ecx],0x1e1c1e1d
        add ecx, 480
        mov dword[ecx],0x001c001d
        add ecx, 480
        mov dword[ecx],0x001c001d
        jmp sig
    al_3:
        add ecx, 336
        mov dword[ecx],0x001c001d
        add ecx, 480
        mov dword[ecx],0x1e1c1e1d
        add ecx, 480
        mov dword[ecx],0x001c001d
        jmp sig
    al_6:
        add ecx, 336
        mov dword[ecx],0x001c001d
        add ecx, 480
        mov dword[ecx],0x001c001d
        add ecx, 480
        mov dword[ecx],0x1e1c1e1d
    sig:
    sub ecx, 1294
    cmp dword[edx],1
    je au_1
    cmp dword[edx],2
    je au_2
    cmp dword[edx],3
    je au_3

    au_1:
        add ecx, 180
        mov dword[ecx],0x1e1e1e1f
        add ecx, 8
        mov dword[ecx],0x001f001e
        add ecx, 8
        mov dword[ecx],0x001c001d
        jmp fin
    au_2:
        add ecx, 180
        mov dword[ecx],0x001c001d
        add ecx, 8
        mov dword[ecx],0x1e1e1e1f
        add ecx, 8
        mov dword[ecx],0x001c001d
        jmp fin
    au_3:
        add ecx, 180
        mov dword[ecx],0x001c001d
        add ecx, 8
        mov dword[ecx],0x001c001d
        add ecx, 8
        mov dword[ecx],0x1e1e1e1f
    fin:
        ret


    delay:
        mov eax, dword [0xffff0008]
        add eax, 300
    $delay_loop:
        cmp dword [0xffff0008], eax
        jl $delay_loop
    ret


    delayl:
        mov eax, dword [0xffff0008]
        add eax, 500
    $delay_loop:
        cmp dword [0xffff0008], eax
        jl $delay_loop
    ret