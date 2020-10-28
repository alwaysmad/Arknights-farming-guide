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
event_activity_indices = containers.Map(key_set,value_set);
%% construct array of event stage names
event_activity_names = {};
for i = 1 : numel(field_names)
    event_activity_names{i} = event_stage_data.(field_names{i}).code;
end