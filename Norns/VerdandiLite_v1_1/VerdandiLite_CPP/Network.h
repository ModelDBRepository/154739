#ifndef NETWORK_H
#define NETWORK_H

#include "vector"
#include "queue"
#include "fstream"

#include "Basics.h"
//#include "Cells.h"
//#include "Synapses.h"


class Neuron;
class Synapse;

struct Connection {
	double Weight, Delay;
	Synapse* Target;

	void ReadFromFile(std::ifstream*);
};

struct SpikeEvent {
	double Time;
	Gid Source;

	SpikeEvent(double t, Gid id) {
		Time = t;
		Source = id;
	};
};

struct Population {
	int TypeID, nNeuron;
	Neuron** NeuronList;
	
	Population(int t, int n) {
		TypeID = t;
		nNeuron = n;
	};
};

struct Connectivity {
	int TypeID, TargetPopulation;
	
	Connectivity(int t, int p) {
		TypeID = t;
		TargetPopulation = p;
	};
};

class Network {
	friend class Neuron;
	friend class Synapse;
	friend class Connection;

	private:
		static std::vector<Population> Populations;
		static std::vector<Connectivity> Connectivities;

		static std::vector<Neuron*> NeuronList;
		static int AddNeuron(Neuron*);

		static std::vector<Synapse*> SynapseList;
		static int AddSynapse(Synapse*);

		static int* nConnectionPerCell;
		static Connection** ConnectionList;

		static std::queue<SpikeEvent> SpikeQueue;

		static std::ofstream* fOutVm;
		static std::ofstream* fOutSpikes;

	public:
		static void ReadCells(std::ifstream*);
		static void ReadSynapses(std::ifstream*);
		static void ReadConnections(std::ifstream*);

		static void AddSpike(Gid);
		static void DistributeSpike();	

		static void SetOutVm(std::ofstream* f) {fOutVm = f;};
		static void SetOutSpikes(std::ofstream* f) {fOutSpikes = f;};
		static void PrintVm();

};

#endif
