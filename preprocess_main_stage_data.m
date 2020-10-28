%% remove all unfarmable stages
main_stage_data = raw_main_stage_data;
field_names = fieldnames(raw_main_stage_data);
for i = 1:numel(field_names)
    % remove stages that cost 0 sanity
    if raw_main_stage_data.(field_names{i}).apCost == 0
        main_stage_data = rmfield(main_stage_data, field_names{i});
    % remove annigilation stages
    elseif raw_main_stage_data.(field_names{i}).stageType == "CAMPAIGN"
        main_stage_data = rmfield(main_stage_data, field_names{i});
    % remove event stages, they will be processed sepatately
    elseif raw_main_stage_data.(field_names{i}).stageType == "ACTIVITY"
        main_stage_data = rmfield(main_stage_data, field_names{i});
    % remove challenge mode stages
    elseif raw_main_stage_data.(field_names{i}).difficulty == "FOUR_STAR"
        main_stage_data = rmfield(main_stage_data, field_names{i});
    end
end
% remove H5-x and H6-x stages
main_stage_data = rmfield(main_stage_data, 'hard_05_01');
main_stage_data = rmfield(main_stage_data, 'hard_05_02');
main_stage_data = rmfield(main_stage_data, 'hard_05_03');
main_stage_data = rmfield(main_stage_data, 'hard_05_04');
main_stage_data = rmfield(main_stage_data, 'hard_06_01');
main_stage_data = rmfield(main_stage_data, 'hard_06_02');
main_stage_data = rmfield(main_stage_data, 'hard_06_03');
main_stage_data = rmfield(main_stage_data, 'hard_06_04');