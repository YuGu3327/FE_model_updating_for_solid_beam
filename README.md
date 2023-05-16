# FE_model_updating
 In short, this script is setting up, running, and processing the results of an ABAQUS simulation, and then comparing these results to experimental data. The script is designed to be used in an optimization loop, where the `parameter` input would be updated in each iteration to try and minimize the output of the `fitness` function 
=============================
The CAE file is the SOLID BEAM, which for updating

This MATLAB script represents a fitness function used in a process of optimization to minimize the difference between calculated and experimental values, presumably in a mechanical system. Here is an overview of the main components of the script:

1. `workingDirectory`, `inputFileName`, and `odbFileName`: These are the file paths and names for the required files. The script assumes that these files are in a specific location on your computer.

2. `measuredFrequency`: This is the actual, measured frequency of the system.

3. `beamElasticity` and `poissonRatio`: These are material properties for the beam in the system. `beamElasticity` is calculated based on the input parameter.

4. The script then writes these material properties to a new file.

5. Next, the script runs a Python script (`inpmodify.py`) using the system function, which modifies the input file for ABAQUS, a suite of engineering simulation software.

6. Then, it runs ABAQUS with the modified input file and waits for the simulation to finish (by checking for the existence of a lock file).

7. After the ABAQUS run finishes, it runs another Python script (`odbHistoryOutput.py`) to extract the results from the output database.

8. The script then imports the calculated frequencies and mode shapes from the generated files.

9. The percent differences between the measured and calculated frequencies and mode shapes are then calculated.

10. The script then calculates the residuals (i.e., the sum of the squared differences between the calculated and measured values, normalized by the measured values) for both the mode shapes and frequencies.

11. Finally, the residuals are combined to create the final output, which represents the fitness of the solution.

In short, this script is setting up, running, and processing the results of an ABAQUS simulation, and then comparing these results to experimental data. The script is designed to be used in an optimization loop, where the `parameter` input would be updated in each iteration to try and minimize the output of the `fitness` function (i.e., the difference between the simulated and experimental results).
======================================================================
1. **inpmodify**
   This script is used to modify an ABAQUS input file (.inp) according to some new data from a text file. The script performs the following operations:

   - It first specifies paths to the input file (inp), the new data file (txt), and the string to be modified in the inp file.
   - The script then reads in the new data from the specified text file.
   - It opens the inp file and scans through it line by line. If it encounters a line that contains the specified string to be modified, it replaces certain lines after this line with corresponding data from the new data file.
   - The modified data is then written back to the original inp file.
======================================================================
2. **odbHistoryOutput**
   This script works with Abaqus output database files (ODB files) to extract specific data related to a simulation's results. Here are the key functions:

   - It first specifies the path to the ODB file and certain parameters like the step, instance, and requested data.
   - It then attempts to open the specified ODB file and extracts the required data (in this case, Eigenfrequency data).
   - If the initial attempt fails (perhaps because the simulation is still running), it waits for some time and then tries to re-run the job and open the ODB file again to extract the data.
   - Finally, the script extracts mode shape data from the ODB file and saves it to a text file.

These scripts are typical examples of how Python can be used to automate the process of modifying simulation input files and extracting result data from output files when working with FEA software like Abaqus.
