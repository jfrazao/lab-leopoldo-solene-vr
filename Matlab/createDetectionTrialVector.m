function signal = createDetectionTrialVector(par)

signal = [];

%This makes a vector of trial types with scrambled blocks.
%First creates vector with trial types according to probabilities then adds scrambled order to main vector.
block                   = 10; %every X trials contain shuffled percentage of each condition
for bl = 1:ceil(par.number_trials/block)
    seq = []; 
    for f = 1:length(par.fracs )
        seq = [seq repmat(par.signals(f),1,floor(par.fracs(f)*block) + double(rand<mod(par.fracs(f)*block,1)))]; %#ok<*AGROW>
    end
%         
%     if par.frac0
%         seq = [seq repmat(0,1,floor(par.frac0*block) + double(rand<mod(par.frac0*block,1)))]; %#ok<*AGROW>
%     end
%     if par.frac100
%         seq = [seq repmat(100,1,floor(par.frac100*block) + double(rand<mod(par.frac100*block,1)))]; %#ok<*AGROW>
%     end
%     if par.fracthr
%         seq = [seq repmat(par.thr,1,floor(par.fracthr*block) + double(rand<mod(par.fracthr*block,1)))]; %#ok<*AGROW>
%     end
    seq = [seq 0]; % add 0% trial just in case

    seq = seq(1:block); %Trim until 10 trials
    
    signal = [signal; seq(randperm(10))'];
end

signal       = round(signal);

% force consecutive probe trials to be max signal:
% D = diff([0; signal])==0;
% signal(D==1);
% signal(signal==0);
% signal(D==1 & signal==0) = par.signals(end);

end
