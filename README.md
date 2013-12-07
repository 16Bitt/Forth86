Preface:
I like to do things myself. I've made several attempts to write a full fledged OS with nothing but assembly and my own toolchain, but this was my first success.

Prerequisites:
NASM, Ruby, Bash or Sh, and qemu if you want to test the image.

Building:
If you would like to try out a prebuilt binary, the "img" directory has you covered (disk.img is the full boot disk). Otherwise simply type:
	./build
If this doesn't work, try putting the shell of your choice (it usually looks for bash) in front of build:
	sh build
During building, you may notice something like
	LAST: lbl19
	LAST: lbl32
	LAST: lbl45
If you've added/removed any words from any of the .f files, you need to change the call in NEXT.asm to the last label print. You also need to change the code that changes LAST to start from FLBL(whatever followed lbl).

Language:
.f files are written in a mix between FORTH and a weird assembly syntax (8086). FORTH words are written between : and ; and native words are written between { and }. Spaces are necessary between every word. In the assembly, there are 4 additional words used for formatting and other hackery:
	N - Write a newline
	T - Write a tab
	NT - Write a newline and a tab
	FWORD - calls the respective word (if it's been defined)
This isn't the cleanest syntax ever, but the amount of time saved from using this to generate a FORTH dictionary far outweighs readability, in my opinion.

Layout:
	beta.rb - This parses .f files
	lexer.rb - A simple lexer for the parser
	nametable.rb - A simple LUT for the interpreter
	exec.rb - An executable frontend for beta.rb
	chain - links all respective .f files properly
	build - builds it
	testimg - runs the image in qemu
	DATA.f - data movement routines
	IO.f - printing routines
	LANG.f - dictionary routines
	MATH.f - arithmetic routines
	SYS.f - system routines
	test.f - Extra routines, plus the "main" (GO in this case) routine
	NUMBER.asm - converts a string to an integer on the stack
	HEX.asm - converts an integer to a hex string
	BOOT.asm - the bootloader
	NEXT.asm - the Assembly that is run after the bootloader runs
	HEADER.h - defines and calls used throughout the system
Please note that a lot of my ASM is _VERY_ messy

Using the System:
-Numbers are typed in 4 character hex strings, so 1 is 0001 and 255 is 00FF
-Everything is in all caps
-LIST-WORDS will list all - 1 of the words on the system
-Everything is in reverse polish notation, so 1 + 1 would be 0001 0001 + on this system
-LAST? prints the last words in the dictionary
-DISK-READ and DISK-WRITE Read and write to the disk (USE AT YOUR OWN RISK) where the high byte is the track and the low byte is the sector (0102 DISK-READ would read track 1 sector 2 to DISKBUFFER). LOAD is disk-read, but it evaluates the first line. All disk IO is handled at DISKBUFFER
-Compile time words start with a $. $IF and $THEN are examples of this.
-This system NEEDS a legacy BIOS (If you're running this on real hardware, which I wouldn't recommend)
