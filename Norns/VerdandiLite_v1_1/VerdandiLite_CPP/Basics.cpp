#include "Basics.h"

#include <iostream>

#define DEBUG_RUN 0

using namespace std;

vector<DynSys*> DynSys::List;
double DynSys::Time=0;
double DynSys::dt;

DynSys::DynSys(int np, int ns) {
	List.push_back(this);
	
	nParam = np;
	nState = ns;
	
	if(nParam == 0) {
		Param = NULL;
	} else {
		Param = new double[nParam];
	}

	if(nState == 0) {
		State = NULL;
	} else {
		State = new double[nState];
	}
}

void DynSys::ReadParamState(ifstream* f) {
	for(int iParam=0; iParam<nParam; iParam++) {
		*f >> Param[iParam];
//		cout << Param[iParam] << "\t";
	}
//	cout << endl;
	for(int iState=0; iState<nState; iState++) {
		*f >> State[iState];
//		cout << State[iState] << "\t";
	}
//	cout << endl;
}

void DynSys::SetParam(double* p) {
	for(int iParam=0; iParam<nParam; iParam++) Param[iParam] = p[iParam];
}

void DynSys::SetState(double* s) {
	for(int iState=0; iState<nState; iState++) State[iState] = s[iState];
}

void DynSys::CopyState(double* dest) {
	for(int iState=0; iState<nState; iState++) dest[iState] = State[iState];
}


void DynSys::TimeStep() {
	// Timestep according to Euler
	// Determine derivative:
	double* dState = new double[nState];
	VectorField(dState);
	for(int iState=0; iState<nState; iState++) State[iState]+=dt*dState[iState];
	delete[] dState;
}

void DynSys::StepAll() {
	#if DEBUG_RUN > 0
	cout << "Step" << endl;
	#endif
	
	#if DEBUG_RUN > 1
	cout << "  PreStep" << endl;
	#endif
	for(int iSys=0; iSys<List.size(); iSys++) {
		#if DEBUG_RUN > 2
		cout << "    system " << iSys << endl;
		#endif
		List.at(iSys)->PreTimeStep();
	}

	#if DEBUG_RUN > 1
	cout << "  TimeStep" << endl;
	#endif
	for(int iSys=0; iSys<List.size(); iSys++) {
		#if DEBUG_RUN > 2
		cout << "    system " << iSys << endl;
		#endif
		List.at(iSys)->TimeStep();
	}

	Time+=dt;

	#if DEBUG_RUN > 1
	cout << "  PostStep" << endl;
	#endif
	for(int iSys=0; iSys<List.size(); iSys++) {
		#if DEBUG_RUN > 2
		cout << "    system " << iSys << endl;
		#endif
		List.at(iSys)->PostTimeStep();
	}
}

