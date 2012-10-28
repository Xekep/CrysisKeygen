proc man hwnd,msg,wparam,lparam
	local rect:RECT
	cmp [msg],WM_INITDIALOG
	je .wminitdialog
	cmp [msg],WM_LBUTTONDOWN
	je .move
	cmp [msg],WM_PAINT
	je .wmpaint
	cmp [msg],WM_COMMAND
	je .wmcommand
	xor eax,eax
	jmp .finish
    .wminitdialog:
	invoke GetSystemMetrics,SM_CXSCREEN
	mov esi,eax
	invoke GetSystemMetrics,SM_CYSCREEN
	mov edi,eax
	lea eax,[rect]
	invoke GetClientRect,[hwnd],eax
	sub esi,[rect.right]
	shr esi,1
	sub edi,[rect.bottom]
	sar edi,1
	sub edi,0ffh
	sub esi,0ah
	invoke SetWindowPos,[hwnd],HWND_TOPMOST,esi,edi,0,0,SWP_NOSIZE
	invoke LoadImageA,[hModule],2000,0,0,0,LR_CREATEDIBSECTION
	stdcall CreateRgnFromBitmap,eax,0FB02EBh
	push eax
	invoke SetWindowRgn,[hwnd],eax,1
	invoke DeleteObject
	xor ebx,ebx
	invoke CreateThread,ebx,ebx,img,[hwnd],ebx,ebx
	invoke CloseHandle,eax
	invoke HideCaret,ebx
	invoke SetWindowTextA,[hwnd],wndtext
	jmp .processed
    .wmpaint:
	invoke GetDlgItem,[hwnd],1007
	mov ecx,[count]
	invoke SendMessageA,eax,STM_SETIMAGE,0,dword [ecx*4+hBitmap]
	xor eax,eax
	jmp .finish
    .move:
	invoke ReleaseCapture
	invoke SendMessageA,[hwnd],WM_NCLBUTTONDOWN,2,0
	jmp .processed
    .wmcommand:
	.if [wparam]<>10h  & [lparam]<>10h
		jmp .processed
	.endif
    .wmclose:
	invoke EndDialog,[hwnd],edi
    .processed:
	mov eax,1
    .finish:
	ret
endp

proc img hwnd
	local hdc:DWORD
	local hMemDC:DWORD

	xor esi,esi
	@@:
	lea eax,[esi+2000]
	invoke LoadImageA,[hModule],eax,0,0,0,LR_CREATEDIBSECTION
	mov dword [hBitmap+esi*4],eax
	inc esi
	cmp esi,71
	jle @b
	xor esi,esi
	@@:
	mov [count],esi
	stdcall CreateRgnFromBitmap,dword [hBitmap+esi*4],0FB02EBh
	test eax,eax
	je .m1
	push eax
	invoke SetWindowRgn,[hwnd],eax,1
	invoke DeleteObject
	.m1:
	invoke Sleep,50
	inc esi
	cmp esi,71
	jle @b
	jmp @b-2
endp