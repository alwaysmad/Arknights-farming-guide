%% construct map of activities of form:
% key - stage's/craft's index in game (they don't overlap)
% val - stage's/craft's number in drops matrix
key_set = {};
% add stageIds to key_set
field_names = fieldnames(main_stage_data);
for i = 1 : numel(field_names)
    key_set{i} = main_stage_data.(field_names{i}).stageId;
end
tmp = numel(field_names); % offset
% just add field_names of craft_data to key_set
field_names = fieldnames(craft_data);
for i = 1 : numel(field_names)
    key_set{i + tmp} = field_names{i};
end
value_set = 1 : (i + tmp);
activity_indices = containers.Map(key_set,value_set);
%% construct array of stages' and crafts' names
activity_names = {};
% add stages' code names
field_names = fieldnames(main_stage_data);
for i = 1 : numel(field_names)
    stage_index = activity_indices(main_stage_data.(field_names{i}).stageId);
    stage_name = main_stage_data.(field_names{i}).code;
    activity_names{stage_index} = stage_name;
end
% there are no craft names in game so we construct them and add
field_names = fieldnames(craft_data);
for i = 1 : numel(field_names)
    craft_index = activity_indices(field_names{i});
    craft_item_id = craft_data.(field_names{i}).itemId;
    craft_item_index = item_indices(craft_item_id);
    craft_item_name = item_names{craft_item_index};
    craft_name = "Craft: " + craft_item_name;
    activity_names{craft_index} = craft_name;
end