%% get item data (EN)
% url = "https://raw.githubusercontent.com/Kengxxiao/ArknightsGameData/master/en_US/gamedata/excel/item_table.json";
% %url = "https://raw.githubusercontent.com/Kengxxiao/ArknightsGameData/master/zh_CN/gamedata/excel/item_table.json";
% fprintf("Getting item data from %s\n", url)
% tmp = webread(url);
% raw_item_data = tmp.items;
%% test
url = 'http://www.mathworks.com/matlabcentral/fileexchange'
searchTerm = 'sensor-data-acquisition'
html = webread(url,'term',searchTerm)