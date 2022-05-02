import matlab.net.*
import matlab.net.http.*
%% get item data (EN)
url = "https://raw.githubusercontent.com/Kengxxiao/ArknightsGameData/master/en_US/gamedata/excel/item_table.json";
%url = "https://raw.githubusercontent.com/Kengxxiao/ArknightsGameData/master/zh_CN/gamedata/excel/item_table.json";
uri = URI(url);
fprintf("Getting item data from %s\n", url)
r = RequestMessage;
resp = send(r,uri);
disp(resp.StatusCode); % show status code
tmp = jsondecode(resp.Body.string());
raw_item_data = tmp.items;
%% get craft data (EN)
url = "https://raw.githubusercontent.com/Kengxxiao/ArknightsGameData/master/en_US/gamedata/excel/building_data.json";
%url = "https://raw.githubusercontent.com/Kengxxiao/ArknightsGameData/master/zh_CN/gamedata/excel/building_data.json";
uri = URI(url);
fprintf("Getting craft data from %s\n", url)
r = RequestMessage;
resp = send(r,uri);
disp(resp.StatusCode); % show status code
tmp = jsondecode(resp.Body.string());
raw_craft_data = tmp.workshopFormulas;
%% get stage data (EN) for main stages
url = "https://raw.githubusercontent.com/Kengxxiao/ArknightsGameData/master/en_US/gamedata/excel/stage_table.json";
%url = "https://raw.githubusercontent.com/Kengxxiao/ArknightsGameData/master/zh_CN/gamedata/excel/stage_table.json";
uri = URI(url);
fprintf("Getting main stage data from %s\n", url)
r = RequestMessage;
resp = send(r,uri);
disp(resp.StatusCode); % show status code
tmp = jsondecode(resp.Body.string());
raw_main_stage_data = tmp.stages;
%% get stage data (CN) for event stages
%url = "https://raw.githubusercontent.com/Kengxxiao/ArknightsGameData/master/en_US/gamedata/excel/stage_table.json";
url = "https://raw.githubusercontent.com/Kengxxiao/ArknightsGameData/master/zh_CN/gamedata/excel/stage_table.json";
uri = URI(url);
fprintf("Getting event stage data from %s\n", url)
r = RequestMessage;
resp = send(r,uri);
disp(resp.StatusCode); % show status code
tmp = jsondecode(resp.Body.string());
raw_event_stage_data = tmp.stages;
%% get drop rate data (EN or CN) statistics for main stages
% url = "https://penguin-stats.io/PenguinStats/api/v2/result/matrix?server=US";
url = "https://penguin-stats.io/PenguinStats/api/v2/result/matrix?server=CN";
uri = URI(url);
fprintf("Getting drop rate data from %s\n", url)
r = RequestMessage;
resp = send(r,uri);
disp(resp.StatusCode); % show status code
tmp = jsondecode(resp.Body.string());
en_drop_data = tmp.matrix;
%% get drop rate data (CN statistics for event stages)
% url = "https://penguin-stats.io/PenguinStats/api/v2/result/matrix?show_closed_zones=true&server=US";
url = "https://penguin-stats.io/PenguinStats/api/v2/result/matrix?show_closed_zones=true&server=CN";
uri = URI(url);
fprintf("Getting drop rate data from %s\n", url)
r = RequestMessage;
resp = send(r,uri);
disp(resp.StatusCode); % show status code
tmp = jsondecode(resp.Body.string());
cn_drop_data = tmp.matrix;