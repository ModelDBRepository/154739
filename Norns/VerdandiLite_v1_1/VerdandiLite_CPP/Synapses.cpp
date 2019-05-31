#include "Synapses.h"
#include "Network.h"

#include <iostream>

using namespace std;

#define DEBUG 0

Synapse::Synapse(int np, int ns): DynSys(np,ns) {
	Network::AddSynapse(this);
};

void Synapse::AddSpike(double time, double weight) {
	#if DEBUG > 0
	cout << "Event added at synapse " << this << endl;
	#endif
	Queue.insert(pair<double,double>(time,weight));
	#if DEBUG > 2
	cout << "  Queue contains: " << endl;
	multimap<double,double>::iterator it;
	for(it=Queue.begin(); it!=Queue.end(); it++) {
		cout << "    t = " << (*it).first << endl;
	}
	#endif
}

double SynapseTypeDelta::GetPulse(double Vm) {
	double Weight = 0;

	#if DEBUG > 0
	cout << "        Processing delta synapse " << this << endl;
	#endif
	
	// Processes all spikes that activate the synapse this time step
	double t = DynSys::Time + DynSys::dt;
	if(!Queue.empty()) {
		#if DEBUG > 1
		cout << "          Queue non-empty" << endl;
		#endif
		double EventTime = Queue.begin()->first;
		while(!Queue.empty() && EventTime < t) {
			#if DEBUG > 2
			cout << "            Processing queue item" << endl;
			#endif
			Weight += Queue.begin()->second;
			Queue.erase(Queue.begin());
			double EventTime = Queue.begin()->first;
		}
	}
	return Weight;
};



SynapseTypeExponential::SynapseTypeExponential(): Synapse(3,1) {
/*
	ParamId | Description
	--------+-----------
	   0    | Time constant
     1    | E (reversal potential)
	   2    | g (maximal conductance)

	StateId | Description
	--------+-----------
	   0    | s (synaptic gating)
*/	

}

void SynapseTypeExponential::PreTimeStep() {
	// Processes all spikes that activate the synapse this time step
	double t = DynSys::Time + DynSys::dt;
	if(!Queue.empty()) {
		double EventTime = Queue.begin()->first;
		while(!Queue.empty() && EventTime < t) {
			State[0] += Queue.begin()->second;
			Queue.erase(Queue.begin());
		}
	}
}

void SynapseTypeExponential::VectorField(double* dState, double* StateIn) {
	dState[0] = -StateIn[0]/Param[0];
}


double SynapseTypeExponential::GetCurrent(double Vm) {
	// I_ext = s*g*(Vm-E)
	return State[0]*Param[2]*(Param[1]-Vm);
}



