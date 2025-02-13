%% Copy images and rename:
sesid = 'LPE11086_2024_01_09';
meidir = fullfile('C:\Users\Admin\Desktop\Bonsai\lab-leopoldo-solene-vr\workflows\MEIs',sesid,'\*.jpg');
outdir = 'C:\Users\Admin\Desktop\Bonsai\lab-leopoldo-solene-vr\workflows\ImageDatabase';
files  = dir(meidir);
filenames = {files.name};
nMEIs = length(filenames);
for iF=1:nMEIs
    outfile = fullfile(outdir,sprintf('Img%4.0d.jpg',iF+2800));
    copyfile(fullfile(files(iF).folder,files(iF).name),outfile);
end


%% Make trialdata:

%% Define parameters:
par.nTotal_images   = 2800;
par.nSelec_images   = 260;
par.repetitions     = 10; %starting location, stimsize 80 cm, corridor 200 cm

par.nMEIs           = nMEIs;
par.nRepeats_MEIs   = 20;

%% Generate CSV
trials = struct();

%% trialnumber:
trials.trialnum = transpose(1:par.nSelec_images*par.repetitions + par.nMEIs*par.nRepeats_MEIs);

%% Generate 
% seqims  = [repmat(1:par.nSelec_images,1,par.repetitions) repmat(randperm(par.nTotal_images,par.nRepeatImages),1,par.nRepeats-par.repetitions)];
% seqims  = repmat(randi(par.nTotal_images,1,par.nSelec_images),1,par.repetitions);
p = randperm(par.nTotal_images);
seqims  = repmat(p(1:par.nSelec_images),1,par.repetitions);
% seqims  = repmat(randsample(par.nTotal_images,par.nSelec_images),par.repetitions,1);

seqmeis = repmat(1:par.nMEIs,1,par.nRepeats_MEIs)+2800;
seq     = [seqims seqmeis];
trials.imagenum = seq(randperm(length(seq)))';

figure()
plot(histcounts(trials.imagenum,0:par.nTotal_images+par.nMEIs+5))

%% Create and save the table:
table_trials = struct2table(trials);
% writetable(table_trials,sprintf('C:\Bonsai\lab-leopoldo-solene-vr\workflows\Protocols\ImageDatabase\MOL_meiseq_%s.csv',sesid))
writetable(table_trials,fullfile('C:\Users\Admin\Desktop\Bonsai\lab-leopoldo-solene-vr\workflows\Protocols\ImageDatabase',['MOL_meiseq_' sesid '.csv']))
% writetable(table_trials,['MOL_meiseq_' sesid '.csv'])

