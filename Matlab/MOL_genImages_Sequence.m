

%% Define parameters:
par.nTotal_images   = 2800;
par.nSelec_images   = 2800;
par.repetitions     = 2; %starting location, stimsize 80 cm, corridor 200 cm

%% Generate CSV
trials = struct();

%% trialnumber:
trials.trialnum = transpose(1:par.nSelec_images*par.repetitions);

%% Generate 

seq = randperm(par.nTotal_images,par.nSelec_images)-1;
trials.imagenum = [seq'; seq'];

%% Create and save the table:
table_trials = struct2table(trials);
writetable(table_trials,'T:\Bonsai\lab-leopoldo-solene-vr\workflows\Protocols\ImageDatabase\MOL_imageseq.csv')

