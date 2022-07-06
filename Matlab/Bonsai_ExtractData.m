%% Upload CSV with data (temporary solution)

%%%%%%%%%%%%%%%% After uploading...
%(temporary solution to allocate data into a variable)
%harp_data = harp_data_test;


%% Smooth z pos trace (resample, get rid of jumps) and make it continuous


%% Extract timestamps of optogentic stimulation and plot it with zpos
% Get opto timestamps (1st column is ON, 2nd if OFF)
opto_time = opto_timings(harp_data);

% Plot z pos with opto
figure()
% Plot z pos
plot(harp_data(:,3))
% Plot opto triggers
hold on
for i = 1:size(opto_time,1)
    rectangle('Position', [opto_time(i,1) 0 [opto_time(i,2)-opto_time(i,1)] 400], 'FaceColor', [.25, .25, .25, 0.9], 'LineStyle', 'none')
end


%% Plot now with reward
% Get reward timestamps (1st column is ON, 2nd if OFF)
reward_time = reward_timings(harp_data);

% Plot z pos with opto
figure()
% Plot z pos
plot(harp_data(:,3))
% Plot opto and reward triggers
hold on
for i = 1:size(opto_time,1)
    rectangle('Position', [opto_time(i,1) 0 [opto_time(i,2)-opto_time(i,1)] 400], 'FaceColor', [.25, .25, .25, 0.9], 'LineStyle', 'none')
end

for i = 1:size(reward_time,1)
    rectangle('Position', [reward_time(i,1) 0 [reward_time(i,2) - reward_time(i,1)] 400], 'FaceColor', 'r', 'LineStyle', 'none')
end



%% Velocity (testing...)

% speed_slow = harp_data_slow(:,7);
% speed_fast = harp_data_fast(:,7);
% 
% 
% % temporary
% 
% speed_slow(speed_slow > 200 | speed_slow < -50) = NaN;
% speed_fast(speed_fast > 200 | speed_fast < -50) = NaN;
% 
% slow_golay_5 = smooth(speed_slow, 5, 'sgolay', 2);
% fast_golay_5 = smooth(speed_fast, 5, 'sgolay', 2);
% 
% slow_golay_5 = resample(slow_golay_5,1,100);
% fast_golay_5 = resample(fast_golay_5,1,100);
% 
% % x_axis = (1:numel(speed_slow_filtered)) / 1000;
% % x_axis = resample(x_axis,1,200);
% % x_axis = x_axis/60;
% 
% plot(x_axis,slow_golay_20)



%% Separate Trials
%for harp_data_fast......
mat_test = harp_data(:,3);

flipped = flip(mat_test);
diff_values = diff(flipped);
diff_ordered = flip(diff_values);

% find idx in the data to differentiate trials
idx_values = find(diff_ordered(:,1) > 200);
idx_values = idx_values + 1;
idx_values = vertcat(1,idx_values);


% Separate trials
vectors = cell(numel(idx_values), 1);
for i = 1:numel(vectors)-1
    vectors{i,1} = harp_data(idx_values(i) : idx_values(i+1)-1,:); 
end


%% Smooth velocity...
% 
% num_trials = numel(vectors)-1;
% velocity_data = cell(num_trials,1);
% for i = 1:numel(velocity_data)
%    velocity_data{i,1} = vectors{i,1}(:,7);
%    
%    % remove peaks (5voltage peak)
%    temp_data = velocity_data{i,1};
%    temp_data(temp_data > 150 | temp_data < -50) = NaN;
%    velocity_data{i,2} = temp_data;
%    temp_data = [];
%    
%    
%    %smooth using sgolay filter
%    velocity_data{i,3} = smooth(velocity_data{i,2}, 5, 'sgolay', 2);
%    
%    %remove values also based on velocity
%    temp_data = velocity_data{i,3};
%    idx = find(temp_data < -150);
%    velocity_data{i,3}(idx,1) = NaN;
%    velocity_data{i,2}(idx,1) = NaN;
%    
%    
%    % resample the trace
%    %velocity_data{i,4} = resample(velocity_data{i,3},1,100);
%    sampling_rate = [];
%    sampling_rate = 1:100:numel(velocity_data{i,3});
%    velocity_data{i,4} = velocity_data{i,3}(sampling_rate,1);
%  
% end


%% Smooth velocity... (based on position smoothed, instead of smoothing the velocity values obtained from Bonsai directly)

num_trials = numel(vectors)-1;
position_velocity = cell(num_trials,1);
for i = 1:numel(position_velocity)
   
   % Get position first (not smoothed)
   %(1st column)
   position_velocity{i,1} = vectors{i,1}(:,3);
   
   % Get position smoothed
   %(2nd column)
   position_velocity{i,2} = smooth(cell2mat(position_velocity(i,1)));
   
   % Get velocity based on position smoothed
   %(3rd column)
   velocity = diff(smooth(cell2mat(position_velocity(i,2))));
   position_velocity{i,3} = velocity * 1000;
   
   % Velocity directly from bonsai data (result is the same)
   % velocity = vectors{i,1}(:,9);
   % position_velocity{i,4} = velocity;
   velocity = [];
   
   % remove peaks (5voltage peak) - larger than 60, smaller then -10 ??????
   temp_data = position_velocity{i,3};
   %temp_data(temp_data > 60 | temp_data < -10) = NaN;
   %position_velocity{i,3} = temp_data;
   temp_data = [];
   
   % resample the trace (not necessary...)
%    sampling_rate = 1:50:numel(position_velocity{i,3});
%    position_velocity{i,4} = position_velocity{i,3}(sampling_rate,1);
%    sampling_rate = [];
   
%    %smooth using sgolay filter
%    velocity_data{i,3} = smooth(velocity_data{i,2}, 5, 'sgolay', 2);
%    
%    %remove values also based on velocity
%    temp_data = velocity_data{i,3};
%    idx = find(temp_data < -150);
%    velocity_data{i,3}(idx,1) = NaN;
%    velocity_data{i,2}(idx,1) = NaN;
    
end


%% Add trials together (mean velocity - 5cm bins)
% Bin velocity
bins = 5;
vec_bin = 0:5:400;

final_velocity = zeros(num_trials, numel(vec_bin)-1);
for i = 1:numel(vectors)-1
    position_vec = cell2mat(position_velocity(i,2));
    position_vec = position_vec(1:end-1);
    velocity_vec = cell2mat(position_velocity(i,3));
    %velocity_vec = cell2mat(position_velocity(i,4));
    
    for k = 1:numel(vec_bin)-1
        velocity_bin_values = velocity_vec(vec_bin(k) <= position_vec(:,1) &  position_vec(:,1) <= vec_bin(k+1));
        final_velocity(i,k) = mean(velocity_bin_values);
    end
    position_vec = [];
    velocity_vec = [];
end


%% Test error bar
x = 1:size(final_velocity,2);
y = final_velocity;


% Interpolate NaN values
for i = 1:size(final_velocity,1)
   if sum(isnan(y(i,:))) > 0
       a = y(i,:);
       a(isnan(a)) = interp1(x(~isnan(a)),a(~isnan(a)),x(isnan(a)));
       y(i,:) = a;
   else
   end
end

clear vectors

%% Change this y(i) and y_mean(i) (temporary solution)
%y1 = y;
%y_mean1 = mean(y);
bin_velocity{1,1} = y;
bin_velocity{1,2} = mean(y);


%% Plot
%[cb] = cbrewer('qual', 'Dark2', 7, 'pchip');
[cb_stim] = cbrewer('qual', 'Paired', 9, 'pchip');

figure()
s1 = shadedErrorBar(x, bin_velocity{1,2}, std(bin_velocity{1,1}), 'lineprops',{'-','Color',cb_stim(1,:)}, 'patchSaturation',0.6);

% Set face and edge properties
set(s1.edge,'LineWidth',2,'LineStyle',':')
s1.mainLine.LineWidth = 5;
s1.patch.FaceColor = cb_stim(1,:);

% Overlay data points post-hoc
hold on
plot(s1.mainLine.XData, s1.mainLine.YData,'o','MarkerFaceColor',cb_stim(1,:), 'MarkerEdgeColor', 'k')
hold on

%ylim([0 20])
sessions_axis = 50:50:400;
ax = gca;
ax.XTick = 10:10:400;
ax.XTickLabel = sessions_axis;


%% Uncomment do add textures

hold on
rectangle('Position', [13 0 8 50], 'FaceColor', [.25, .25, .25, 0.25], 'LineStyle', 'none')
rectangle('Position', [34 0 8 50], 'FaceColor', [.25, .25, .25, 0.25], 'LineStyle', 'none')
rectangle('Position', [55 0 8 50], 'FaceColor', [.25, .25, .25, 0.25], 'LineStyle', 'none')
rectangle('Position', [76 0 4 50], 'FaceColor', [[0.6350 0.0780 0.1840], 0.25], 'LineStyle', 'none')

