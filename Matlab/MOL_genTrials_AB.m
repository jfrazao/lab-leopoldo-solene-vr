
%% Define parameters:
par.number_trials   = 1000;
par.stim_loc_int    = [100 250];
par.frac_trial_A    = 0.5;
par.frac_trial_B    = 0.5;
par.rewardedstim    = 'A';

par.tex_A           = 'stim_parametric_1_1';
par.tex_B           = 'stim_parametric_1_5';
par.tex_C           = 'stim_parametric_5_1';
par.tex_D           = 'stim_parametric_5_5';

%% Generate CSV
trials = struct();

%% trialnumber:
trials.trialnum = transpose(1:par.number_trials);

%% Generate block-shuffled trial types:
trials.trialtype = '';
block                   = 10;
for bl = 1:ceil(par.number_trials/block)
    seq = '';
    seq = [seq repmat('A',1,floor(par.frac_trial_A * block) + double(rand<mod(par.frac_trial_A * block,1)))]; %#ok<*AGROW>
    seq = [seq repmat('B',1,floor(par.frac_trial_A * block) + double(rand<mod(par.frac_trial_A * block,1)))]; %#ok<*AGROW>

    seq = seq(1:block); %Trim until 10 trials
    
    trials.trialtype = [trials.trialtype seq(randperm(10))]; %Add trials to trialType vector in randomized order (block-scrambled)
end
trials.trialtype = trials.trialtype';

%% Set stimuli per trial type: 
trials.tex_Stim_Left_0  = cell(par.number_trials,1);
trials.tex_Stim_Right_0 = cell(par.number_trials,1);
% trials.tex_Stim_Left_1  = cell(par.number_trials,1);
% trials.tex_Stim_Right_1 = cell(par.number_trials,1);

trials.tex_Stim_Left_0(ismember(trials.trialtype,'A')) = {par.tex_A}; 
trials.tex_Stim_Right_0(ismember(trials.trialtype,'A')) = {par.tex_A}; 
% trials.tex_Stim_Left_1(ismember(trials.trialtype,'A')) = {par.tex_A}; 
% trials.tex_Stim_Right_1(ismember(trials.trialtype,'A')) = {par.tex_A}; 

trials.tex_Stim_Left_0(ismember(trials.trialtype,'B')) = {par.tex_B}; 
trials.tex_Stim_Right_0(ismember(trials.trialtype,'B')) = {par.tex_B}; 
% trials.tex_Stim_Left_1(ismember(trials.trialtype,'B')) = {par.tex_B}; 
% trials.tex_Stim_Right_1(ismember(trials.trialtype,'B')) = {par.tex_B}; 

%% Location of the stimuli:
trials.StimLocation0 = randi(par.stim_loc_int,[par.number_trials,1]);
% trials.StimLocation1 = trials.StimLocation0;

%% Set reward availability per trial:
trials.reward = ismember(trials.trialtype,par.rewardedstim);

%% Create and save the table:
table_trials = struct2table(trials);
writetable(table_trials,'MOL_trialseq_AB_discr.csv')

% %% Create and Save table
% %Table
% table_trials = cell2table(sequence, 'VariableNames', variable_names);
% %Save
% writetable(table_trials,'TrialSequence_Goncalo_ultimate.csv')

