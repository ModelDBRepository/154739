#ifndef SYNAPSES_H
#define SYNAPSES_H


#include "map"

#include "Basics.h"


#define TYPE_DELTA 0
#define TYPE_EXPONENTIAL 1


class Synapse: public DynSys {
	protected:
		Synapse(int np, int ns);

		std::multimap<double,double> Queue;
	public:

		virtual void AddSpike(double time, double weight);

		virtual double GetPulse(double Vm) {return 0;};
		virtual double GetCurrent(double Vm) {return 0;};
	
};


class SynapseTypeDelta: public Synapse {
	private:
		//std::multimap<double,double> Queue;

		void VectorField(double*, double*) {};
	public:
		SynapseTypeDelta(): Synapse(0,0) {};

//		void PostTimeStep();

		double GetPulse(double Vm);
};


class SynapseTypeExponential: public Synapse {
	private:

		void VectorField(double*, double*);
	public:
		SynapseTypeExponential();
	
		void PreTimeStep();

		double GetCurrent(double Vm);
};

#endif
