all: primesieve.bin

clean:
	rm primesieve.bin

.PHONY: all clean


primesieve.bin: primesieve.s utils/print.s utils/via.s
	xa -o $@ $< -M

