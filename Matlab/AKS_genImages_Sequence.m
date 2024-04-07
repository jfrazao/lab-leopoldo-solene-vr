

%% Define parameters:
par.nTotal_images   = 2800;
par.nSelec_images   = 60;
par.repetitions     = 5; %starting location, stimsize 80 cm, corridor 200 cm

%% Generate CSV
trials = struct();

%% trialnumber:
trials.trialnum = transpose(1:par.nSelec_images*par.repetitions);

%% Generate 
% seq = [repmat(1:par.nSelec_images,1,par.repetitions) repmat(randperm(par.nTotal_images,par.nRepeatImages),1,par.nRepeats-par.repetitions)];
% trials.imagenum = seq(randperm(length(seq)))';

seq = randperm(par.nTotal_images,par.nSelec_images)-1;
trials.imagenum = [seq'; seq';  seq';  seq';  seq'];

%% Create and save the table:
table_trials = struct2table(trials);
writetable(table_trials,'C:\Users\Admin\Desktop\Bonsai\lab-leopoldo-solene-vr\workflows\Protocols\ImageDatabase\AKS_imageseq.csv')

% plot(histcounts(trials.imagenum,1:2800))
