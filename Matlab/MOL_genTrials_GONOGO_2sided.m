%% Define parameters:
par.number_trials   = 2000;
par.stim_loc_int    = [150 210]; %start loc; corridor length=300cm stimsize = 80 cm
par.frac_GO         = 0.3;
par.frac_NOGO       = 0.7;

par.GOtextures      = {'stimA' 'stimB' 'stimC' 'stimD'};
par.NOGOtextures    = {'stimB' 'stimC' 'stimD' 'stimA'};

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
    
    trials.tex_Stim_Left(ismember(trials.trialtype,'G')) = par.GOtextures(i);
    trials.tex_Stim_Right(ismember(trials.trialtype,'G')) = par.GOtextures(i);
    
    trials.tex_Stim_Left(ismember(trials.trialtype,'N')) = par.NOGOtextures(i);
    trials.tex_Stim_Right(ismember(trials.trialtype,'N')) = par.NOGOtextures(i);
    
    % Create and save the table:
    table_trials = struct2table(trials);
    writetable(table_trials,sprintf('Trialseq_2sided_Sparse_%s.csv',par.GOtextures{i}))
end

