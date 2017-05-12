CC=gcc
GPP=g++
CPPFLAGS=-Wall -std=c++11 -msse4.1 -O3 -g -pg

ODIR=obj
BINDIR=bin

LIBS=-lm -lprotobuf -lz 

DEPS = gssw.h vg.pb.h fastqloader.h GraphAligner.h SubgraphFromSeed.h TopologicalSort.h vg.pb.h

_OBJ = GsswWrapper.o vg.pb.o fastqloader.o TopologicalSort.o SubgraphFromSeed.o
OBJ = $(patsubst %, $(ODIR)/%, $(_OBJ))

$(ODIR)/%.o: %.cpp $(DEPS)
	$(GPP) -c -o $@ $< $(CPPFLAGS)

$(BINDIR)/wrapper: $(OBJ)
	$(GPP) -o $@ $^ $(CPPFLAGS) -Wl,-Bstatic $(LIBS) -Wl,-Bdynamic -Wl,--as-needed -lpthread -pthread -static-libstdc++

$(BINDIR)/ReadIndexToId: $(OBJ)
	$(GPP) -o $@ ReadIndexToId.cpp $(ODIR)/vg.pb.o $(ODIR)/fastqloader.o $(CPPFLAGS) -Wl,-Bstatic $(LIBS) -Wl,-Bdynamic -Wl,--as-needed

all: $(BINDIR)/wrapper $(BINDIR)/ReadIndexToId

clean:
	rm -f $(ODIR)/*
	rm -f $(BINDIR)/*