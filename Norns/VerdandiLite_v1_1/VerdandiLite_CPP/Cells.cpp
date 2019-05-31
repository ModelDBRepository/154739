#include "Cells.h"
#include "Synapses.h"
#include "Network.h"

#include <iostream>
#include <stdlib.h>

using namespace std;

#define DEBUG_RUN 0

Neuron::Neuron(int np, int ns): DynSys(np,ns) {
	Id.LocalID = Network::AddNeuron(this);
}

void Neuron::Spike() {	
	#if DEBUG_RUN > 0
	cout << "  Spike from cell " << Id.LocalID << endl;
	#endif
	Network::AddSpike(Id);
}

void Neuron::PreTimeStep() {
	#if DEBUG_RUN > 3
	cout << "      Neuron: determining inputs" << endl;
	#endif

	// Determine input from all synapses:
	PulsesIn = 0;
	I_external = 0;

	int nSynapse = SynapseList.size();


	for(int iSynapse=0; iSynapse<nSynapse; iSynapse++) {
		#if DEBUG_RUN > 4
		cout << "        Checking synapse " << iSynapse << " of " << nSynapse << endl;
		#endif
		PulsesIn += SynapseList.at(iSynapse)->GetPulse(State[0]);
		I_external += SynapseList.at(iSynapse)->GetCurrent(State[0]);
	}
			
	State[0]+=PulsesIn;
}

void Neuron::AddSynapse(Synapse* s) {
	SynapseList.push_back(s);
	//#if DEBUG_INPUT > 3
	//cout << "      Synapse " << s << " added to cell " << Id.LocalID << endl;
	//#endif
}


NeuronTypeLIF::NeuronTypeLIF(): Neuron(4,1) {
/*
	ParamId | Description
	--------+-----------
	   0    | C
	   1    | V_rest
	   2    | V_thres
	   3    | V_reset

	StateId | Description
	--------+----------
	   0    | V
*/
	MirrorVm = 0;
}

void NeuronTypeLIF::VectorField(double* dState, double* StateIn) {
	// dV = -(V-Vrest)/tau
	dState[0] = (I_external-(StateIn[0]-Param[1]))/Param[0];
}

void NeuronTypeLIF::PostTimeStep() {
	// Check for threshold passing:
	if(State[0] > Param[2]) {
		State[0] = Param[3];
		MirrorVm = 30;
		Spike();
	} else {
		MirrorVm = State[0];
	}
}

double NeuronTypeLIF::GetVm() {
	return MirrorVm;
}



NeuronTypeIzhikevich::NeuronTypeIzhikevich(): Neuron(5,2) {
/*
	ParamId | Description
	--------+-----------
	   0    | Injected current (const)
	   1    | a
	   2    | b
	   3    | c
	   4    | d

	StateId | Description
	--------+-----------
	   0    | V
	   1    | u

*/
}

void NeuronTypeIzhikevich::VectorField(double* dState, double* StateIn) {
	// dV = 0.04v^2 + 5v + 140 - u + I
	// du = a(bv-u)
	dState[0] = 0.04*StateIn[0]*StateIn[0] + 5*StateIn[0] + 140 - StateIn[1] + Param[0] + I_external;
	dState[1] = Param[1]*(Param[2]*StateIn[0]-StateIn[1]);
}

void NeuronTypeIzhikevich::PostTimeStep() {
	// if(Vm>=30)
	if(State[0] >= 30) {
		State[0] = Param[3];
		State[1] = State[1]+Param[4];
		Spike();
	}
}


NeuronTypePoisson::NeuronTypePoisson(): Neuron(1,1) {
/*
	ParamId | Description
	--------+-----------
	   0    | Poisson rate (s^-1)

	StateId | Description
	--------+-----------
	   0    | V
*/
}

void NeuronTypePoisson::VectorField(double* dState, double* StateIn) {
	dState[0]=0;
}

void NeuronTypePoisson::PreTimeStep() {
	double r = ((double)rand())/RAND_MAX;
	if(r<DynSys::dt*Param[0]/1000) { // Factor 1000 corrects for rate expressed in s^-1, while time is measured in ms by default
		State[0] = 1;
	} else {
		State[0] = 0;
	}
}

void NeuronTypePoisson::PostTimeStep() {
	if(State[0]>0) Spike();
}
