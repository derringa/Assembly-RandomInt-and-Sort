TITLE Random Number Generator and Sorter     (Project5_Derringer_Andrew.asm)

; Author: Andrew Derringer
; Last Modified: 3/4/2019
; OSU email address: derringa@oregonstate.edu
; Course number/section: CS 271 - 400
; Project Number: 5                 Due Date: 3/3/2019 + 1 Grace Day = 2/4/2019
; Description: This program practices passing parameters by both value and reference.
; The use is asked for their name and greeted, and then asked to pick a length of a list
; of randomly generated numbers within a range of global constants. A procedure randomly
; generates the list followed by procedures that print the list, sort the list in
; descending order, and find and print the median of the ordered list.

INCLUDE Irvine32.inc

;---------------------------------------;
; Constants                             ;
;---------------------------------------;

MIN EQU <10>												; Constant for lowest integer input accepted from user
MAX EQU <200>												; Constant for highest integer input accepted from user
LO EQU <100>												; Lowest range of random number generator
HI EQU <999>												; Highest range of random number generator
NEWLINE EQU <10>											; Max number of outputs per line in a loop



.data

;---------------------------------------;
; User input data                       ;
;---------------------------------------;

inputNumber				DWORD		?						; Holds integer input for number of random numbers to be generated
inputName				BYTE		50	DUP(0)				; String variable holding user input when prompted for their name



;---------------------------------------;
; Randomly generated Array              ;
;---------------------------------------;

randomArray				DWORD		200	DUP(?)				; Array the user's preferred size randomly generated with integers



;---------------------------------------;
; Title page output, greeting, farewell ;
;---------------------------------------;

programTitle			BYTE		"Random Number Generator and Sorter with MASM", 0
programAuthor			BYTE		"by: Andrew Derringer", 0

greeting				BYTE		"Welcome and thank you for using the Random Number Generator and Sorter.", 0
requestName				BYTE		"Please enter your name: ", 0
hello					BYTE		"Hello ", 0
goodbye					BYTE		"And there you have it. Have a good day ", 0



;---------------------------------------;
; Request input and data validation     ;
;---------------------------------------;

outputTransition		BYTE		"Lets get started.", 0
requestNumber			BYTE		"Please enter how many random numbers should be generated between 10 and 200: ", 0

maxError				BYTE		"Your number was too big. Try again:", 0
minError				BYTE		"Your number was too small. Try again:", 0



;---------------------------------------;
; Output formatting                     ;
;---------------------------------------;

randomList				BYTE		"Random List: ", 0
sortedList				BYTE		"Sorted List: ", 0
medianList				BYTE		"Median: ", 0
tripleSpace				BYTE		"   ", 0
exclamation				BYTE		"!", 0


.code

;---------------------------------------------------------------------;
; Procedure: Main                                                     ;
; Description:                                                        ;
;---------------------------------------------------------------------;

main PROC
	push	OFFSET programTitle				; Introduce program
	push	OFFSET programAuthor
	push	OFFSET greeting
	call	introduction

	push	OFFSET requestName				; Request user's name
	push	OFFSET hello
	push	OFFSET exclamation
	push	OFFSET inputName
	call	getName

	push	OFFSET requestNumber			; Request a number for input
	push	OFFSET minError
	push	OFFSET maxError
	push	OFFSET inputNumber
	call	getNumber

	push	OFFSET randomArray				; Randomly populate array of integers
	push	inputNumber
	call	randPopArray

	push	OFFSET randomList				; Print array of integers
	push	OFFSET randomArray
	push	inputNumber
	push	OFFSET tripleSpace
	call	printArray

	push	OFFSET randomArray				; Sort array of integers
	push	inputNumber
	call	sortArray

	push	OFFSET medianList				; Print median of sorted array
	push	OFFSET randomArray
	push	inputNumber
	call	getMedian

	push	OFFSET sortedList				; Print now sorted Array of integers
	push	OFFSET randomArray
	push	inputNumber
	push	OFFSET tripleSpace
	call	printArray

	push	OFFSET goodbye					; Print goodbye
	call	farewell

	exit	; exit to operating system
main ENDP



;---------------------------------------------------------------------;
; Procedure: Introduction                                             ;
; Passed: string programTitle, string programAuthor, string greeting. ;
; Returned:                                                           ;
; Description: Prints introduction text for program.                  ;
;---------------------------------------------------------------------;

introduction PROC
	push	ebp								; Preserve return address
	mov		ebp, esp

	mov		edx, [ebp+16]					; Print programTitle
	call	WriteString
	call	CrLf
	call	CrLf

	mov		edx, [ebp+12]					; Print programAuthor
	call	WriteString
	call	CrLf
	call	CrLf

	mov		edx, [ebp+8]					; Print greeting
	call	WriteString
	call	CrLf
	call	CrLf

	pop		ebp								; Acquire return address
	ret		12								; Clear remaining stack
introduction ENDP



;---------------------------------------------------------------------;
; Procedure: Get Name                                                 ;
; Passed: string requestName, string hello, string exclamation        ;
;		  string pointer inputName.                                   ;
; Returned: string inputName.                                         ;
; Description: Requests and stores the user's name.                   ;
;---------------------------------------------------------------------;

getName PROC
	push	ebp								; Preserve return@
	mov		ebp, esp

	mov		edx, [ebp+20]					; Print requestName
	call	WriteString

	mov		edx, [ebp+8]					; Place inputName@ in edx
	mov		ecx, 49
	call	ReadString                      ; Read input string and store at address in edx = inputName
	call	CrLf

	mov		edx, [ebp+16]					; Print hello followed by...
	call	WriteString
	mov		edx, [ebp+8]					; Print inputName followed by...
	call	WriteString
	mov		edx, [ebp+12]					; Print exclamation
	call	WriteString
	call	CrLf
	call	CrLf

	pop		ebp								; Acquire return@
	ret		16								; Clear remaining stack
getName ENDP



;---------------------------------------------------------------------;
; Procedure: Get Number                                               ;
; Passed: string requestNumber, string minError, string maxError,     ;
;		  int pointer inputNumber.                                    ;
; Returned: int inputNumber.                                          ;
; Description: Requests and stores desired numbers to generate.       ;
;---------------------------------------------------------------------;

getNumber PROC
	push	ebp								; Preserve return@
	mov		ebp, esp

	mov		edx, [ebp+20]					; Print requestNumber
	call	WriteString

CheckMin:
	call	ReadInt
	call	CrLf
	cmp		eax, MIN						; Compare input to MIN
	jge		short CheckMax					; Jump to CheckMax if >MIN
	mov		edx, [ebp+16]					; Print errorMin
	call	WriteString
	jmp		short CheckMin					; Jump to CheckMin

CheckMax:
	cmp		eax, MAX						; Compare input to MAX
	jle		short InputDone					; Jump to InputDone if <Max
	mov		edx, [ebp+12]					; Print errorMax
	call	WriteString
	jmp		short CheckMin					; Jump to CheckMin

InputDone:
	mov		ebx, [ebp+8]					; Place inputNumber@ in ebx
	mov		[ebx], eax						; Place eax at address in ebx
	call	CrLf

	pop		ebp								; Acquire return@
	ret		16								; Clear remaining stack
getNumber ENDP



;---------------------------------------------------------------------;
; Procedure: Randomly Populate Array                                  ;
; Passed: int pointer array, int inputNumber(array size).             ;
; Returned: Nothing.                                                  ;
; Description: Uses LO and HI global constants to generate random int ;
;			   for each array index within range.		              ;
;---------------------------------------------------------------------;

randPopArray PROC
	push	ebp								; Preserve return@
	mov		ebp, esp

	mov		esi, [ebp+12]					; Place array@ in esi
	mov		ebx, 0							; Set index number
	mov		ecx, [ebp+8]					; Place loop count = array length = inputNumber

Iteration:
	mov		eax, HI
	sub		eax, LO
	inc		eax
	call	RandomRange						; Generate random int
	add		eax, LO

	mov		[esi+ebx], eax					; Place random int in array
	add		ebx, 4
	loop	Iteration

	pop		ebp								; Acquire return@
	ret		8								; Clear remaining stack
randPopArray ENDP



;---------------------------------------------------------------------;
; Procedure: Print Array                                              ;
; Passed: string title, int ptr array, int inputNumber,               ;
;         string triplespace.                                         ;
; Returned: Nothing                                                   ;
; Description: Prints array values.                                   ;
;---------------------------------------------------------------------;

printArray PROC
	push	ebp								; Preserve return@
	mov		ebp, esp

	mov		edx, [ebp+20]					; Print list title
	call	WriteString
	call	CrLf

	mov		esi, [ebp+16]					; Place array@ in esi
	mov		ebx, 0							; Set index number
	mov		edi, 0							; Set Newline counter
	mov		ecx, [ebp+12]					; Place loop count = array length = inputNumber

PrintNumber:
	mov		eax, [esi+ebx]					; Print array element
	call	WriteInt
	mov		edx, [ebp+8]					; Print tripleSpace
	call	WriteString

	add		ebx, 4							; Increment index
	inc		edi								; Increment newline count

	cmp		edi, NEWLINE					; If newline = 10
	jne		NoNewline
	call	CrLf							; Print Newline
	mov		edi, 0
NoNewline:
	loop	PrintNumber
	call	CrLf
	call	CrLf

	pop		ebp								; Acquire return@
	ret		16								; Clear remaining stack
printArray ENDP



;---------------------------------------------------------------------;
; Procedure: Sort Array                                               ;
; Passed: int ptr array, int inputNumber, string triplespace.         ;
; Returned: Nothing                                                   ;
; Description: Prints array values.                                   ;
;---------------------------------------------------------------------;

sortArray PROC
	push	ebp								; Preserve return@
	mov		ebp, esp

	mov		esi, [ebp+12]					; Place array@ in esi
	mov		edx, 0							; Set destination index number
	mov		ebx, 4							; Set search index number
	mov		ecx, [ebp+8]					; Place loop count = array length = inputNumber
	dec		ecx

Destination:
	push	ecx								; Preserve counter for outer loop
	push	ebx								; Preserve starting location of search for next outer loop iteration
Search:
	mov		edi, [esi+edx]					; Place both values of interest into registers for comparison
	mov		eax, [esi+ebx]
	cmp		edi, eax
	jge		NoChange						; Jump if Index of interest is already greater else swap
	mov		[esi+edx], eax
	mov		[esi+ebx], edi
NoChange:
	add		ebx, 4							; Increment comparison index for next innter loop iteration
	loop	Search

	pop		ebx								; Return outer loop initial target index value
	pop		ecx								; Return outer loop counter
	add		edx, 4							; Increment index of interest
	add		ebx, 4							; Increment starting target index for next loop
	loop	Destination

	pop		ebp								; Acquire return@
	ret		12								; Clear remaining stack
sortArray ENDP



;---------------------------------------------------------------------;
; Procedure: Get Median                                               ;
; Passed: string, title, int ptr array, int inputNumber.              ;
; Returned: Nothing                                                   ;
; Description: Prints value of array median.                          ;
;---------------------------------------------------------------------;

getMedian PROC
	push	ebp								; Preserve return@
	mov		ebp, esp

	mov		edx, [ebp+16]
	call	WriteString
	call	CrLf

	mov		esi, [ebp+12]					; Place array@ in esi
	mov		edx, 0							; Clear register for divison
	mov		eax, [ebp+8]
	mov		ebx, 2							; For division
	mov		ecx, 4							; For multiplication to desired array index
	div		ebx								; Divide length by 2 to check if even

	cmp		edx, 0							; Jump to EvenNumber if no remainder
	je		EvenNumber
	mul		ecx								; Multiply quotient by 4 for desired index
	mov		edi, [esi+eax]
	mov		eax, edi						; Print Median Index
	call	WriteInt
	jmp		short MedianDone

EvenNumber:							
	mul		ecx								; Multiply quotient by 4 for desired index
	mov		edi, [esi+eax]
	sub		eax, 4							; Get other middle index and add them
	add		edi, [esi+eax]
	mov		eax, edi
	div		ebx								; Divide their sum by 2 and Print
	call	WriteInt

MedianDone:
	call	CrLf
	call	CrLf

	pop		ebp								; Acquire return@
	ret		12								; Clear remaining stack
getMedian ENDP



;---------------------------------------------------------------------;
; Procedure: Farewell                                                 ;
; Passed: string goodbye.                                             ;
; Returned: Nothing                                                   ;
; Description: Prints departing message.                              ;
;---------------------------------------------------------------------;

getMedian PROC
	push	ebp								; Preserve return@
	mov		ebp, esp

	mov		edx, [ebp+8]					; Print goodbye
	call	WriteString
	call	CrLf
	call	CrLf

	pop		ebp								; Acquire return@
	ret		12								; Clear remaining stack
getMedian ENDP
END main
