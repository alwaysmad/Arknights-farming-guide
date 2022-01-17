for field_name = fieldnames(event_stage_data)'
    % copy farmable Dossoles holyday stages to main_stage_data
    if ismember(event_stage_data.(field_name{1}).code, ...
            ['DH-1', 'DH-2', 'DH-3', 'DH-4', 'DH-6', 'DH-7', 'DH-8', 'DH-9'])
        main_stage_data.(field_name{1}) = event_stage_data.(field_name{1});
    end
end