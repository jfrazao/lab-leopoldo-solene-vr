[file,path] = uigetfile('*.csv');

trialdata = readtable(fullfile(path,file));
% trialdata = trialdata(1:74,:);

if any("trialType" == string(trialdata.Properties.VariableNames))
    trialdata.Signal = trialdata.trialType;
end

signals = unique(trialdata.Signal);
nsignals = length(signals);
psydata  = nan(nsignals,1);

for iS = 1:nsignals
    idx = trialdata.Signal == signals(iS);
    psydata(iS) = sum(strcmp(trialdata.lickResponse(idx),'True')) / sum(idx);
end

figure();
set(gcf,'color','white')
plot(signals,psydata,'.-','LineWidth',1,'MarkerSize',30,'color','red')
xticks(signals)
xlim([-0.5,100])
ylim([0,1])
xlabel('Signal')
ylabel('Response')
title(strrep(file,'_','-'))

