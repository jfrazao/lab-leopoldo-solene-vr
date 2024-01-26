

%% Define parameters:
par.nTotal_images   = 2400;
par.nSelec_images   = 2400;
par.repetitions     = 2; %starting location, stimsize 80 cm, corridor 200 cm

par.nRepeatImages   = 100;
par.nRepeats        = 10;

%% Generate CSV
trials = struct();

%% trialnumber:
trials.trialnum = transpose(1:par.nSelec_images*par.repetitions + par.nRepeatImages*(par.nRepeats-par.repetitions));

%% Generate 

seq = [repmat(1:par.nSelec_images,1,par.repetitions) repmat(randperm(par.nTotal_images,par.nRepeatImages),1,par.nRepeats-par.repetitions)];

trials.imagenum = seq(randperm(length(seq)))';

figure()
plot(histcounts(trials.imagenum,0:par.nTotal_images))

%% Create and save the table:
table_trials = struct2table(trials);
% writetable(table_trials,'T:\Bonsai\lab-leopoldo-solene-vr\workflows\Protocols\ImageDatabase\MOL_imageseq_wrepeats.csv')
writetable(table_trials,'C:\Users\Admin\Desktop\Bonsai\lab-leopoldo-solene-vr\workflows\Protocols\ImageDatabase\MOL_imageseq_wrepeats.csv')

