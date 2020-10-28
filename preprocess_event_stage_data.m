%% leave only farmable event stages
event_stage_data = raw_event_stage_data;
field_names = fieldnames(raw_event_stage_data);
for i = 1:numel(field_names)
    % remove stages that cost 0 sanity
    if raw_event_stage_data.(field_names{i}).apCost == 0
        event_stage_data = rmfield(event_stage_data, field_names{i});
        continue
    end
    % only leave event stages
    if not (raw_event_stage_data.(field_names{i}).stageType == "ACTIVITY")
        event_stage_data = rmfield(event_stage_data, field_names{i});
        continue
    end
    % remove challenge mode stages
    if raw_event_stage_data.(field_names{i}).difficulty == "FOUR_STAR"
        event_stage_data = rmfield(event_stage_data, field_names{i});
    end
end