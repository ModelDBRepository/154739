#ifndef BASICS_H
#define BASICS_H

#include "fstream"
#include "vector"
#include "map"

struct Gid {
	int LocalID;
};

class DynSys;
class DynSys {
	private:
		static std::vector<DynSys*> List;
		int nParam, nState;

	protected:
		double* Param;
		double* State;

		DynSys(int np, int ns);

		void SetParam(double*);
		void SetState(double*);

		virtual void VectorField(double* dState, double* StateIn) = 0;
		void VectorField(double* dState) {
			VectorField(dState, State);
		};
		
		virtual void PreTimeStep() {};
		void TimeStep();	
		virtual void PostTimeStep() {};
		
	public:
		static double Time;
		static double dt;

		void ReadParamState(std::ifstream*);

		double* GetState() {return State;};
		double GetState(int i) {return State[i];};
		void CopyState(double* dest);
	
		static void StepAll();
};


#endif
