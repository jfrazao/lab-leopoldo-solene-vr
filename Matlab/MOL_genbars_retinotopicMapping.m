%% MOL_genBars_retinotopicMapping
%% Define parameters:
par.nrep            = 40;
par.ori             = [0 : 90 : 270]; %orientations degrees
par.barwidth        = 15;   %retinal deg
par.barspeed        = 15;   %deg/s
par.xmin            = 0     - par.barwidth/2;  %retinal deg
par.xmax            = 135   + par.barwidth/2;  %retinal deg
par.ymin            = -15   - par.barwidth/2;  %retinal deg
par.ymax            = 45 	+ par.barwidth/2;  %retinal deg

nOris               = length(par.ori);
par.ntrials = nOris  * par.nrep;

% Output is .csv like this:
% Trial,Orientation,xstart,xend,ystart,yend,stimdur
% 1,45,-30,50,0,0,6.3


%% Generate CSV
trials = struct();

%% trialnumber:
trials.trialnum = transpose(1:par.ntrials);

%% Generate block-shuffled orientation:
trials.Orientation                   = []; %shuffle block (not stimulus side block)
for iRep = 1:par.nrep
    trials.Orientation = [trials.Orientation; par.ori(randperm(nOris))']; %Add trials to trialType vector in randomized order (block-scrambled)
end

%% Bar position start and end:
trials.xstart       = repmat(mean([par.xmin,par.xmax]),par.ntrials,1);
trials.xend         = repmat(mean([par.xmin,par.xmax]),par.ntrials,1);
trials.ystart       = repmat(mean([par.ymin,par.ymax]),par.ntrials,1);
trials.yend         = repmat(mean([par.ymin,par.ymax]),par.ntrials,1);

trials.xstart(trials.Orientation==0) = par.xmin;
trials.xend(trials.Orientation==0) = par.xmax;

trials.xstart(trials.Orientation==180) = par.xmax;
trials.xend(trials.Orientation==180) = par.xmin;

trials.ystart(trials.Orientation==90) = par.ymin;
trials.yend(trials.Orientation==90) = par.ymax;

trials.ystart(trials.Orientation==270) = par.ymax;
trials.yend(trials.Orientation==270) = par.ymin;

%% Stimulus duration:
trials.stimdur         = zeros(par.ntrials,1);
trials.stimdur(trials.Orientation==0 | trials.Orientation==180) = (par.xmax - par.xmin) / par.barspeed;
trials.stimdur(trials.Orientation==270 | trials.Orientation==90) = (par.ymax - par.ymin) / par.barspeed;

%% Create and save the table:
table_trials = struct2table(trials);
writetable(table_trials,'MOL_checkerBars_retinotopicMapping_rep40.csv')

