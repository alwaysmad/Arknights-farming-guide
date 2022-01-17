%% leave only farmable event stages
event_stage_data = raw_event_stage_data;
field_names = fieldnames(raw_event_stage_data);
for i = 1:numel(field_names)
    % remove stages that cost 0 sanity
    if raw_event_stage_data.(field_names{i}).apCost <= 0
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
%% add Dossoles Holiday infinite shop buys as event activities
%
event_stage_data.DH_store_Oriron_Cluster.stageId = 'DH_store_Oriron_Cluster';
event_stage_data.DH_store_Oriron_Cluster.code = 'Dossoles Holiday store: 1 Oriron Cluster for 50 stickers';
event_stage_data.DH_store_Oriron_Cluster.apCost = 0;
%
event_stage_data.DH_store_Manganese_Ore.stageId = 'DH_store_Manganese_Ore';
event_stage_data.DH_store_Manganese_Ore.code = 'Dossoles Holiday store: 1 Manganese Ore for 50 stickers';
event_stage_data.DH_store_Manganese_Ore.apCost = 0;
%
event_stage_data.DH_store_Orirock_Cluster.stageId = 'DH_store_Orirock_Cluster';
event_stage_data.DH_store_Orirock_Cluster.code = 'Dossoles Holiday store: 1 Orirock_Cluster for 35 stickers';
event_stage_data.DH_store_Orirock_Cluster.apCost = 0;