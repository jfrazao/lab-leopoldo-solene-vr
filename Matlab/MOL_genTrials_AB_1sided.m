
%% Define parameters:
par.number_trials   = 1000;
par.stim_loc_int    = [150 250];
par.frac_trial_A    = 0.5;
par.frac_trial_B    = 0.5;
par.rewardedstim    = 'A';
par.blocksize       = 50;

par.tex_A           = 'stim_parametric_1_1';
par.tex_B           = 'stim_parametric_1_5';
par.tex_C           = 'stim_parametric_5_1';
par.tex_D           = 'stim_parametric_5_5';
par.tex_BG          = 'fwn1_25';

%% Generate CSV
trials = struct();

%% trialnumber:
trials.trialnum = transpose(1:par.number_trials);

%% Generate block-shuffled trial types:
trials.trialtype = '';
block                   = 10; %shuffle block (not stimulus side block)
for bl = 1:ceil(par.number_trials/block)
    seq = '';
    seq = [seq repmat('A',1,floor(par.frac_trial_A * block) + double(rand<mod(par.frac_trial_A * block,1)))]; %#ok<*AGROW>
    seq = [seq repmat('B',1,floor(par.frac_trial_A * block) + double(rand<mod(par.frac_trial_A * block,1)))]; %#ok<*AGROW>

    seq = seq(1:block); %Trim until 10 trials
    
    trials.trialtype = [trials.trialtype seq(randperm(10))]; %Add trials to trialType vector in randomized order (block-scrambled)
end
trials.trialtype = trials.trialtype';

%% Generate blocks of left-sided or right-sided presentation:

temp = repmat([0 1],1,par.number_trials/par.blocksize/2);
leftrelevanttrials = repmat(temp,par.blocksize,1); leftrelevanttrials = leftrelevanttrials(:);
if rand()>0.5
    leftrelevanttrials = 1-leftrelevanttrials;
end

%% Set stimuli per trial type: 
trials.tex_Stim_Left  = cell(par.number_trials,1);
trials.tex_Stim_Right = cell(par.number_trials,1);

trials.tex_Stim_Left(ismember(trials.trialtype,'A') & leftrelevanttrials==1)    = {par.tex_A}; 
trials.tex_Stim_Right(ismember(trials.trialtype,'A') & leftrelevanttrials==0)   = {par.tex_A}; 

trials.tex_Stim_Left(ismember(trials.trialtype,'B') & leftrelevanttrials==1)    = {par.tex_B}; 
trials.tex_Stim_Right(ismember(trials.trialtype,'B') & leftrelevanttrials==0)   = {par.tex_B}; 

trials.tex_Stim_Left(leftrelevanttrials==0)                                     = {par.tex_BG}; 
trials.tex_Stim_Right(leftrelevanttrials==1)                                    = {par.tex_BG}; 

%% Location of the stimuli:
trials.StimLocation = randi(par.stim_loc_int,[par.number_trials,1]);

%% Set reward availability per trial:
trials.reward = ismember(trials.trialtype,par.rewardedstim);

%% Create and save the table:
table_trials = struct2table(trials);
writetable(table_trials,'MOL_trialseq_AB_1sided.csv')

% %% Create and Save table
% %Table
% table_trials = cell2table(sequence, 'VariableNames', variable_names);
% %Save
% writetable(table_trials,'TrialSequence_Goncalo_ultimate.csv')

