clc;
clear;
%% 
% if ~exist('OCTAVE_VERSION', 'builtin') 
%     % we are in MATLAB
%     get_raw_data; % downloads necessary data
% elseif ~isempty(Ver_Octave_indices)
%     % we are in Octave
%     get_raw_data_octave;
% end
get_raw_data; % downloads necessary data
%% 
preprocess_item_data; % removes all unnecessary items
preprocess_craft_data; % removes all unnecessary crafting recipes
preprocess_main_stage_data; % removes all unrafmable main stages
preprocess_event_stage_data; % removes all unfarmable event stages
%% 
prepare_item_data; % forms item data into map and array
prepare_main_activity_data; % forms main stage and craft data into map and array
prepare_event_activity_data; % forms event stage data into map and array
%% 
% we ignore stages that have less than this samples
minimum_threshold = 150;
% feel free to change these but I don't think it will make much difference
material_craft_operator_bonus = 80;
skill_summary_craft_operator_bonus = 80;
building_material_operator_bonus = 70;
fill_D; % forms and fills main activity drop matrix (EN statistics)
%% 
% we ignore event stages that have less than this samples
minimum_threshold = 1;
fill_event_D; % forms and fills event activity drop matrix (CN statistics)
%% 
% we use additional logic taking base into account here (but actually not lol)
LMD_and_EXP_values;
%% 
% calculate sanity values
calculate_V;
%%
% output all info to file
file_name = 'output.txt';
% we just skip stages with small efficiency
efficiency_threshold = 0.80;
drops_to_display_num = 4;
event_stages_efficiency_threshold = 0.80;
output_results;
