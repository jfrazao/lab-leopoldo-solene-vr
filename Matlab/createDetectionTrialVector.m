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

    seq = [seq 0]; % add 0% trial just in case

    seq = seq(1:block); %Trim until 10 trials
    
    signal = [signal; seq(randperm(10))'];
end

signal       = round(signal);

end
