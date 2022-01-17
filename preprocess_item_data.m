%% remove all unneeded items
item_data = raw_item_data;
field_names = fieldnames(raw_item_data);
for i = 1:numel(field_names)
    % keep sanity as item
    if raw_item_data.(field_names{i}).itemId == "AP_GAMEPLAY"
        continue
    end
    % keep Light Building Material
    if raw_item_data.(field_names{i}).itemId == "3131"
        continue
    end
    % only leave items with "obtainApproach": null
    if isempty(raw_item_data.(field_names{i}).obtainApproach) == 0
        item_data = rmfield(item_data, field_names{i});
    end
end
% remove orundum
item_data = rmfield(item_data, 'x4003');
% remove shop voucher
item_data = rmfield(item_data, 'x4006');
% remove originium shard
item_data = rmfield(item_data, 'x3141');
% remove chips
item_data = rmfield(item_data, 'x3211'); % vanguard
item_data = rmfield(item_data, 'x3212');
item_data = rmfield(item_data, 'x3213');
item_data = rmfield(item_data, 'x3221'); % guard
item_data = rmfield(item_data, 'x3222');
item_data = rmfield(item_data, 'x3223');
item_data = rmfield(item_data, 'x3231'); % defender
item_data = rmfield(item_data, 'x3232');
item_data = rmfield(item_data, 'x3233');
item_data = rmfield(item_data, 'x3241'); % sniper
item_data = rmfield(item_data, 'x3242');
item_data = rmfield(item_data, 'x3243');
item_data = rmfield(item_data, 'x3251'); % caster
item_data = rmfield(item_data, 'x3252');
item_data = rmfield(item_data, 'x3253');
item_data = rmfield(item_data, 'x3261'); % medic
item_data = rmfield(item_data, 'x3262');
item_data = rmfield(item_data, 'x3263');
item_data = rmfield(item_data, 'x3271'); % supporter
item_data = rmfield(item_data, 'x3272');
item_data = rmfield(item_data, 'x3273');
item_data = rmfield(item_data, 'x3281'); % specialist
item_data = rmfield(item_data, 'x3282');
item_data = rmfield(item_data, 'x3283');
% remove obsidian festival items (wut?)
item_data = rmfield(item_data, 'et_ObsidianPass');
item_data = rmfield(item_data, 'token_Obsidian');
item_data = rmfield(item_data, 'token_ObsidianCoin');
% remove obsidian festival rerun items (wut??)
item_data = rmfield(item_data, 'et_ObsidianPass_rep_1');
item_data = rmfield(item_data, 'token_Obsidian_rep_1');
item_data = rmfield(item_data, 'token_ObsidianCoin_rep_1');
%% Add Dossoles Holiday sticker items
% charm_coin_4
item_data.DH_150_cost_sticker.itemId = 'charm_coin_4';
item_data.DH_150_cost_sticker.name = 'Dossoles Holiday 150 cost sticker';
% trap_oxygen_3
item_data.DH_60_cost_sticker.itemId = 'trap_oxygen_3';
item_data.DH_60_cost_sticker.name = 'Dossoles Holiday 60 cost sticker';
% charm_r2
item_data.DH_40_cost_sticker.itemId = 'charm_r2';
item_data.DH_40_cost_sticker.name = 'Dossoles Holiday 40 cost sticker';
% charm_r1
item_data.DH_20_cost_sticker.itemId = 'charm_r1';
item_data.DH_20_cost_sticker.name = 'Dossoles Holiday 20 cost sticker';
% charm_coin_3
item_data.DH_18_cost_sticker.itemId = 'charm_coin_3';
item_data.DH_18_cost_sticker.name = 'Dossoles Holiday 18 cost sticker';
% charm_coin_2
item_data.DH_12_cost_sticker.itemId = 'charm_coin_2';
item_data.DH_12_cost_sticker.name = 'Dossoles Holiday 12 cost sticker';
% charm_coin_1
item_data.DH_9_cost_sticker.itemId = 'charm_coin_1';
item_data.DH_9_cost_sticker.name = 'Dossoles Holiday 9 cost sticker';