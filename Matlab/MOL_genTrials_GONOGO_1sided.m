%% Define parameters:
par.number_trials   = 1000;
par.stim_loc_int    = [150 210]; %start loc; corridor length=300cm stimsize = 80 cm
par.frac_GO         = 0.5;
par.frac_NOGO       = 0.5;

par.blocksize       = 50;

par.GOtextures      = {'stimA' 'stimB' 'stimC' 'stimD'};
par.NOGOtextures    = {'stimB' 'stimC' 'stimD' 'stimA'};
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
    seq = [seq repmat('G',1,floor(par.frac_GO * block) + double(rand<mod(par.frac_GO * block,1)))]; %#ok<*AGROW>
    seq = [seq repmat('N',1,floor(par.frac_NOGO * block) + double(rand<mod(par.frac_NOGO * block,1)))]; %#ok<*AGROW>

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

%% Location of the stimuli:
trials.StimLocation = randi(par.stim_loc_int,[par.number_trials,1]);

%% Set reward availability per trial:
trials.reward = ismember(trials.trialtype,'G');

%% Create scripts with different rewarded stimuli:
for i = 1:length(par.GOtextures)
    trials.tex_Stim_Left  = cell(par.number_trials,1);
    trials.tex_Stim_Right = cell(par.number_trials,1);
    
    trials.tex_Stim_Left(ismember(trials.trialtype,'G') & leftrelevanttrials==1) = par.GOtextures(i);
    trials.tex_Stim_Right(ismember(trials.trialtype,'G') & leftrelevanttrials==0) = par.GOtextures(i);
    
    trials.tex_Stim_Left(ismember(trials.trialtype,'N') & leftrelevanttrials==1) = par.NOGOtextures(i);
    trials.tex_Stim_Right(ismember(trials.trialtype,'N') & leftrelevanttrials==0) = par.NOGOtextures(i);
    
    trials.tex_Stim_Left(leftrelevanttrials==0)                                     = {par.tex_BG};
    trials.tex_Stim_Right(leftrelevanttrials==1)                                    = {par.tex_BG};

    % Create and save the table:
    table_trials = struct2table(trials);
    writetable(table_trials,sprintf('Trialseq_1sided_%s.csv',par.GOtextures{i}))
end

%%
% %% Create and save the table:
% table_trials = struct2table(trials);
% writetable(table_trials,'MOL_trialseq_AB_1sided.csv')


% trials.tex_Stim_Left(ismember(trials.trialtype,'A') & leftrelevanttrials==1)    = {par.tex_A}; 
% trials.tex_Stim_Right(ismember(trials.trialtype,'A') & leftrelevanttrials==0)   = {par.tex_A}; 
% 
% trials.tex_Stim_Left(ismember(trials.trialtype,'B') & leftrelevanttrials==1)    = {par.tex_B}; 
% trials.tex_Stim_Right(ismember(trials.trialtype,'B') & leftrelevanttrials==0)   = {par.tex_B}; 

% trials.tex_Stim_Left(leftrelevanttrials==0)                                     = {par.tex_BG}; 
% trials.tex_Stim_Right(leftrelevanttrials==1)                                    = {par.tex_BG}; 
