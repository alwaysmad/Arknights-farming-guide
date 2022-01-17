%% construct the event drop matrix
rows_num = event_activity_indices.size(1);
columns_num = item_indices.size(1);
event_D = zeros(rows_num, columns_num);
% D(stage/craft, item)
%% fill with drop rates from penguin statisctics (CN)
for i = 1 : numel(cn_drop_data)
    % skip entry if data is insufficient
    if cn_drop_data{i}.times < minimum_threshold
        continue
    end
    item_id = cn_drop_data{i}.itemId;
    % skip entry if it is related to item we don't consider
    if isKey(item_indices, item_id) == 0
        continue
    end
    stage_id = cn_drop_data{i}.stageId;
    % if entry is related to event story stages then we add data to D
    if isKey(event_activity_indices, stage_id) == 1
        % items and stages we consider here should not have field 'end'
        drop_rate = cn_drop_data{i}.quantity / cn_drop_data{i}.times;
        % should not interlap
        event_D(event_activity_indices(stage_id), item_indices(item_id)) = drop_rate;
    end
end
%% add sanity and LMD to event_D
sanity_item_index = item_indices('AP_GAMEPLAY');
LMD_item_index = item_indices('4001');
field_names = fieldnames(event_stage_data);
for i = 1 : numel(field_names)
    stage_id = event_stage_data.(field_names{i}).stageId;
    stage_index = event_activity_indices(stage_id);
    sanity_cost = event_stage_data.(field_names{i}).apCost;
    % that '-' is very important for calculation!
    event_D(stage_index, sanity_item_index) = -sanity_cost;
    % every stage drops 12*sanity LMD unless it's an LMD farnimg stage
    event_D(stage_index, LMD_item_index) = 12 * sanity_cost;
end
%% add Dossoles Holiday infinite shop buys
%
event_D(event_activity_indices('DH_store_Oriron_Cluster'), item_indices('30043')) = 1;
event_D(event_activity_indices('DH_store_Oriron_Cluster'), item_indices('charm_coin_1')) = -50/9;
%
event_D(event_activity_indices('DH_store_Manganese_Ore'), item_indices('30083')) = 1;
event_D(event_activity_indices('DH_store_Manganese_Ore'), item_indices('charm_coin_1')) = -50/9;
%
event_D(event_activity_indices('DH_store_Orirock_Cluster'), item_indices('30013')) = 1;
event_D(event_activity_indices('DH_store_Orirock_Cluster'), item_indices('charm_coin_1')) = -35/9;