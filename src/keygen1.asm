format pe gui 4.0
include '%fasm_inc2%\win32ax.inc'
include 'fmod\#ufmod.inc'

IDD_KEYGEN = 103
IDD_MAN = 120

ID_OK = 1002
ID_QUIT = 1003
IDE_KEY = 1005

.data
wndtext db 'RZRGUY',0
wndtext2 db 'Crysis Razor1911 Keygen',0

lfont LOGFONT 14h,0ah,0,0,0,0,0,0,1,0,0,0,0,'MS Sans Serif'
hModule   dd  ?
count	  dd  ?
hBitmap   rb  72*4
hBOK  dd ?
hBQuit dd ?
hBOK2 dd ?
hBQuit2 dd ?
hBEdit dd ?
key db 'Xekep :P',0;rb 30

.code
start:
	invoke GetModuleHandleA,0
	mov [hModule],eax
	invoke DialogBoxParamA,eax,IDD_KEYGEN,HWND_DESKTOP,keygen,0
	invoke ExitProcess,0

proc keygen hwnd,msg,wparam,lparam
	invoke HideCaret,0
	cmp [msg],WM_INITDIALOG
	je .wminitdialog
	cmp [msg],WM_LBUTTONDOWN
	je .move
	cmp [msg],WM_COMMAND
	je .wmcommand
	cmp [msg],WM_DRAWITEM
	je .wmdrawitem
	cmp [msg],WM_CTLCOLOREDIT
	je .wmctlcoloredit
	xor eax,eax
	jmp .finish
     .wminitdialog:
	stdcall uFMOD_init
	invoke FindResourceA,0,134,'RT_RCDATA'
	mov esi,eax
	invoke SizeofResource,0,esi
	push XM_MEMORY
	push eax
	invoke LoadResource,0,esi
	stdcall uFMOD_PlaySong,eax
	xor edi,edi
	invoke LoadImageA,[hModule],102,edi,edi,edi,LR_CREATEDIBSECTION
	push eax
	stdcall CreateRgnFromBitmap,eax,edi
	push eax
	invoke SetWindowRgn,[hwnd],eax,1
	invoke DeleteObject
	invoke DeleteObject
	invoke LoadBitmap,[hModule],114
	mov [hBOK],eax
	invoke LoadBitmap,[hModule],115
	mov [hBQuit],eax
	invoke LoadBitmap,[hModule],116
	mov [hBOK2],eax
	invoke LoadBitmap,[hModule],117
	mov [hBQuit2],eax
	invoke LoadBitmap,[hModule],119
	mov [hBEdit],eax
	invoke SetWindowTextA,[hwnd],wndtext2
	invoke CreateFontIndirectA,lfont
	invoke SendDlgItemMessageA,[hwnd],IDE_KEY,WM_SETFONT,eax,1
	xor edi,edi
	invoke CreateThread,edi,edi,createman,edi,edi,edi
	stdcall KeyGen,key
	invoke SetDlgItemTextA,[hwnd],IDE_KEY,key
	jmp .processed
     .wmdrawitem:
	mov esi,[lparam]
	invoke CreateCompatibleDC,[esi+DRAWITEMSTRUCT.hDC]
	mov edi,eax
	mov ecx,[esi+DRAWITEMSTRUCT.CtlID]
	.if ecx=ID_OK
		test [esi+DRAWITEMSTRUCT.itemState],ODS_SELECTED
		je @f
		push [hBOK2]
		jmp .m1
		@@:
		push [hBOK]
	.elseif ecx=ID_QUIT
		test [esi+DRAWITEMSTRUCT.itemState],ODS_SELECTED
		je @f
		push [hBQuit2]
		jmp .m1
		@@:
		push [hBQuit]
	.endif
	.m1:
	invoke SelectObject,eax
	invoke BitBlt,[esi+DRAWITEMSTRUCT.hDC],0,0,[esi+DRAWITEMSTRUCT.rcItem.right],[esi+DRAWITEMSTRUCT.rcItem.bottom],edi,0,0,SRCCOPY
	invoke DeleteDC,edi
	jmp .processed
     .wmctlcoloredit:
	invoke GetDlgItem,[hwnd],IDE_KEY
	test eax,eax
	jne @f
	xor eax,eax
	jmp .finish
	@@:
	invoke SetBkMode,[wparam],TRANSPARENT
	invoke SetTextColor,[wparam],0
	invoke CreatePatternBrush,[hBEdit]
	jmp .finish
     .move:
	invoke ReleaseCapture
	invoke SendMessageA,[hwnd],WM_NCLBUTTONDOWN,2,0
	jmp .processed
     .wmcommand:
	cmp [wparam],BN_CLICKED shl 16 + ID_QUIT
	je .wmclose
	cmp [wparam],BN_CLICKED shl 16 + ID_OK
	jmp .processed
     .wmclose:
	xor edi,edi
	invoke FindWindowA,edi,wndtext
	invoke SendMessageA,eax,WM_COMMAND,10h,10h
	stdcall uFMOD_PlaySong,edi,edi,edi
	invoke EndDialog,[hwnd],0
     .processed:
	mov eax,1
     .finish:
	pop edi esi ebx
	ret
endp

proc createman param
	invoke DialogBoxParamA,[hModule],IDD_MAN,HWND_DESKTOP,man,0
	ret
endp

proc KeyGen key      ; 00403256
	ret
endp

proc CreateRgnFromBitmap bmp,Color
	local x:DWORD
	local y:DWORD
	local Rgn:DWORD
	local BMP:BITMAP
	local hDC:DWORD
	local BInfo:BITMAPINFO
	local buff:DWORD
	local region_data:DWORD

	mov [Rgn],0
	xor edi,edi
	invoke CreateCompatibleDC,edi
	cmp eax,edi
	je .exit
	mov [hDC],eax
	lea eax,[BMP]
	invoke GetObjectA,[bmp],sizeof.BITMAP,eax
	test eax,eax
	je .exit
	mov eax,[BMP.bmWidth]
	mov ebx,[BMP.bmHeight]
	mul ebx
	shl eax,2 ; eax*4
	invoke GlobalAlloc,GPTR,eax;240*4*300
	test eax,eax
	je .exit
	mov [buff],eax
	mov eax,[BMP.bmWidth]
	mov ebx,[BMP.bmHeight]
	mul ebx
	mov ebx,sizeof.RECT
	mul ebx
	add eax,sizeof.RGNDATA
	invoke GlobalAlloc,GPTR,eax
	test eax,eax
	je .exit
	mov [region_data],eax
	lea eax,[BInfo]
	invoke RtlZeroMemory,eax,sizeof.BITMAPINFO
	mov [BInfo.bmiHeader.biSize],sizeof.BITMAPINFOHEADER
	mov eax,[BMP.bmWidth]
	mov [BInfo.bmiHeader.biWidth],eax
	mov eax,[BMP.bmHeight]
	mov [BInfo.bmiHeader.biHeight],eax
	mov ax,[BMP.bmPlanes]
	mov [BInfo.bmiHeader.biPlanes],ax
	mov [BInfo.bmiHeader.biBitCount],32
	lea eax,[BInfo]
	invoke GetDIBits,[hDC],[bmp],edi,[BInfo.bmiHeader.biHeight],[buff],eax,DIB_RGB_COLORS
	mov [y],edi
	mov eax,[region_data]
	mov dword [eax+RGNDATA.rdh.dwSize],sizeof.RGNDATAHEADER
	mov dword [eax+RGNDATA.rdh.iType],RDH_RECTANGLES
	mov dword [eax+RGNDATA.rdh.nCount],edi
	mov dword [eax+RGNDATA.rdh.rcBound.left],edi
	mov dword [eax+RGNDATA.rdh.rcBound.top],edi
	mov dword [eax+RGNDATA.rdh.rcBound.right],edi
	mov dword [eax+RGNDATA.rdh.rcBound.bottom],edi
	mov ecx,[BMP.bmHeight]
       .m1:
	mov [x],0;edi
	push ecx
	mov ecx,[BMP.bmWidth]
      .m2:
	push ecx
	mov ecx,[x]
	shl ecx,2
	add ecx,[buff]
	mov eax,[BMP.bmWidth];240*4
	shl eax,2 ; eax*4
	mov ebx,[BMP.bmHeight]
	sub ebx,[y]
	dec ebx
	mul ebx
	add ecx,eax
	mov eax,[Color]
	.if eax<>dword [ecx]
		mov edx,[region_data]
		mov eax,dword [edx+RGNDATA.rdh.nCount]
		shl eax,sizeof.RECT/4
		lea eax,[edx+RGNDATA.buffer+eax]
		mov ebx,[x]
		mov [eax+RECT.left],ebx
		mov ebx,[y]
		mov [eax+RECT.top],ebx
		mov ebx,[Color]
		add ecx,4
		mov edi,[BMP.bmWidth]
		sub edi,[x]
		@@:
		cmp dword [ecx],ebx
		je @f
		test edi,edi
		je @f
		dec edi
		dec edi
		add ecx,4
		inc [x]
		jmp @b
		@@:
		mov ebx,[x]
		inc ebx
		mov [eax+RECT.right],ebx
		mov ebx,[y]
		inc ebx
		mov [eax+RECT.bottom],ebx
		inc dword [edx+RGNDATA.rdh.nCount]
	.endif
	inc [x]
	pop ecx
	loop .m2
	inc [y]
	pop ecx
	loop .m1
	mov ebx,[region_data]
	mov eax,dword [ebx+RGNDATA.rdh.nCount]
	shl eax,sizeof.RECT/4
	mov dword [ebx+RGNDATA.rdh.nRgnSize],eax
	add eax,sizeof.RGNDATA
	invoke ExtCreateRegion,0,eax,ebx
	mov [Rgn],eax
	invoke DeleteDC,[hDC]
	invoke GlobalFree,[buff]
	invoke GlobalFree,[region_data]
     .exit:
	mov eax,[Rgn]
	ret
endp

include 'man.asm'

.end start
section '.res' data readable resource from '1.res'