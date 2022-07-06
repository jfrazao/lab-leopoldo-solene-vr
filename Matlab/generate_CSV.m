
%% Define number of trials
number_trials = 300;
%% Generate CSV
%variable_names = {'corridorID','nameTex0','nameTex1','nameText2','reward','RewardLocation','Opto','OptoStimLocation'};
variable_names = {'corridorID','nameTex0','nameTex1','nameText2','reward','RewardLocation','OptoStimLocation'};

%Uncomment the line with desired spatial frequency
text0 = '0_sf1_40';
%text0 = '0_sf1_20';
%text0 = '0_sf1_10';

text1 = 'minus15_sf1_40';
%text1 = 'minus15_sf1_20';
%text1 = 'minus15_sf1_10';

text2 = '15_sf1_40';
%text2 = '15_sf1_20';
%text2 = '15_sf1_10';

trials = cell(3,7);
trials(1,:) = {1, text0, text1, text2, 1, 380, 170};
trials(2,:) = {2, text0, text1, text2, 1, 380, 275};
trials(3,:) = {3, text0, 'fwn1', text2, 1, 380, 170};

%% Generate the sequence based on the probabilities (NO CONDITIONS YET)
prob = rand;
sequence = cell(number_trials,7);
for i = 1:number_trials
    prob = rand;
    
    if prob <= 0.86
        sequence(i,:) = trials(1,:); 
    elseif prob > 0.86 && prob <= 0.93
        sequence(i,:) = trials(2,:);
    elseif prob > 0.93
        sequence(i,:) = trials(3,:);
    end
   
end

%% Add conditions
% Avoid having 2 consecutive catch trials of the same type
for i = 1 : number_trials-1
    if sequence{i,1} == sequence{i+1,1}
        sequence(i+1,:) = trials(1,:);
    end
end

% Avoid having catch trials in the beginning of the session (first 10 trials??)
for i = 1 : 10
    if sequence{i,1} == 2 || sequence{i,1} == 3
        sequence(i,:) = trials(1,:);
    end
end 

%% Create and Save table
%Table
table_trials = cell2table(sequence, 'VariableNames', variable_names);

%Save
writetable(table_trials,'TrialSequence_Goncalo_ultimate.csv')

