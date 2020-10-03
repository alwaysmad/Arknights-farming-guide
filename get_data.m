import matlab.net.*
import matlab.net.http.*
%% get item data
url = "https://raw.githubusercontent.com/Kengxxiao/ArknightsGameData/master/en_US/gamedata/excel/item_table.json";
uri = URI(url);
fprintf("Getting item data from %s\n", url)
r = RequestMessage;
resp = send(r,uri);
disp(resp.StatusCode); % show status code
tmp = jsondecode(resp.Body.string());
item_data = tmp.items;
%% remove all unneeded items
field_names = fieldnames(item_data);
for i = 1:numel(field_names)
    % keep sanity as item
    if item_data.(field_names{i}).itemId == "AP_GAMEPLAY"
        continue
    end
    % only leave items with "obtainApproach": null
    if isempty(item_data.(field_names{i}).obtainApproach) == 0
        item_data = rmfield(item_data, field_names{i});
    end
end
% remove orundum
item_data = rmfield(item_data, 'x4003');
% remove shop voucher
item_data = rmfield(item_data, 'x4006');
% remove skill summaries
item_data = rmfield(item_data, 'x3301');
item_data = rmfield(item_data, 'x3302');
item_data = rmfield(item_data, 'x3303');
% remove building materials
item_data = rmfield(item_data, 'x3112');
item_data = rmfield(item_data, 'x3113');
item_data = rmfield(item_data, 'x3114');
item_data = rmfield(item_data, 'x3132');
item_data = rmfield(item_data, 'x3133');
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
% remove furniture part
item_data = rmfield(item_data, 'x3401');
% remove obsidian festival items (wut?)
item_data = rmfield(item_data, 'et_ObsidianPass');
item_data = rmfield(item_data, 'token_Obsidian');
item_data = rmfield(item_data, 'token_ObsidianCoin');
%% get craft data
url = "https://raw.githubusercontent.com/Kengxxiao/ArknightsGameData/master/en_US/gamedata/excel/building_data.json";
uri = URI(url);
fprintf("Getting craft data from %s\n", url)
r = RequestMessage;
resp = send(r,uri);
disp(resp.StatusCode); % show status code
tmp = jsondecode(resp.Body.string());
craft_data = tmp.workshopFormulas;
%% leave only recipes related to materials
field_names = fieldnames(craft_data);
for i = 1:numel(field_names)
    if not (craft_data.(field_names{i}).formulaType == "F_EVOLVE")
        craft_data = rmfield(craft_data, field_names{i});
    end
end
%% get stage data
url = "https://raw.githubusercontent.com/Kengxxiao/ArknightsGameData/master/en_US/gamedata/excel/stage_table.json";
uri = URI(url);
fprintf("Getting stage data from %s\n", url)
r = RequestMessage;
resp = send(r,uri);
disp(resp.StatusCode); % show status code
tmp = jsondecode(resp.Body.string());
stage_data = tmp.stages;
event_stage_data = stage_data;
%% remove all unfarmable stages
field_names = fieldnames(stage_data);
for i = 1:numel(field_names)
    % remove stages that cost 0 sanity
    if stage_data.(field_names{i}).apCost == 0
        stage_data = rmfield(stage_data, field_names{i});
    % remove supply stages, we are only considering material farming stages
    elseif stage_data.(field_names{i}).stageType == "DAILY"
        stage_data = rmfield(stage_data, field_names{i});
    % remove annigilation stages
    elseif stage_data.(field_names{i}).stageType == "CAMPAIGN"
        stage_data = rmfield(stage_data, field_names{i});
    % remove event stages, they will be processed sepatately
    elseif stage_data.(field_names{i}).stageType == "ACTIVITY"
        stage_data = rmfield(stage_data, field_names{i});
    % remove challenge mode stages
    elseif stage_data.(field_names{i}).difficulty == "FOUR_STAR"
        stage_data = rmfield(stage_data, field_names{i});
    end
end
% remove H5-x and H6-x stages
stage_data = rmfield(stage_data, 'hard_05_01');
stage_data = rmfield(stage_data, 'hard_05_02');
stage_data = rmfield(stage_data, 'hard_05_03');
stage_data = rmfield(stage_data, 'hard_05_04');
stage_data = rmfield(stage_data, 'hard_06_01');
stage_data = rmfield(stage_data, 'hard_06_02');
stage_data = rmfield(stage_data, 'hard_06_03');
stage_data = rmfield(stage_data, 'hard_06_04');
%% leave only farmable event stages
field_names = fieldnames(event_stage_data);
for i = 1:numel(field_names)
    % remove stages that cost 0 sanity
    if event_stage_data.(field_names{i}).apCost == 0
        event_stage_data = rmfield(event_stage_data, field_names{i});
        continue
    end
    % only leave event stages
    if not (event_stage_data.(field_names{i}).stageType == "ACTIVITY")
        event_stage_data = rmfield(event_stage_data, field_names{i});
        continue
    end
    % remove challenge mode stages
    if event_stage_data.(field_names{i}).difficulty == "FOUR_STAR"
        event_stage_data = rmfield(event_stage_data, field_names{i});
    end
end
%% get drop rate data
url = "https://penguin-stats.io/PenguinStats/api/v2/result/matrix?server=US";
uri = URI(url);
fprintf("Getting drop rate data from %s\n", url)
r = RequestMessage;
resp = send(r,uri);
disp(resp.StatusCode); % show status code
tmp = jsondecode(resp.Body.string());
drop_data = tmp.matrix;
% now we have all necessary data