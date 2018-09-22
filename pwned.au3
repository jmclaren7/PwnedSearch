#NoTrayIcon
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Change2CUI=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <FileConstants.au3>
#include <Crypt.au3>
Opt("TrayIconHide", 1)

; This is a test script of a way to do a binary search on a large file, specificly made for the file of sha1 hashes (hash ordered) provided by https://haveibeenpwned.com/Passwords
; The loop below provides an input to enter a password that will then be hashed and passed to the main function _FileBinarySearch where it will check pwned.txt for the hash
; You can also leave the input blank to loop through a set of test data which by default will check testdata.txt


$Message = ""
While 1

	$SearchText = InputBox("Pwned File Search",$Message&@CRLF&@CRLF&"What do you want to search for?"&@CRLF&"Leave blank for test data"&@CRLF&"Returns file pointer if found","")
	$Message = ""
	If @error Then
		Exitloop
	endif

	If $SearchText = "" Then ;loop through $TestSamples[] and do a search for each
		ConsoleWrite(@CRLF&"Testing")

		;Local $TestSamples = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "0", "11"]
		;$sFilePath = "testdata.txt"

		Local $TestSamples = ["passwd1", "passwd1234", "123456", "1234567", "12345678", "safdsadg3423547fgjh45", "sddsj439j23hkjh3gh4KJH3", "sdfsdkjh38saklj1jh7jdh"]
		$sFilePath = "pwned.txt"

		$Timer = TimerInit()
		For $i = 0 To  UBound($TestSamples)-1
			$Message = $Message & _FileBinarySearch($sFilePath, StringTrimLeft(_Crypt_HashData($TestSamples[$i], $CALG_SHA1),2)) & ","
		next
		$Message = $Message & @CRLF & TimerDiff($Timer)


	Else ;use the provided text and do a search
		$Message = _FileBinarySearch("pwned.txt", StringTrimLeft(_Crypt_HashData($SearchText, $CALG_SHA1),2))

	EndIf

Wend



Func _FileBinarySearch($sFilePath, $Search, $Delimiter = @CRLF)
	Local $Size = FileGetSize($sFilePath)
	Local $hFileOpen = FileOpen($sFilePath, $FO_READ)
	Local $RangeStart = 0
	Local $RangeEnd = $Size
	Local $EstimatedSearchSize = StringLen($Search) + StringLen($Delimiter) + 4
	Local $FileReadSize = $EstimatedSearchSize*2
	Local $Iterations = 1
	Local $IterationsLimit = Floor(Log($Size) / Log(2)) ;the maximum expected difficulty to search the given data
	Local $Return = False

	;ConsoleWrite(@CRLF&@CRLF&"Search: "&$Search&" ReadSize: "&$FileReadSize&" IterationsLimit: "&$IterationsLimit)
	while 1
		;Get pointer position for middle of given range offset by our read size
		$PointerPos = Floor(($RangeEnd - $RangeStart) / 2 + $RangeStart - ($FileReadSize / 2))
		If $PointerPos < 0 Then $PointerPos = 0

		;Read the file
		FileSetPos ($hFileOpen, $PointerPos, 0)
		$Data = FileRead ($hFileOpen,$FileReadSize)
		If @extended < $FileReadSize Then $Data = $Data&$Delimiter ;end of file? add delimiter to make it easy
		If $PointerPos = 0 Then $Data = $Delimiter&$Data ;start of file? add delimiter to make it easy

		;ConsoleWrite(@CRLF&@CRLF&"Raw Read: "&StringReplace(StringReplace($Data,@LF,"@"),@CR,"%"))

		;Clean up the data we read
		; an issue will arise in other sets of data with variable length where the data read might not contain delimiters
		$DataStart = StringInStr($Data,@CRLF) + StringLen($Delimiter)
		$Data = StringMid($Data, $DataStart, StringInStr($Data, $Delimiter, 0, 2) - $DataStart)

		;Update pointer pos with precise start point of the data we are comparing
		$PointerPos = $PointerPos + $DataStart

		;ConsoleWrite(@CRLF&"Data: "&$Data&" Range: "&$RangeStart&"/"&$RangeEnd&" Pointer: "&$PointerPos&" Iterations: "&$Iterations)

		If StringInStr($Data, $Search) Then ;found the string string
			ConsoleWrite(@CRLF&"Match Found At "&$PointerPos)
			$Return = $PointerPos
			Exitloop

		ElseIf $RangeEnd - $RangeStart < $EstimatedSearchSize Then ;nothing left to search
			ConsoleWrite(@CRLF&"No Match")
			Exitloop

		ElseIf $Iterations > $IterationsLimit Then ;exceeded the expected difficulty
			ConsoleWrite(@CRLF&" Error With Too Many Iterations")
			SetError(1)
			Exitloop

		ElseIf $Data < $Search Then ;the found string is lesser
			;ConsoleWrite(" Result: Under")
			$RangeStart = $PointerPos + StringLen($Data)

		ElseIf $Data > $Search Then ;the found string is greater
			;ConsoleWrite(" Result: Over")
			$RangeEnd = $PointerPos

		EndIf

		$Iterations += 1
	WEnd

	FileClose($hFileOpen)
	Return $Return
EndFunc