% calculate LMD, EXP and gold sanity values
% too smol brain to do this
% just using these values rn
% LMD
% LMD_sanity_value = 0.004;
LMD_sanity_value = 30 / 7500;
LMD_item_index = item_indices('4001');
% gold
% gold_sanity_value = 1.013;
gold_sanity_value = LMD_sanity_value * 500;
gold_item_index = item_indices('3003');
% EXP cards
% exp_sanity_value = 0.605 / 200;
exp_sanity_value = (30 - 30*12*LMD_sanity_value) / 7400;
% T1 EXP card
T1_exp_card_item_index = item_indices('2001');
% T2 EXP card
T2_exp_card_item_index = item_indices('2002');
% T3 EXP card
T3_exp_card_item_index = item_indices('2003');
% T4 EXP card
T4_exp_card_item_index = item_indices('2004');