

%% Define parameters:
par.nTotal_images   = 2800;
par.nSelec_images   = 260;
par.repetitions     = 10; %starting location, stimsize 80 cm, corridor 200 cm

par.nMEIs           = 150;
par.nRepeats_MEIs   = 20;

%% Generate CSV
trials = struct();

%% trialnumber:
trials.trialnum = transpose(1:par.nSelec_images*par.repetitions + par.nMEIs*par.nRepeats_MEIs);

%% Generate 
% seqims  = [repmat(1:par.nSelec_images,1,par.repetitions) repmat(randperm(par.nTotal_images,par.nRepeatImages),1,par.nRepeats-par.repetitions)];
% seqims  = repmat(randi(par.nTotal_images,1,par.nSelec_images),1,par.repetitions);
seqims  = repmat(randsample(par.nTotal_images,par.nSelec_images),par.repetitions,1);

seqmeis = repmat(1:par.nMEIs,1,par.nRepeats_MEIs)+5000;
seq     = [seqims' seqmeis];
trials.imagenum = seq(randperm(length(seq)))';

figure()
plot(histcounts(trials.imagenum,0:10000))

%% Create and save the table:
table_trials = struct2table(trials);
writetable(table_trials,'E:\Bonsai\lab-leopoldo-solene-vr\workflows\Protocols\ImageDatabase\MOL_meiseq.csv')
% writetable(table_trials,'T:\Bonsai\lab-leopoldo-solene-vr\workflows\Protocols\ImageDatabase\MOL_meiseq.csv')
% writetable(table_trials,'C:\Users\Admin\Desktop\Bonsai\lab-leopoldo-solene-vr\workflows\Protocols\ImageDatabase\MOL_meiseq.csv')

