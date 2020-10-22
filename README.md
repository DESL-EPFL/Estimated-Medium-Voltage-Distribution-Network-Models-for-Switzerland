# Medium Voltage Distribution Network Models for Switzerland
We provide synthetically generated medium voltage (MV) distribution network models for the whole of Switzerland. The networks are generared using the method proposed in *R.Gupta et. al.* In brief, the networks are estimated using an unsupervised method to infer the topologies and characteristics of the MV networks starting from publicly available highly resolved geo-refrenced energy demand and locations of the extra-high-voltage (EHV) substations. The energy demand is estimated from the \[[Swiss Federeal Office of Topography](https://map.geo.admin.ch)\] and the EHV susbtations are taken from \[[ENTSOE](https://www.entsoe.eu/data/map/)\]. In total, 776 MV networks are generated covering the whole Switzerland. 

## Files
* \[[Zip file](https://github.com/DESL-EPFL/Medium-Voltage-Distribution-Network-Models-for-Switzerland/blob/main/MVnetworkDatabase.zip)\]  (MVnetworkDatabase.zip) containing excel files (MVnetworkID.xlsx) for each MV network containing Linedata (sheet 1), demand (sheet 2), transformer data (sheet 3) and gegraphical locations (sheet 4).
* A demo matlab code (powerflow.m) to run power flow on a chosen MV network using matpower.

## Simulation notes 
* To run the power-flow, it requires the installation of \[[MATPOWER](https://matpower.org)\] package.
* Please assign Matpower PATH to matpower_path in powerflow.m.

## Software 
* MATLAB R2018b
* MATPOWER 6.0 or latest version

## References 
For a detailed description on the network generation method, please have look at the following reference(s):
* R. Gupta, F. Sossan and M. Paolone, “Countrywide PV hosting capacity and energy storage requirements for distribution networks: the case of Switzerland”, Applied Energy 2020 (accepted in press).
