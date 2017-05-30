# LSDTM #
LSDTM (Location-Specific Disease Transmission Models) is a workflow project that streamlines the process of running location-specific disease transmission models on the Olympus cluster of the Pittsburgh Supercomputing Center [:computer:](https://www.psc.edu/).

### LSDTM Quickstart ###
1. Clone or download LSDTM project
2. Ensure `fred/pfred-0.0.8` and `fred_populations/spew2synthia-1.2.0` (optionally `fred_populations/United_States_2010_ver1` as well) modules are available in working environment (`module avail`)
3. Determine the population ID (for example, '2010_ver1_01' is the synthetic population ID for Alabama)
4. Run `[path]/LSDTM/lsdtm.sh` [[`-p Synthetic Population ID`] (OPTIONS: [[`-e Ecosystem`] [`-o Output Directory`]])] | [`-h Help`]

(for more information please visit the wiki [:book:](https://github.com/midas-isg/LSDTM/wiki)
