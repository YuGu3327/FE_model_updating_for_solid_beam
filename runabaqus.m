function [output_args] = runAbaqus(path, inpFile)
    % This function submits a job to ABAQUS.
    % ABAQUS requires an inp file, userfile, and the number of CPUs.

    % Construct the command string for running ABAQUS job.
    % Note: Spaces in this command string are very important.
    cmdStr = ['abaqus job=', inpFile, ' double cpus=8 mp_mode=threads double'];
    % Alternatively use the substitude cmdStr
    cmdStr = ['abaqus job=', inpFile];


    % Start recording time.
    ticStart = tic;

    % Save the current MATLAB directory.
    matlabDir = pwd();

    % Change to the ABAQUS directory, where the input file is located.
    cd(path);

    % Run the ABAQUS command and submit the job.
    [output_args] = system(cmdStr);
    
    % Pause for 5 seconds.
    pause(5);

    % Change back to the original MATLAB directory.
    cd(matlabDir);

    % Check for a .lck file to confirm if the job ran successfully.
    if exist(fullfile(path, [inpFile, '.lck']), 'file') == 2
        % Record the time while the .lck file exists.
        while exist(fullfile(path, [inpFile, '.lck']), 'file') == 2
            elapsedTime = toc(ticStart);
            hours = fix(elapsedTime / 3600);
            minutes = fix(mod(elapsedTime, 3600) / 60);
            seconds = fix(mod(mod(elapsedTime, 3600), 60));
        end
        fprintf('----------ABAQUS complete----------\nTime cost: %d:%d:%d\n', hours, minutes, seconds);
    else
        % If the job submission failed, print an error message.
        fprintf('\nrunAbaqus error: inpFile submission failed.\n');
    end
end
