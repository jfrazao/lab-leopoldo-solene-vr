
rootdir = 'M:\RawData\LPE12224';
filelist = dir(fullfile(rootdir, '**\*.csv'));  %get list of files and folders in any subfolder
filelist = filelist(~[filelist.isdir]);  %remove folders from list

for iF = 1:length(filelist)
    if contains(filelist(iF).name,'trialdata')
        file = filelist(iF).name;
        path = filelist(iF).folder;
        trialdata = readtable(fullfile(path,file));
        % trialdata = trialdata(1:100,:);

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
    end
end
