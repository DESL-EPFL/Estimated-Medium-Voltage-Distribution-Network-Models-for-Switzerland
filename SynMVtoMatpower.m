% demo code for using SynMV networks using MATPOWER
function mpc = SynMVtoMatpower(j)

% j - index of the mv network
filename = ['MV' num2str(j), '.xlsx'];

LD = xlsread(filename, 1);
demandData = xlsread(filename, 2);
Tr_data =  xlsread(filename, 3);

% defining base
Sb = Tr_data(end)*1e6;
Vb = Tr_data(2);
Yb = (Sb)/Vb^2;
Ib = Sb/Vb/sqrt(3);

% Transformer 
tr = [0 1 Tr_data(3) Tr_data(3) 0 1 Ib];
% linedata with transformer
LD_tr =  [tr; LD];
line_lengths = LD_tr(:,6);

LD_tr(:,1:2) = LD_tr(:,1:2)+1;
LD_tr(:,3) = (LD_tr(:,3).*Yb).*line_lengths;
LD_tr(:,4) = (LD_tr(:,4).*Yb).*line_lengths;
LD_tr(:,5) = (LD_tr(:,5)./Yb).*line_lengths;
LD_tr(:,7) = LD_tr(:,7);
LD_tr(:,6) = [];

linedata = LD_tr(:,1:5);

% 
n_rami = length(linedata(:,1));
n_nodi = max(max(linedata(:,1)),max(linedata(:,2)));
y_ih = 1./(linedata(:,3)+1i*linedata(:,4));
y_i_ih = zeros(n_nodi,n_nodi);

for k = 1:n_rami
    y_i_ih(linedata(k,1),linedata(k,2)) = linedata(k,5)*1i/2;
    y_i_ih(linedata(k,2),linedata(k,1)) = linedata(k,5)*1i/2;
end
for k = 1:n_nodi
    y_i(k) = sum(y_i_ih(k,:));
end

Yp = diag( [y_ih.',y_i]);

A = zeros(n_rami+n_nodi,n_nodi);

for k = 1:n_rami
    A(k,linedata(k,1)) = 1;
    A(k,linedata(k,2)) = -1;
end
for k = 1:n_nodi
    A(n_rami+k,k) = 1;
end
Conn = A;

linedata_mp = [linedata zeros(n_rami, 5) ones(n_rami,1)*[1 -360 360]];
Y = A.'*Yp*A;


P_load = [0; demandData(:,2)];
P_load = P_load*1e3;

Q_load = [0; demandData(:,3)];
Q_load = Q_load*1e3;

P_nom = P_load;
Q_nom = Q_load;

%	bus_i	type	Pd	Qd	Gs	Bs	area	Vm	Va	baseKV	zone	Vmax	Vmin

busdata = [[1;demandData(:,1)+1] [2;ones(n_nodi-1,1)] P_nom/1e6 Q_nom/1e6...
    zeros(n_nodi,2) ones(n_nodi,2), zeros(n_nodi,1) 20*ones(n_nodi,1) ones(n_nodi,1) 1.1*ones(n_nodi,1) 0.9*ones(n_nodi,1)  ];

PVdata = [[1;demandData(:,1)+1] zeros(n_nodi, 1)];
PVPeak = PVdata(:,2)/10*0.37;

busdata(:,3) = busdata(:,3)-PVPeak/1e3;


%	bus	Pg	Qg	Qmax	Qmin	Vg	mBase	status	Pmax	Pmin	Pc1	Pc2	Qc1min	Qc1max	Qc2min	Qc2max	ramp_agc	ramp_10	ramp_30	ramp_q	apf
gendata = [1   0  0   10  -10  1   25  1   10  -10    zeros(1,11)];

mpc.version = '2';
%%-----  Power Flow Data  -----%%
%% system MVA base
mpc.baseMVA = Sb/1e6;

%% bus data
%	bus_i	type	Pd	Qd	Gs	Bs	area	Vm	Va	baseKV	zone	Vmax	Vmin
mpc.bus = busdata;

%% generator data
%	bus	Pg	Qg	Qmax	Qmin	Vg	mBase	status	Pmax	Pmin	Pc1	Pc2	Qc1min	Qc1max	Qc2min	Qc2max	ramp_agc	ramp_10	ramp_30	ramp_q	apf
mpc.gen = gendata;

%% branch data
%	fbus	tbus	r	x	b	rateA	rateB	rateC	ratio	angle	status	angmin	angmax
mpc.branch = linedata_mp;

end


