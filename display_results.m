% get data to disply
calculations;
%% we output everything to output.txt
disp("Writing data to 'output.txt'")
fileID = fopen('output.txt','w');
%% first display item sanity values
fprintf(fileID, "Calculated material sanity values:\n");
for i = 1 : numel(V)
    item_index = i;
    item_name = item_names{item_index};
    item_sanity_value = V(item_index);
    fprintf(fileID, "%s %f\n", item_name, item_sanity_value);
end
%% now sort stages by efficiency and display their drops
fprintf(fileID, "Calculated best farming stages:\n");
[tmp, sorted_stage_indices] = sort(Eff, 'descend');
% now display stage information
for i = 1 : numel(sorted_stage_indices)
    stage_index = sorted_stage_indices(i);
    stage_name = stage_and_craft_names{stage_index};
    stage_efficiency = Eff(stage_index);
    % we just skip stages with small efficiency
    efficiency_threshold = 0.90;
    if stage_efficiency < efficiency_threshold
        continue
    end
    % determine stage's drops
    stage_drops = D(stage_index,:);
    stage_drops_sanity_distribution = stage_drops.*V';
    [tmp, stage_drops_sanity_distribution_indices] = sort(stage_drops_sanity_distribution,'descend');
    % we dispaly stage's most valuable drops
    % not display drops with stage_drops_sanity_distribution = 0
    drops_to_display_num = 4;
    for j = 1 : drops_to_display_num
        if stage_drops_sanity_distribution(stage_drops_sanity_distribution_indices(j)) <= 0
            break
        end
    end
    drops_to_display_num = j - 1;
    notable_drops = "";
    for j = 1 : (drops_to_display_num-1)
        notable_drops = notable_drops + item_names{stage_drops_sanity_distribution_indices(j)} + ", ";
    end
    j = drops_to_display_num;
    notable_drops = notable_drops + item_names{stage_drops_sanity_distribution_indices(j)};
    fprintf(fileID, "%s %6.2f (%s)\n", stage_name, stage_efficiency, notable_drops);
end
%% display best event farming stages
fprintf(fileID, "Notable event farming stages:\n");
for i = 1 : numel(event_stage_names)
    % we don't sort them to preserve original order
    event_stage_index = i;
    event_stage_name = event_stage_names{i};
    event_stage_efficiency = event_Eff(event_stage_index);
    % we skip inefficient event stages
    efficiency_threshold = 1;
    if event_stage_efficiency < efficiency_threshold
        continue`
    end
    % determine event stage's drops
    event_stage_drops = event_D(event_stage_index,:);
    event_stage_drops_sanity_distribution = event_stage_drops.*V';
    [tmp, event_stage_drops_sanity_distribution_indices] = sort(event_stage_drops_sanity_distribution,'descend');
    % we dispaly stage's most valuable drops
    % not display drops with stage_drops_sanity_distribution = 0
    drops_to_display_num = 4;
    for j = 1 : drops_to_display_num
        if event_stage_drops_sanity_distribution(event_stage_drops_sanity_distribution_indices(j)) <= 0
            break
        end
    end
    drops_to_display_num = j - 1;
    notable_drops = "";
    for j = 1 : (drops_to_display_num-1)
        notable_drops = notable_drops + item_names{event_stage_drops_sanity_distribution_indices(j)} + ", ";
    end
    j = drops_to_display_num;
    notable_drops = notable_drops + item_names{stage_drops_sanity_distribution_indices(j)};
    fprintf(fileID, "%s %6.2f (%s)\n", event_stage_name, event_stage_efficiency, notable_drops);
end
%% close file
disp("Done")
fclose(fileID);
