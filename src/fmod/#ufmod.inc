XM_RESOURCE = 0
XM_MEMORY   = 1
XM_FILE     = 2

; The uFMOD_PlaySong function starts playing an XM song
; --------------
; HWAVEOUT* uFMOD_PlaySong(
;   LPVOID lpXM,
;   DWORD  param,
;   DWORD  fdwSong
; );
; Parameters:
;   lpXM
;      Specifies the song to play. If this parameter is NULL,
;      any currently playing song is stopped. In such a case, function
;      does not return a meaningful value
;      fdwSong parameter determines whether this value is interpreted
;      as a filename, as a resource identifier or a pointer to an image
;      of the song in memory
;   param
;      Handle to the executable file that contains the resource to be
;      loaded or size of the image of the song in memory. This parameter
;      is ignored unless XM_RESOURCE or XM_MEMORY is specified in fdwSong
;   fdwSong
;      Flags for playing the song. The following values are defined
;      Value        Meaning
;      XM_FILE      lpXM points to filename
;                   param is ignored
;      XM_MEMORY    lpXM points to an image of a song in memory
;                   param is the image size
;      XM_RESOURCE  lpXM Specifies the name of the resource
;                   param identifies the module whose executable file
;                   contains the resource
;                   The resource type must be RT_RCDATA
; Return Values:
;    Returns a pointer to HWAVEOUT on success or NULL otherwise
uFMOD_PlaySong = ufmod_dump + 51h

; The uFMOD_GetOrder function returns the song's current order number
; --------------
; unsigned char uFMOD_GetOrder();
; Return Values:
;    Returns the song's current order number
uFMOD_GetOrder = ufmod_dump + 1011h

; The uFMOD_GetRow function returns the song's current row number
; --------------
; unsigned char uFMOD_GetRow();
; Return Values:
;    Returns the song's current row number
uFMOD_GetRow   = ufmod_dump + 1015h

; The uFMOD_GetTime function returns the time in milliseconds since the
; song was started. This is useful for synchronizing purposes.
; upon starting the song
; --------------
; unsigned int uFMOD_GetTime();
; Return Values:
;    Returns the time in milliseconds since the song was started
uFMOD_GetTime  = ufmod_dump + 1019h

; Feel free to rename this section,
; but don't modify anything else :-)
; Do not remove W and E attributes!
; Must be at 0x00401000!
section '.data2' data readable writeable executable
;##################################################
;#            Modifed by CyberDoom Systems        #
;##################################################
_uFMOD_import_1:
@_CloseHandle	     dd 0
@_CreateThread	     dd 0
@_SetThreadPriority  dd 0
@_LocalFree	     dd 0
@_Sleep 	     dd 0
@__lopen	     dd 0
@__lclose	     dd 0
@__lread	     dd 0
@__llseek	     dd 0
@_FindResourceA      dd 0
@_LoadResource	     dd 0
@_SizeofResource     dd 0
@_LocalAlloc	     dd 0
   dd 0

_uFMOD_import_2:
@_waveOutGetPosition	  dd 0
@_waveOutOpen		  dd 0
@_waveOutPrepareHeader	  dd 0
@_waveOutReset		  dd 0
@_waveOutUnprepareHeader  dd 0
@_waveOutWrite		  dd 0
@_waveOutClose		  dd 0
   dd 0

   dd 0,0,0,0,0

ufmod_dump file 'ufmod.bin'
   jmp [@_LocalAlloc]

align 4
_uFMOD_lookup_1:
   dd  @_CloseHandle
   dd  @_CreateThread
   dd  @_SetThreadPriority
   dd  @_LocalFree
   dd  @_Sleep
   dd  @__lopen
   dd  @__lclose
   dd  @__lread
   dd  @__llseek
   dd  @_FindResourceA
   dd  @_LoadResource
   dd  @_SizeofResource
   dd  @_LocalAlloc
   dd 0

_uFMOD_lookup_2:
   dd  @_waveOutGetPosition
   dd  @_waveOutOpen
   dd  @_waveOutPrepareHeader
   dd  @_waveOutReset
   dd  @_waveOutUnprepareHeader
   dd  @_waveOutWrite
   dd  @_waveOutClose
   dd 0

proc uFMOD_init
pushad
invoke LoadLibrary,k32
mov    ebx,eax
mov    edi,k_proc
mov    esi,_uFMOD_import_1
call  _L00p

invoke LoadLibrary,wm
mov    ebx,eax
mov    edi,w_proc
mov    esi,_uFMOD_import_2
call  _L00p

popad
ret

endp


_L00p:
    invoke GetProcAddress,ebx,edi
    mov [esi],eax
    add esi,4
	xor	al,al
	scasb
	jnz	$-1
	cmp   dword  [edi],0xffffffff	     ; End of array? 
	jnz	_L00p	   
    ret




k32 db 'KERNEL32.DLL',0
k_proc:
   db 'CloseHandle',0
   db 'CreateThread',0
   db 'SetThreadPriority',0
   db 'LocalFree',0
   db 'Sleep',0
   db '_lopen',0
   db '_lclose',0
   db '_lread',0
   db '_llseek',0
   db 'FindResourceA',0
   db 'LoadResource',0
   db 'SizeofResource',0
   db 'LocalAlloc',0
   db 'GetProcAddress',0
   dd 0xffffffff


wm db 'WINMM.DLL',0
w_proc:
   db 'waveOutGetPosition',0
   db 'waveOutOpen',0
   db 'waveOutPrepareHeader',0
   db 'waveOutReset',0
   db 'waveOutUnprepareHeader',0
   db 'waveOutWrite',0
   db 'waveOutClose',0
   dd 0xffffffff
; The BSS:
bss_start:
   rb 10A6D1h