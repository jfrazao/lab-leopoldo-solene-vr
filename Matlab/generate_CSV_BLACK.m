
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Protocol with a total of 5 conditions
% Define number of trials
number_trials = 300;

%% Generate CSV
%variable_names = {'corridorID','nameTex0','nameTex1','nameText2','reward','RewardLocation','Opto','OptoStimLocation'};
variable_names = {'corridorID','nameTex0','nameTex1','nameText2','background','RewardLocation','OptoStimLocation'};

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

trials = cell(4,7);

% Main Condition
trials(1,:) = {1, text0, text1, text2, 'fwn1', 380, 170};

% Catch #1 - Opto at the 3rd grating (instead of the 2nd)
trials(2,:) = {2, text0, text1, text2, 'fwn1', 380, 275};

% Catch #2 - Full black corridor with opto at the 2nd grating location
trials(3,:) = {3, 'black_background', 'black_background', 'black_background', 'black_background', 380, 170};

% Catch #3 - Full black corridor without opto
trials(4,:) = {4, 'black_background', 'black_background', 'black_background', 'black_background', 380, 500};



% % Catch #2 - Omission of the 2nd grating with opto
% trials(3,:) = {3, text0, 'fwn1', text2, 'fwn1', 380, 170};
% 
% % Catch #3 - No Opto
% trials(4,:) = {4, text0, text1, text2, 'fwn1', 380, 500};
% 
% % Catch #4 - Full black corridor with opto at the 2nd grating location
% trials(5,:) = {5, 'black_background', 'black_background', 'black_background', 'black_background', 380, 170};


%% Generate the sequence based on the probabilities (NO CONDITIONS YET)
prob = rand;
sequence = cell(number_trials,7);
for i = 1:number_trials
    prob = rand;
    
    if prob <= 0.79
        sequence(i,:) = trials(1,:); 
    elseif prob > 0.79 && prob <= 0.86
        sequence(i,:) = trials(2,:);
    elseif prob > 0.86 && prob <= 0.93
        sequence(i,:) = trials(3,:);
    elseif prob > 0.93
        sequence(i,:) = trials(4,:);
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
    if sequence{i,1} == 2 || sequence{i,1} == 3 || sequence{i,1} == 4
        sequence(i,:) = trials(1,:);
    end
end 

%% Create and Save table
%Table
table_trials = cell2table(sequence, 'VariableNames', variable_names);

%Save
writetable(table_trials,'TrialSequence_Goncalo_ultimate_BLACK.csv')