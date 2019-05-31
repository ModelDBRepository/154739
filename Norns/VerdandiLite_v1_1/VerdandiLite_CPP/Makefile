
BASEDIR = `pwd`
#NSDIR = $(BASEDIR)/NS
#SADIR = $(BASEDIR)/SA

INCLUDES = -I.

#CXX = CC
CXX = g++
#CXX = mpicxx
#CXX = scmpicxx

#MPI_LIB = -lscmpi
#CXXFLAGS = $(INCLUDES) $(OPENMP_FLAG) -O2
CXXFLAGS = $(INCLUDES)

.SUFFIXES: .cpp

.cpp.o:
	$(CXX) $(CXXFLAGS) -c $<

.cpp:
	$(CXX) $(CXXFLAGS) $< -o $@

#TEST1_SRC = APGenerator.cpp Channel.cpp Compartment.cpp \
			SynapticNetwork.cpp conn.cpp test.cpp 

#TEST1_OBJ = $(addsuffix .o, $(basename $(TEST1_SRC)))

#TEST2_SRC = APGenerator.cpp Channel.cpp Compartment.cpp \
			NetworkConnection.cpp SynapticNetwork.cpp conn.cpp test2.cpp 

#TEST2_OBJ = $(addsuffix .o, $(basename $(TEST2_SRC)))

#ns_test: $(TEST2_OBJ)
#	$(CXX) $(CXXFLAGS) -o $@ $(TEST2_OBJ)

SRC = Basics.cpp Cells.cpp Synapses.cpp Network.cpp Simulator.cpp

OBJ = $(addsuffix .o, $(basename $(SRC)))

SimulatorCPP: $(OBJ)
	$(CXX) $(CXXFLAGS) -o $@ $(OBJ)

#	rm -f ns Data
#	ln -s ../NS/ns
#	ln -s ../NS/Data
#	ln -s NS/ns
#	ln -s NS/Data

clean:
	rm -f $(OBJ) 

