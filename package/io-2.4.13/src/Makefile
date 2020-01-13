all: csvexplode.oct csv2cell.oct csvconcat.oct cell2csv.oct col2num.oct num2col.oct

MKOCTFILE ?= mkoctfile
  
%.oct: %.cc
	$(MKOCTFILE) $<

clean:
	rm -f *.o octave-core core *.oct *.mex *~
