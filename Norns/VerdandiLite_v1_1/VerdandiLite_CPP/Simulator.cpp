#include "Basics.h"
#include "Network.h"

#include <iostream>
#include <stdlib.h>
#include <time.h>

using namespace std;

int main() {
	
	ifstream fInit("Inits.txt");
	int nStep, flag;
	fInit >> nStep;
	fInit >> DynSys::dt;
	int OutVm, OutSp;
	fInit >> OutVm;
	fInit >> OutSp;
	fInit.close();

	ifstream fCell("CellsIn.txt");
	ifstream fSyn("SynIn.txt");
	ifstream fCon("ConIn.txt");

	Network::ReadCells(&fCell);
	Network::ReadSynapses(&fSyn);
	Network::ReadConnections(&fCon);

	fCell.close();
	fSyn.close();
	fCon.close();

	ofstream DumpVm;
	ofstream DumpSp;
	if(OutVm) {
		DumpVm.open("Vm.txt");
		Network::SetOutVm(&DumpVm);
	}
	if(OutSp) {
		DumpSp.open("Spikes.txt");
		Network::SetOutSpikes(&DumpSp);
	}

	// Initialize random seed
	srand(time(NULL));

	for(int iStep=0; iStep<nStep; iStep++) {
		DynSys::StepAll();

		if(iStep%2==0) Network::DistributeSpike();

		Network::PrintVm();

	}	

	DumpVm.close();
	DumpSp.close();

	return 0;
}
