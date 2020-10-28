% In this script id is referred as id in game files
% and index is index in drop matrix D
%% construct map of items' indices of form:
% key - item's index in game
% val - item's number in drops matrix
key_set = {};
field_names = fieldnames(item_data);
for i = 1 : numel(field_names)
    key_set{i} = item_data.(field_names{i}).itemId;
end
value_set = 1 : numel(field_names);
item_indices = containers.Map(key_set,value_set);
%% construct array of item names
item_names = {};
for i = 1 : numel(field_names)
    item_name = item_data.(field_names{i}).name;
    item_index = item_indices(item_data.(field_names{i}).itemId);
    item_names{item_index} = item_name;
end