# Gap-Detection
Simulation and analysis code for the paper "Optimal burstiness in populations of spiking neurons facilitates decoding of decreases in tonic firing" by Durian et al (2022). Data simulated using this code is available on GIN (https://gin.g-node.org/sdurian/Gap-Detection/src/master).

## Repository structure 
### simulation scripts
This directory contains scripts for simulating data for two tasks: gap timing detection (TimingSimulationScript.mlx) and strength detection (StrengthSimulationScript.mlx). The goal of the gap timing detection task is to determine when the stimulus is detected by the population, whereas the goal of the strength detection task is to determine the strength of the stimulus. The corresponding measurements in the population information train are reaction time and gap length, respectively. Simulated data are deposited into folders which are named based on the task and the variable parameter (population size or correlation). For example, the simulation script will fill the folder PopTiming with data for the gap timing detection task as collected for populations of varying size.

### analysis
This directory contains analysis scripts for simulated data. Analysis scripts are named based on the task and the variable parameter; e.g. PopTimingAnalysis.mlx contains the analysis procedure for the data in the folder PopTiming.

The subdirectory Misc holds miscellaneous functions needed for analysis as well as specific illustratory examples used in the paper and a comparison of population PSTH and population information train readout mechanisms.

#### References

Dmitry Kaplan (2022). Knee Point (https://www.mathworks.com/matlabcentral/fileexchange/35094-knee-point), MATLAB Central File Exchange. Retrieved April 7, 2022.


doi:10.5281/zenodo.7054843
