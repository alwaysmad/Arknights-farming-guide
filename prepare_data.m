% run script that provides item_data, craft_data, stage_data and drop_data
get_data;
disp("Processing data")
% In this script id is referred as id in game files
% and index is index in drop matrix D
%% construct map of items' indices of form:
% key - item's index in game
% val - item's number in drops matrix
key_set = {};
field_names = fieldnames(item_data);
value_set = 1 : numel(field_names);
for i = 1 : numel(field_names)
    key_set{i} = item_data.(field_names{i}).itemId;
end
item_indices = containers.Map(key_set,value_set);
%% construct array of item names
item_names = {};
for i = 1 : numel(field_names)
    item_name = item_data.(field_names{i}).name;
    item_index = item_indices(item_data.(field_names{i}).itemId);
    item_names{item_index} = item_name;
end
%% construct map of stages'/crafts' indices of form:
% key - stage's/craft's index in game (they don't overlap)
% val - stage's/craft's number in drops matrix
key_set = {};
% add stageIds to key_set
field_names = fieldnames(stage_data);
for i = 1 : numel(field_names)
    key_set{i} = stage_data.(field_names{i}).stageId;
end
tmp = numel(field_names); % offset
% just add field_names of craft_data to key_set
field_names = fieldnames(craft_data);
for i = 1 : numel(field_names)
    key_set{i + tmp} = field_names{i};
end
value_set = 1 : (i+tmp);
stage_and_craft_indices = containers.Map(key_set,value_set);
%% construct array of stages' and crafts' names
stage_and_craft_names = {};
% add stages' code names
field_names = fieldnames(stage_data);
for i = 1 : numel(field_names)
    stage_index = stage_and_craft_indices(stage_data.(field_names{i}).stageId);
    stage_name = stage_data.(field_names{i}).code;
    stage_and_craft_names{stage_index} = stage_name;
end
% there are no craft names in game so we construct them and add
field_names = fieldnames(craft_data);
for i = 1 : numel(field_names)
    craft_index = stage_and_craft_indices(field_names{i});
    craft_item_id = craft_data.(field_names{i}).itemId;
    craft_item_index = item_indices(craft_item_id);
    craft_item_name = item_names{craft_item_index};
    craft_name = "Craft: " + craft_item_name;
    stage_and_craft_names{craft_index} = craft_name;
end
%% construct array of stages'/crafts' sanity costs
% add stages' sanity costs to value_set
stage_and_craft_sanity_costs = {};
field_names = fieldnames(stage_data);
for i = 1 : numel(field_names)
    stage_index = stage_and_craft_indices(stage_data.(field_names{i}).stageId);
    sanity_cost = stage_data.(field_names{i}).apCost;
    stage_and_craft_sanity_costs{stage_index} = sanity_cost;
end
% crafts cost 0 santy
field_names = fieldnames(craft_data);
for i = 1 : numel(field_names)
    craft_index = stage_and_craft_indices(field_names{i});
    stage_and_craft_sanity_costs{craft_index} = 0;
end
%% construct map of event stages' indices of form:
% key - event stage's index in game
% val - event stage's number in drops matrix
key_set = {};
% add stageIds to key_set
field_names = fieldnames(event_stage_data);
for i = 1 : numel(field_names)
    key_set{i} = event_stage_data.(field_names{i}).stageId;
end
value_set = 1 : numel(field_names);
event_stage_indices = containers.Map(key_set,value_set);
%% construct array of event stage names
event_stage_names = {};
for i = 1 : numel(field_names)
    event_stage_names{i} = event_stage_data.(field_names{i}).code;
end
%% finily we construct the drop matrix
rows_num = stage_and_craft_indices.size(1);
columns_num = item_indices.size(1);
D = zeros(rows_num, columns_num);
% now fill it...
% D(stage/craft, item)
%% consrtuct drop matrix for event stages
rows_num = event_stage_indices.size(1);
columns_num = item_indices.size(1);
event_D = zeros(rows_num, columns_num);
%% drop rates from penguin statisctics
% we ignore stages that have less than this samples
minimum_threshold = 100;
for i = 1 : numel(drop_data)
    % skip entry if data is insufficient
    if drop_data{i}.times < minimum_threshold
        continue
    end
    item_id = drop_data{i}.itemId;
    % skip entry if it is related to item we don't consider
    if isKey(item_indices, item_id) == 0
        continue
    end
    stage_id = drop_data{i}.stageId;
    % if entry is related to main story stages then we add data to D
    if isKey(stage_and_craft_indices, stage_id) == 1
        % items and stages we consider here should not have field 'end'
        drop_rate = drop_data{i}.quantity / drop_data{i}.times;
        D(stage_and_craft_indices(stage_id), item_indices(item_id)) = drop_rate;
    end
    % if entry is related to event story stages then we add data to event_D
    if isKey(event_stage_indices, stage_id) == 1
        drop_rate = drop_data{i}.quantity / drop_data{i}.times;
        event_D(event_stage_indices(stage_id), item_indices(item_id)) = drop_rate;
    end
end
%% add sanity and LMD to D
% penguin statistics doesn't give LMD drop rate but main story stages that
% drop LMD are inferior to CE-5 so im not even gonna add these drops cause
% these maps are garbage to farm anyways 
sanity_item_index = item_indices('AP_GAMEPLAY');
LMD_item_index = item_indices('4001');
for i = 1 : numel(stage_and_craft_sanity_costs)
    % that '-' is very important for calculation!
    D(i, sanity_item_index) = -stage_and_craft_sanity_costs{i};
    % every stage drops 12*sanity LMD unless it's an LMD farnimg stage
    D(i, LMD_item_index) = 12 * stage_and_craft_sanity_costs{i};   
end
%% add sanity and LMD to event_D
field_names = fieldnames(event_stage_data);
for i = 1 : numel(field_names)
    event_stage_index = event_stage_indices(event_stage_data.(field_names{i}).stageId);
    sanity_cost = event_stage_data.(field_names{i}).apCost;
    event_D(event_stage_index, sanity_item_index) = -sanity_cost;
    event_D(event_stage_index, LMD_item_index) = 12 * sanity_cost;
end
%% add crafting with by-product to D
% we consider that crafting is conducted with a +80% by-product rate
% operator. If you use Nian you can change this value to 2 but I doubt 
% if it will make much difference
operator_skill_by_product_rate = 1.8;
field_names = fieldnames(craft_data);
for i = 1 : numel(field_names)
    craft_index = stage_and_craft_indices(field_names{i});
    % add the main craft product to D
    item_id = craft_data.(field_names{i}).itemId;
    item_index = item_indices(item_id);
    item_count = craft_data.(field_names{i}).count;
    D(craft_index, item_index) = item_count;
    % add LMD cost
    LMD_cost = craft_data.(field_names{i}).goldCost;
    D(craft_index, LMD_item_index) = -LMD_cost;
    % add material cost
    for j = 1 : numel(craft_data.(field_names{i}).costs)
        item_id = craft_data.(field_names{i}).costs(j).id;
        item_index = item_indices(item_id);
        item_count = craft_data.(field_names{i}).costs(j).count;
        D(craft_index, item_index) = -item_count;
    end
    % now add by-products
    by_product_rate = craft_data.(field_names{i}).extraOutcomeRate * operator_skill_by_product_rate;
    % calculate weight sum
    weigth_sum = 0;
    for j = 1 : numel(craft_data.(field_names{i}).extraOutcomeGroup)
        weigth_sum = weigth_sum + craft_data.(field_names{i}).extraOutcomeGroup(j).weight;
    end
    % now calculate by-products' rates and add them to D
    for j = 1 : numel(craft_data.(field_names{i}).extraOutcomeGroup)
        by_product = craft_data.(field_names{i}).extraOutcomeGroup(j);
        item_id = by_product.itemId;
        item_index = item_indices(item_id);
        item_count = by_product.itemCount;
        rate = by_product.weight / weigth_sum;
        rate = rate * item_count * by_product_rate;
        % the filed in D possibly already filled with cost so we add rate
        D(craft_index, item_index) = D(craft_index, item_index) + rate;
    end
end
% now D is finaly filled