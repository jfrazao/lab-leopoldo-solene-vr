
%% Define parameters:
par.number_trials   = 2000;
par.stim_loc_int    = [150 210]; %start loc; corridor length=300cm stimsize = 80 cm
par.frac_GO         = 0.3;
par.frac_NOGO       = 0.7;

% par.rewardedstim    = 'A';
par.blocksize       = 50;
par.contrastlevels  = [25 50 75 100];

par.GOtextures      = {'stimA' 'stimB' 'stimC' 'stimD'};
par.NOGOtextures    = {'stimB' 'stimC' 'stimD' 'stimA'};
par.DIST1textures   = {'stimC' 'stimD' 'stimA' 'stimB'};
par.DIST2textures   = {'stimD' 'stimA' 'stimB' 'stimC'};

% par.tex_A           = 'stim_parametric_1_1';
% par.tex_B           = 'stim_parametric_1_5';
% par.tex_C           = 'stim_parametric_5_1';
% par.tex_D           = 'stim_parametric_5_5';

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
    
    trials.tex_Stim_Left(ismember(trials.trialtype,'G') & leftrelevanttrials==1)    = par.GOtextures(i);
    trials.tex_Stim_Right(ismember(trials.trialtype,'G') & leftrelevanttrials==0)   = par.GOtextures(i);
    
    trials.tex_Stim_Left(ismember(trials.trialtype,'N') & leftrelevanttrials==1)    = par.NOGOtextures(i);
    trials.tex_Stim_Right(ismember(trials.trialtype,'N') & leftrelevanttrials==0)   = par.NOGOtextures(i);
    
    randvec = randi([0 1],par.number_trials,1); %random distractor stimuli
    trials.tex_Stim_Left(randvec==1 & leftrelevanttrials==0)                        = par.DIST1textures(i);
    trials.tex_Stim_Right(randvec==1 & leftrelevanttrials==1)                       = par.DIST1textures(i);
    
    trials.tex_Stim_Left(randvec==0 & leftrelevanttrials==0)                        = par.DIST2textures(i);
    trials.tex_Stim_Right(randvec==0 & leftrelevanttrials==1)                       = par.DIST2textures(i);

    % Create and save the table:
    table_trials = struct2table(trials);
    writetable(table_trials,sprintf('Trialseq_Distr_Full_%s.csv',par.GOtextures{i}))
end

%% Create scripts with different parameters for contrast versions of distractor stimuli:
for i = 1:length(par.GOtextures)
    for iC = par.contrastlevels
        %     backuptrials = trials;
        trials.tex_Stim_Left  = cell(par.number_trials,1);
        trials.tex_Stim_Right = cell(par.number_trials,1);
        
        trials.tex_Stim_Left(ismember(trials.trialtype,'G') & leftrelevanttrials==1)    = par.GOtextures(i);
        trials.tex_Stim_Right(ismember(trials.trialtype,'G') & leftrelevanttrials==0)   = par.GOtextures(i);
        
        trials.tex_Stim_Left(ismember(trials.trialtype,'N') & leftrelevanttrials==1)    = par.NOGOtextures(i);
        trials.tex_Stim_Right(ismember(trials.trialtype,'N') & leftrelevanttrials==0)   = par.NOGOtextures(i);
        
        randvec = randi([0 1],par.number_trials,1); %random distractor stimuli
        trials.tex_Stim_Left(randvec==1 & leftrelevanttrials==0)                        = {sprintf('%s_%d',par.DIST1textures{i},iC)};
        trials.tex_Stim_Right(randvec==1 & leftrelevanttrials==1)                       = {sprintf('%s_%d',par.DIST1textures{i},iC)};
        
        trials.tex_Stim_Left(randvec==0 & leftrelevanttrials==0)                        = {sprintf('%s_%d',par.DIST2textures{i},iC)};
        trials.tex_Stim_Right(randvec==0 & leftrelevanttrials==1)                       = {sprintf('%s_%d',par.DIST2textures{i},iC)};
        
        % Create and save the table:
        table_trials = struct2table(trials);
        writetable(table_trials,sprintf('Trialseq_Distr_Sparse_%d_%s.csv',iC,par.GOtextures{i}))
    end
end
