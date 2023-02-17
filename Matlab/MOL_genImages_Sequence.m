

%% Define parameters:
par.nTotal_images   = 2800;
par.nSelec_images   = 2800;
par.repetitions     = 2; %starting location, stimsize 80 cm, corridor 200 cm

%% Generate CSV
trials = struct();

%% trialnumber:
trials.trialnum = transpose(1:par.nSelec_images*par.repetitions);

%% Generate 

seq = randperm(par.nTotal_images,par.nSelec_images);
trials.imagenum = [seq'; seq'];

%% Create and Save table
%Table
table_trials = cell2table(sequence, 'VariableNames', variable_names);
%Save
writetable(table_trials,'TrialSequence_Goncalo_ultimate.csv')

%% Create and save the table:
table_trials = struct2table(trials);
writetable(table_trials,'T:\Bonsai\lab-leopoldo-solene-vr\workflows\Protocols\ImageDatabase\MOL_imageseq.csv')

