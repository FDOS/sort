# Minimal Makefile for SORT

all: sort.exe
# can be sort.com for tiny model - but then limited to < 32k file size.
# .com is about 4.5k upxed, .exe about 5.7k ... full sizes: 6.9k / 9.3k

UPX=upx --8086
# if you don't want to use UPX set
#     UPX=-rem (DOS)
#   or
#     UPX=true (Unix)
# if you use UPX: then options are
#     --8086 for 8086 compatibility
#   or
#     --best for smallest

sort.exe sort.com: sort.c ../kitten/kitten.c
	$(CC) $(CFLAGS)sort $^
	$(UPX) $@

clean:
	$(RM) sort.exe
	$(RM) sort.com
	$(RM) *.o
	$(RM) *.obj
