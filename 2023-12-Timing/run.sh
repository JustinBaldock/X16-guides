# point to current location of x16 emulator
# -prg = point to program to run
# -debug = turn on debugger, to see press F12 to display, press F5 to continue
# -scale 2 = run emulator double sized
cp timing-demo.prg ../../x16emu_linux-x86_64-r46/TIMING-DEMO.PRG
cd ../../x16emu_linux-x86_64-r46/
./x16emu -prg TIMING-DEMO.PRG -debug -scale 2 -rtc