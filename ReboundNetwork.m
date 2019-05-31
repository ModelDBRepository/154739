function dX = ReboundNetwork(t, X, P)

% state vectors
X_Inh = X(1:3);
X_Exc1 = X(4:6);
X_Exc2 = X(7:9);

% membrane potentials
V_Inh = X(1);
V_Exc1 = X(4);
V_Exc2 = X(7);

% synaptic variables
S_Inh = X(3);
S_Exc1 = X(6);
S_Exc2 = X(9);


Isyn_Inh = P.G_inh_exc2 * S_Exc2 * (P.E_exc - V_Inh);
Isyn_Exc1 = P.G_exc1_inh * S_Inh * (P.E_inh - V_Exc1);
Isyn_Exc2 = (P.G_exc2_exc1*S_Exc1 + P.G_exc2_exc2*S_Exc2)*(P.E_exc - V_Exc2);

dX_Inh = IzhPopulation02(t, X_Inh, Isyn_Inh, P.Inh);
dX_Exc1 = IzhPopulation02(t, X_Exc1, Isyn_Exc1, P.Exc1);
dX_Exc2 = IzhPopulation02(t, X_Exc2, Isyn_Exc2, P.Exc2);

dX = [dX_Inh; dX_Exc1; dX_Exc2];