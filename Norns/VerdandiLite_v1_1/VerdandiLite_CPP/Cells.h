#ifndef CELLS_H
#define CELLS_H

#include "vector"

#include "Basics.h"

class Synapse;
class Neuron;
class FullNetwork;

class Neuron: public DynSys {
	protected:
		Gid Id;
		Neuron(int np, int ns);

		std::vector<Synapse*> SynapseList;
		
		virtual void Spike();

		double I_external;
		double PulsesIn;
	public:
		virtual double GetVm() {
			return State[0];
		};
		//void SetIext(double Iext) {I_external = Iext;};
		//void SetPulses(double p) {PulsesIn = p;};

		virtual void PreTimeStep();

		void AddSynapse(Synapse*);

};

#define TYPE_LIF 0
#define TYPE_IZHIKEVICH 1
#define TYPE_POISSON 2

class NeuronTypeLIF: public Neuron {
	private:
		void VectorField(double*, double*);

		double MirrorVm; // Variable that mirror Vm, except when spiking
		
	public:
		NeuronTypeLIF();

		double GetVm();
		
		void PostTimeStep();
	
};	

class NeuronTypeIzhikevich: public Neuron {
	private:
		void VectorField(double*, double*);
	
	public:
		NeuronTypeIzhikevich();
	
		void PostTimeStep();

};

class NeuronTypePoisson: public Neuron {
	private:
		void VectorField(double*, double*);

	public:
		NeuronTypePoisson();

		void PreTimeStep();
		void PostTimeStep();

};

#endif
