#include "Network.h"

#include <iostream>

#include "Basics.h"
#include "Cells.h"
#include "Synapses.h"


#define DEBUG_INPUT 0
#define DEBUG_RUN 0

using namespace std;

void Connection::ReadFromFile(ifstream* fList) {
	int TargetID;	
	*fList >> TargetID;
	*fList >> Delay;
	*fList >> Weight;

	Target = Network::SynapseList[TargetID];

	#if DEBUG_INPUT > 4
	cout << "              Reading connection from file: target " << TargetID << " ("<< Target<<"), delay " << Delay << ", w " << Weight << endl;
	#endif
	

}

vector<Population> Network::Populations;
vector<Connectivity> Network::Connectivities;

vector<Neuron*> Network::NeuronList;
vector<Synapse*> Network::SynapseList;

int* Network::nConnectionPerCell = NULL;
Connection** Network::ConnectionList = NULL;

queue<SpikeEvent> Network::SpikeQueue;

ofstream* Network::fOutVm = NULL;
ofstream* Network::fOutSpikes = NULL;

int Network::AddNeuron(Neuron* n) {
	int id = NeuronList.size();
	NeuronList.push_back(n);
	return id;
}

int Network::AddSynapse(Synapse* s) {
	int id = SynapseList.size();
	SynapseList.push_back(s);
	#if DEBUG_INPUT > 3
	cout << "    Synapse added: " << s << endl;
	#endif
	return id;
}

void Network::ReadCells(ifstream* fCell) {
	// Make outline of the neurons:
	#if DEBUG_INPUT > 0
	cout << "Reading cell outline" << endl;
	#endif
	int nPopulation;
	*fCell >> nPopulation;
	for(int iPopulation=0;iPopulation<nPopulation;iPopulation++) {
		int t, n;
		*fCell >> t;
		*fCell >> n;
		Populations.push_back(Population(t,n));
		#if DEBUG_INPUT > 1
		cout << "Population " << iPopulation << " contains " << n << " cells of type " << t << endl;
		#endif
	}

	#if DEBUG_INPUT > 0
	cout << "Making cells" << endl;
	#endif
	// Make cells
	for(int iPopulation=0;iPopulation<nPopulation;iPopulation++) {
		int nNew = Populations[iPopulation].nNeuron;
		Populations[iPopulation].NeuronList = new Neuron*[nNew];
		// Make neurons one-by-one and assign to list:
		switch(Populations[iPopulation].TypeID) {
			case TYPE_LIF:
				for(int iNew=0; iNew<nNew; iNew++) Populations[iPopulation].NeuronList[iNew] = new NeuronTypeLIF;
				break;
			case TYPE_IZHIKEVICH:
				for(int iNew=0; iNew<nNew; iNew++) Populations[iPopulation].NeuronList[iNew] = new NeuronTypeIzhikevich;
				//Populations[iPopulation].NeuronList = new NeuronTypeIzhikevich[nNew];
				break;
			case TYPE_POISSON:
				for(int iNew=0; iNew<nNew; iNew++) Populations[iPopulation].NeuronList[iNew] = new NeuronTypePoisson;
				//Populations[iPopulation].NeuronList = new NeuronTypePoisson[nNew];
				break;
		}
	}
		
	#if DEBUG_INPUT > 0
	cout << "Reading param/state" << endl;
	#endif
	int nNeuron = NeuronList.size();
	for(int iNeuron=0; iNeuron<nNeuron; iNeuron++) {
		#if DEBUG_INPUT > 2
		cout << "  Processing cell " << iNeuron << endl;
		#endif
		NeuronList[iNeuron]->ReadParamState(fCell);
	}
}

void Network::ReadSynapses(ifstream* fSyn) {
	// Make outline of connectivies:
	int nConnectivity;
	#if DEBUG_INPUT > 0
	cout << "Reading synapse outline" << endl;
	#endif
	*fSyn >> nConnectivity;
	for(int iConnectivity=0; iConnectivity<nConnectivity; iConnectivity++) {
		int t, p;
		*fSyn >> t;
		*fSyn >> p;
		Connectivities.push_back(Connectivity(t,p));
		#if DEBUG_INPUT > 1
		cout << "Connectivity " << iConnectivity << " of type " << t << " to population " << p << endl;
		#endif
	}

/*
	// Make all the synapses:
	#if DEBUG_INPUT > 0
	cout << "Making synapses" << endl;
	#endif
	for(int iConnectivity=0; iConnectivity<nConnectivity; iConnectivity++) {
		int nNew = Populations[Connectivities[iConnectivity].TargetPopulation].nNeuron; // Number of neurons in target population
		Synapse* NewSynapse;
		switch(Connectivities[iConnectivity].TypeID) {
			case TYPE_DELTA:
				NewSynapse = new SynapseTypeDelta[nNew];
				break;
			case TYPE_EXPONENTIAL:
				NewSynapse = new SynapseTypeExponential[nNew];
				break;
		}
		

		// Add the new synapses to their host neurons
		#if DEBUG_INPUT > 1
		cout << "  Synapses made for connectivity " << iConnectivity << ". Linking to cells" << endl;
		#endif
		Neuron* HostCell = Populations[Connectivities[iConnectivity].TargetPopulation].NeuronList;
		for(int iCell=0; iCell<nNew; iCell++) {
			#if DEBUG_INPUT > 2
			cout << "    Linking to cell " << iCell << " of population " << Connectivities[iConnectivity].TargetPopulation << endl;
			#endif
			HostCell[iCell].AddSynapse(&NewSynapse[iCell]);
		}
	}
*/
	// Make all the synapses:
	#if DEBUG_INPUT > 0
	cout << "Making synapses" << endl;
	#endif
	for(int iConnectivity=0; iConnectivity<nConnectivity; iConnectivity++) {
		int nNeuron = Populations[Connectivities[iConnectivity].TargetPopulation].nNeuron; // Number of neurons in target population
		Neuron** PopulationCellList = Populations[Connectivities[iConnectivity].TargetPopulation].NeuronList;
		for(int iNeuron=0; iNeuron<nNeuron; iNeuron++) {
			switch(Connectivities[iConnectivity].TypeID) {
				case TYPE_DELTA:
					PopulationCellList[iNeuron]->AddSynapse(new SynapseTypeDelta);
					break;
				case TYPE_EXPONENTIAL:
					PopulationCellList[iNeuron]->AddSynapse(new SynapseTypeExponential);
					//	HostCell[iNeuron].AddSynapse(new SynapseTypeExponential);
					break;
			}
		}
	}

	#if DEBUG_INPUT > 0
	cout << "Reading param/state of synapses" << endl;
	#endif
	int nSynapse = SynapseList.size();
	for(int iSynapse=0; iSynapse<nSynapse; iSynapse++) {
		#if DEBUG_INPUT > 2
		cout << "  Reading synapse " << iSynapse << endl;
		#endif
		#if DEBUG_INPUT > 4
		cout << "  Address: " << SynapseList[iSynapse] << endl;
		#endif
		SynapseList[iSynapse]->ReadParamState(fSyn);
	}
}

void Network::ReadConnections(ifstream* fCon) {
	int nNeuron = NeuronList.size();
	nConnectionPerCell = new int[nNeuron];
	ConnectionList = new Connection*[nNeuron];
	
	#if DEBUG_INPUT > 0
	cout << "Processing connections" << endl;
	#endif
	for(int iNeuron=0; iNeuron<nNeuron; iNeuron++) {
		int nConnect;
		*fCon >> nConnect;
		nConnectionPerCell[iNeuron] = nConnect;
		#if DEBUG_INPUT > 1
		cout << "  Neuron " << iNeuron << " makes " << nConnect << " connections" << endl;
		#endif
		if(nConnect > 0) {
			ConnectionList[iNeuron] = new Connection[nConnect];
			for(int iConnect=0; iConnect<nConnect; iConnect++) {
				#if DEBUG_INPUT > 2
				cout << "    processing connection " << iConnect << endl;
				#endif
				ConnectionList[iNeuron][iConnect].ReadFromFile(fCon);
			}
		} else {
			ConnectionList[iNeuron] = NULL;
		}
	}
}
		
void Network::AddSpike(Gid id) {
	SpikeQueue.push(SpikeEvent(DynSys::Time,id));
}

void Network::DistributeSpike() {
	while(!SpikeQueue.empty()) {
		//#if DEBUG_RUN > 0
		//cout << "Distributing spikes" << endl;
		//#endif
		int CellId = SpikeQueue.front().Source.LocalID;
		double SpikeTime = SpikeQueue.front().Time;		

		// Write this spike to file, if necessary
		if(fOutSpikes != NULL) *fOutSpikes << SpikeTime << "\t" << CellId << "\n";

		// Distribute spike to all its connections:
		int nConnect = nConnectionPerCell[CellId];
		#if DEBUG_RUN > 1
		cout << "  Distributing spike from neuron " << CellId << " at time " << SpikeTime << " to " << nConnect << " connections" << endl;
		#endif

		for(int iConnect=0; iConnect<nConnect; iConnect++) {
			Synapse* Target = ConnectionList[CellId][iConnect].Target;
			double ActivationTime = SpikeTime + ConnectionList[CellId][iConnect].Delay;
			#if DEBUG_RUN > 2
			cout << "Adding event to synapse " << Target << " for time " << ActivationTime << endl;
			#endif
			Target->AddSpike(ActivationTime,ConnectionList[CellId][iConnect].Weight);
		}

		SpikeQueue.pop();
	}
}

void Network::PrintVm() {
	if(fOutVm != NULL) {
		for(int iNeuron=0; iNeuron<NeuronList.size(); iNeuron++) {
			*fOutVm << NeuronList[iNeuron]->GetVm() << "\t";
		}
		*fOutVm << "\n";
	}
}
