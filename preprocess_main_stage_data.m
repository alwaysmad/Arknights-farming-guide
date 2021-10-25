%% remove all unfarmable stages
main_stage_data = raw_main_stage_data;
field_names = fieldnames(raw_main_stage_data);
% now we need to include interlude and sidestory stages
for i = 1:numel(field_names)
    % remove stages that cost 0 sanity
    if raw_main_stage_data.(field_names{i}).apCost == 0
        main_stage_data = rmfield(main_stage_data, field_names{i});
        continue;
    end
    % remove challenge mode stages
    if raw_main_stage_data.(field_names{i}).difficulty == "FOUR_STAR"
        main_stage_data = rmfield(main_stage_data, field_names{i});
        continue;
    end
    % only keep main story stages, event stages and supply stages
    if raw_main_stage_data.(field_names{i}).stageType ~= "MAIN" && ...
            raw_main_stage_data.(field_names{i}).stageType ~= "SUB" && ...
            raw_main_stage_data.(field_names{i}).stageType ~= "ACTIVITY" && ...
            raw_main_stage_data.(field_names{i}).stageType ~= "DAILY"
        main_stage_data = rmfield(main_stage_data, field_names{i});
        continue;
    end
%     % keep event stages that are available in interlude and sidestory
%     if raw_main_stage_data.(field_names{i}).stageType == "ACTIVITY"
%         if raw_main_stage_data.(field_names{i}).code == "OF-F1" continue; end
%         if raw_main_stage_data.(field_names{i}).code == "OF-F2" continue; end
%         if raw_main_stage_data.(field_names{i}).code == "OF-F3" continue; end
%         if raw_main_stage_data.(field_names{i}).code == "OF-F4" continue; end
%     end
%     % remove all other event stages
%     if raw_main_stage_data.(field_names{i}).stageType == "ACTIVITY"
%        main_stage_data = rmfield(main_stage_data, field_names{i});
%        continue;
%     end 
end