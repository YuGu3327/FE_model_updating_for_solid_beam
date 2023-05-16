% Fitness function to minimize the difference between calculated and experimental values.

function R = fitness(parameter)

    % Path to the directory that contains the objective files.
    workingDirectory = pwd;

    % Names of the input and output database (odb) files (without the .odb extension).
    inputFileName = 'Job-1_good_situation';
    odbFileName = 'Job-1_good_situation';

    % Measured frequency
    measuredFrequency = [21.534;85.280;188.79;328.30;499.09];

    % String to search in order to modify the material property.
    stringToModify = '*Material, name=Material-concrete1';

    % File name and path for the new data file.
    newFileName = strcat('NewData', '.txt');
    newFilePath = fullfile(workingDirectory, newFileName);

    % Open the new file for writing.
    fileID = fopen(newFilePath, 'wt');

    % Calculate the beam elasticity parameters.
    beamElasticity = parameter .* 0.01 .* 26 .* 10^9;
    poissonRatio = 0.3;

    % Write the calculated parameters to the new file.
    for i = 1:10
        fprintf(fileID, '%d, %d\n', beamElasticity(i), poissonRatio);
    end

    % Close the new file.
    fclose(fileID);

    % Modify the input for ABAQUS using a Python script.
    system('abaqus cae noGUI=inpmodify.py');

    % Run the modified input file in ABAQUS.
    % Wait until the lock file (.lck) no longer exists before proceeding.
    while exist(fullfile(workingDirectory, strcat(inputFileName, '.lck')), 'file')
        pause(0.1)
    end
    runabaqus(workingDirectory, inputFileName);

    % Output frequency.
    % Again, wait until the lock and .odb files exist before proceeding.
    while exist(fullfile(workingDirectory, strcat(inputFileName, '.lck')), 'file')
        pause(0.1)
    end
    while abs(exist(fullfile(workingDirectory, strcat(inputFileName, '.odb')), 'file') - 2)
        pause(0.1)
    end
    system('abaqus cae noGUI=odbHistoryOutput.py');

    % Import the data from the generated files.
    frequencies = importdata('EIGFREQ.txt');
    frequencies = frequencies(2:6, 2);
    modeShapes = importdata('mode shape.txt');

    % Assuming 'measured_modeshape' is defined somewhere else in the code.
    % If not, it should be defined here.
    % measuredModeshape = importdata('mode shape_object.txt');
    measuredModeshape = [measuredModeshape(1:28); measuredModeshape(30:57)];
    modeShapes = [modeShapes(1:28); modeShapes(30:57)];

    % Calculate the percent differences.
    frequencyDiffPercent = 100 * ((measuredFrequency - frequencies) ./ measuredFrequency)';
    modeShapeDiffPercent = 100 * ((abs(modeShapes) - abs(measuredModeshape)) ./ abs(measuredModeshape))';

    % Calculate the residuals for the mode shapes and frequencies. you can
    % define your own
    R = sum(abs((modeShapes .^ 2 - measuredModeshape .^ 2) ./ measuredModeshape.^ 2)) / 56;
    residualFrequency = sum(abs((measuredFrequency .^ 2 - frequencies .^ 2) ./ measuredFrequency .^ 2)) / 5;

    % Combine the residuals to create the final output.
    R = (residualModeShape + residualFrequency) * 100;
% end

% Copyright Yu Gu, University of Edinburgh
