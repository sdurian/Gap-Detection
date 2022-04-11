# Gap-Detection
Simulation and analysis code for the paper "Mind the gap: decoding decreases in tonic firing in populations of spiking neurons" by Durian et al (2022). Data simulated using this code is available on GIN (https://gin.g-node.org/sdurian/Gap-Detection/src/master).

## Repository structure 
### simulation scripts
This directory contains scripts for simulating data to address the questions, when was the stimulus detected (gap timing detection task; TimingSimulationScript.mlx), and what is the stimulus strength (strength detection task; StrengthSimulationScript.mlx)? The corresponding measurements in the information train are reaction time and gap length, respectively. Simulated data are deposited into folders which are named based on the task and the variable parameter (population size or correlation). For example, the simulation script will fill the folder PopTiming with data for the gap timing detection task with variable population size.

### analysis
This directory contains analysis scripts for simulated data. Analysis scripts are named based on the task and the variable parameter; e.g. PopTimingAnalysis.mlx contains the analysis procedure for the data in the folder PopTiming.

#### Misc
This holds miscellaneous functions needed for analysis as well as specific illustratory examples used in the paper and a comparison of population PSTH and population information train readout mechanisms.

References

Dmitry Kaplan (2022). Knee Point (https://www.mathworks.com/matlabcentral/fileexchange/35094-knee-point), MATLAB Central File Exchange. Retrieved April 7, 2022.
