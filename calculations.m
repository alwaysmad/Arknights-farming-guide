%% run script that provides D, item_names and stage_and_craft_names
prepare_data;
%% construct V_preset - vector of known sanity values of items
% and construct A_eq - matrix needed for linprog
V_preset = zeros(numel(item_names), 1);
A_eq = zeros(numel(item_names));
% sanity is worth 1 of itself
sanity_item_index = item_indices('AP_GAMEPLAY');
V_preset(sanity_item_index) = 1;
A_eq(sanity_item_index, sanity_item_index) = 1;
% LMD sanity value is assumed in consideration we farm CE-5
% an advanced approach would be taking base in account
% but we don't do this here to remain flexibility over base setups
LMD_item_index = item_indices('4001');
LMD_sanity_value = 30 / 7500;
V_preset(LMD_item_index) = LMD_sanity_value;
A_eq(LMD_item_index, LMD_item_index) = 1;
% gold sanity value is assumed to be equal to value of corresponding amount
% of LMD
gold_item_index = item_indices('3003');
V_preset(gold_item_index) = LMD_sanity_value * 500;
A_eq(gold_item_index, gold_item_index) = 1;
% EXP sanity value is assumed in consideration we farm LS-5
% once again a more advanced approach would be taking base in account
% LS-5 drops some LMD
LS_5_LMD_drop = 30 * 12;
EXP_sanity_value = (30 - LS_5_LMD_drop*LMD_sanity_value) / 7500;
% EXP cards come in 4 tiers
% T1 Drill Battle Record
EXP_t1_item_index = item_indices('2001');
EXP_t1_exp_gain = 200;
EXP_t1_sanity_value = EXP_sanity_value * EXP_t1_exp_gain;
V_preset(EXP_t1_item_index) = EXP_t1_sanity_value;
A_eq(EXP_t1_item_index, EXP_t1_item_index) = 1;
% T2 Frontline Battle Record
EXP_t2_item_index = item_indices('2002');
EXP_t2_exp_gain = 400;
EXP_t2_sanity_value = EXP_sanity_value * EXP_t2_exp_gain;
V_preset(EXP_t2_item_index) = EXP_t2_sanity_value;
A_eq(EXP_t2_item_index, EXP_t2_item_index) = 1;
% T3 Tactical Battle Record
EXP_t3_item_index = item_indices('2003');
EXP_t3_exp_gain = 1000;
EXP_t3_sanity_value = EXP_sanity_value * EXP_t3_exp_gain;
V_preset(EXP_t3_item_index) = EXP_t3_sanity_value;
A_eq(EXP_t3_item_index, EXP_t3_item_index) = 1;
% T4 Strategic Battle Record
EXP_t4_item_index = item_indices('2004');
EXP_t4_exp_gain = 2000;
EXP_t4_sanity_value = EXP_sanity_value * EXP_t4_exp_gain;
V_preset(EXP_t4_item_index) = EXP_t4_sanity_value;
A_eq(EXP_t4_item_index, EXP_t4_item_index) = 1;
%% the moment of truth
% we use linprog for Pareto optimality
% construct f
f = - D'*ones(numel(stage_and_craft_names), 1);
V = linprog(f, D, zeros(numel(stage_and_craft_names), 1), A_eq, V_preset);
% revenue vector
R = D*V;
%% calculate efficiency
% vector of stage/craft sanity costs
S = -D(:,sanity_item_index);
% vector of stage/craft efficiency
Eff = (S + R);
Eff = Eff./S;
% take care of rows with Nan and Inf corresponding to crafting
Eff(isinf(Eff)) = 0;
Eff(isnan(Eff)) = 0;
%% calculate efficiency of event stages
event_R = event_D*V;
event_S = -event_D(:,sanity_item_index);
event_Eff = event_S + event_R;
event_Eff = event_Eff./event_S;
% take care of rows with Nan and Inf
event_Eff(isinf(event_Eff)) = 0;
event_Eff(isnan(event_Eff)) = 0;