% Run pf with matpower


matpower_path = '';
addpath(matpower_path); 

addpath('MVnetworkDatabase/')

% k-th  MV network index 1 to 776 

k = 740;

% run power flow using Matpower runpf function
runpf(SynMVtoMatpower(k))