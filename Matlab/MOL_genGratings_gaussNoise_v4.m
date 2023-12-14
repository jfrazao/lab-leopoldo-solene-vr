%% MOL_genGratings_ with gaussian noise to have feedforward variability

%% Define parameters:
par.ori             = [30 90 150];      %center orientations degrees
par.speed           = [12.5 50 200];    %center speeds
par.speed           = [10 40 160];    %center speeds
par.Contrast        = 0.7; %0-1 contrast
par.Phase           = 0; %0-1 starting phase

nOris               = length(par.ori);
nSpeeds             = length(par.speed);

%Noise dimensions (ori and speed)
par.stdOri          = 20; %deg (span of degrees around center orientation)
par.stdSpeed        = 0.15; %in percent of deg/s %on logarithmic scale
par.stdContr        = 0; %0-1 contrast
par.stdPhase        = 0; %

par.nrep            = 300;
par.ntrials         = nOris * nSpeeds * par.nrep;

% Output is .csv like this:
% Trial,Orientation,TF,SF,Contrast,Phase
% 1,90,2,0.04,0.80,0
% 2,30,2,0.04,0.30,0
% 3,0,2,0.04,0.80,0
% 4,180,2,0.04,0.40,0
% 5,330,2,0.04,0.80,0
% 6,210,2,0.04,0.80,0
% 7,180,2,0.04,0.40,0
% 8,0,4,0.08,0.80,0
% 9,210,2,0.04,0.80,0
% 10,180,2,0.04,0.40,0
% 11,30,2,0.04,0.80,0
% 12,210,2,0.04,0.80,0

% PM: pref 1.5 Hz 0.08 cpd: 18.75 deg/s
% AL: pre 4 Hz 0.025 cpd: 160 deg/s

%% decomposition of speed into TF and SF is based on these anchorpoints:
par.TF              = [1 2.5 4]; %Hz
par.SF              = [5/30 3/30 1/30]; %cpd
% par.SF              = [5/25 3/25 1/25]; %cpd
% par.SF              = [0.12 0.08 0.04]; %cpd
%these are fit with a linear regression and the equation is used to map
%speed to TF and SF
% par.TF./par.SF
par.speed           = par.TF./par.SF;    %center speeds

%% Plot SF and TF combination, fit regression line to get fixed combination to obtain speed
figure(); hold all;
plot(par.SF,par.TF,'k.','MarkerSize',20)
set(gca,'Xlim',[0 0.15],'Ylim',[0 8])
set(gca,'Xlim',[0 0.2],'Ylim',[0 6])

tbl = table(par.SF',par.TF');
b = fitlm(tbl);
coef = table2array(b.Coefficients);
plot(b)

% coef = [7.5;-50];
targetspeed = 67;
SF =  coef(1,1) / (targetspeed - coef(2,1));
TF = coef(2,1)*SF + coef(1,1);

plot([0 SF],[0 TF],'b-','LineWidth',0.5)
plot(SF,TF,'b.','MarkerSize',15)

% if targetspeed = 200:
% TF + 50*SF = 7.5
% TF - 200*SF = 0
% --> 0 - 250X = -7.5
% --> X = -7.5/-250, then plug in X for Y

%% Generate CSV
trials = struct();

%% trialnumber:
trials.trialnum = transpose(1:par.ntrials);

%% Generate block-shuffled orientation:
trials.Orientation                   = []; %shuffle block (not stimulus side block)
for iRep = 1:par.nrep*nSpeeds
    trials.Orientation = [trials.Orientation; par.ori(randperm(nOris))']; %Add trials to trialType vector in randomized order (block-scrambled)
end

trials.Orientation = trials.Orientation + (rand(par.ntrials,1)-0.5)*par.stdOri;
trials.Orientation = mod(trials.Orientation,360);

%% Generate block-shuffled Speed:
trialspeeds = [];
for iRep = 1:par.nrep*nSpeeds
    order = randperm(nSpeeds); 
    trialspeeds = [trialspeeds; par.speed(order)']; %Add trials to trialType vector in randomized order (block-scrambled)
end

%add noise:
temp = log10(trialspeeds);
temp = temp + (rand(par.ntrials,1)-0.5) * 2 * par.stdSpeed;
trialspeeds = 10.^temp;



%% Derive TF and SF from speed: 
SF =  coef(1,1) ./ (trialspeeds - coef(2,1));
TF = coef(2,1)*SF + coef(1,1);
figure(); set(gcf,'color','w')
plot(SF,TF,'k.','MarkerSize',12)
xlabel('Spatial Freq')
ylabel('Temporal Freq')
title('SF and TF with fixed speed')

trials.TF                       = TF; % store TF
trials.SF                       = SF; %SF
trials.Speed                    = trialspeeds; % speed

%% Rest:
trials.Contrast     = repmat(par.Contrast,par.ntrials,1)    + (rand(par.ntrials,1)-0.5) * 2 * par.stdContr;
trials.Contrast(trials.Contrast>1) = 1;
trials.Phase        = repmat(par.Phase,par.ntrials,1)    + (rand(par.ntrials,1)-0.5) * 2 * par.stdPhase;

%% Create and save the table:
table_trials = struct2table(trials);
writetable(table_trials,'MOL_OriGrating_gaussNoise_v4.csv')

%% Show results:
figure(); set(gcf,'color','w')
scatter(trials.Orientation,trials.Speed,10,'k.')
set(gca,'yscale','log','Xlim',[0 180],'Ylim',[5 300])
set(gca,'yscale','log','Xlim',[0 180],'Ylim',[3 200])
xlabel('Orientation')
ylabel('Speed')
