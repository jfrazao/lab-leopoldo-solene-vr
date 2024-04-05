function trials = removeTrialTypeRepetitions(trials)

signals = unique(trials.signal);
for i= 3:length(trials.signal)
    if trials.signal(i) == trials.signal(i-1) && trials.signal(i) == trials.signal(i-2)
        c = histcounts(trials.signal(max(1,i-15):i),signals);
        h = c == min(c);
        trials.signal(i) = signals(randsample(find(h),1));
    end
end
end