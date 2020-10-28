%% construct the drop matrix
rows_num = activity_indices.size(1);
columns_num = item_indices.size(1);
D = zeros(rows_num, columns_num);
% D(stage/craft, item)
%% fill with drop rates from penguin statisctics (EN)
for i = 1 : numel(en_drop_data)
    % skip entry if data is insufficient
    if en_drop_data{i}.times < minimum_threshold
        continue
    end
    item_id = en_drop_data{i}.itemId;
    % skip entry if it is related to item we don't consider
    if isKey(item_indices, item_id) == 0
        continue
    end
    stage_id = en_drop_data{i}.stageId;
    % if entry is related to main story stages then we add data to D
    if isKey(activity_indices, stage_id) == 1
        % items and stages we consider here should not have field 'end'
        drop_rate = en_drop_data{i}.quantity / en_drop_data{i}.times;
        % should not interlap
        D(activity_indices(stage_id), item_indices(item_id)) = drop_rate;
    end
end
%% add sanity and LMD to D
% penguin statistics doesn't give LMD drop rate but main story stages that
% drop LMD are inferior to CE-5 so im not even gonna add these drops cause
% these maps are garbage to farm anyways 
sanity_item_index = item_indices('AP_GAMEPLAY');
LMD_item_index = item_indices('4001');
field_names = fieldnames(main_stage_data);
for i = 1 : numel(field_names)
    stage_id = main_stage_data.(field_names{i}).stageId;
    stage_index = activity_indices(stage_id);
    sanity_cost = main_stage_data.(field_names{i}).apCost;
    % that '-' is very important for calculation!
    D(stage_index, sanity_item_index) = -sanity_cost;
    % every stage drops 12*sanity LMD unless it's an LMD farnimg stage
    D(stage_index, LMD_item_index) = 12 * sanity_cost;
end
% add LMD to CE-5
stage_id = 'wk_melee_5';
stage_index = activity_indices(stage_id);
sanity_cost = main_stage_data.(stage_id).apCost;
D(stage_index, sanity_item_index) = -sanity_cost;
D(stage_index, LMD_item_index) = 7500;
%% add crafting with by-products to D
material_byproduct_rate = 1 + material_craft_operator_bonus/100;
skill_summary_byproduct_rate = 1 + skill_summary_craft_operator_bonus/100;
field_names = fieldnames(craft_data);
for i = 1 : numel(field_names)
    craft_index = activity_indices(field_names{i});
    % add the main craft product to D
    item_id = craft_data.(field_names{i}).itemId;
    item_index = item_indices(item_id);
    item_count = craft_data.(field_names{i}).count;
    D(craft_index, item_index) = item_count;
    % add LMD cost
    LMD_cost = craft_data.(field_names{i}).goldCost;
    D(craft_index, LMD_item_index) = -LMD_cost;
    % add material cost
    for j = 1 : numel(craft_data.(field_names{i}).costs)
        item_id = craft_data.(field_names{i}).costs(j).id;
        item_index = item_indices(item_id);
        item_count = craft_data.(field_names{i}).costs(j).count;
        D(craft_index, item_index) = -item_count;
    end
    % now add by-products
    by_product_rate = 0;
    if (craft_data.(field_names{i}).formulaType == "F_EVOLVE") % processing material
        by_product_rate = craft_data.(field_names{i}).extraOutcomeRate * material_byproduct_rate;
    elseif (raw_craft_data.(field_names{i}).formulaType == "F_SKILL") % processing skill summary
        by_product_rate = craft_data.(field_names{i}).extraOutcomeRate * skill_summary_byproduct_rate;
    end
    % calculate weight sum
    weigth_sum = 0;
    for j = 1 : numel(craft_data.(field_names{i}).extraOutcomeGroup)
        weigth_sum = weigth_sum + craft_data.(field_names{i}).extraOutcomeGroup(j).weight;
    end
    % now calculate by-products' rates and add them to D
    for j = 1 : numel(craft_data.(field_names{i}).extraOutcomeGroup)
        by_product = craft_data.(field_names{i}).extraOutcomeGroup(j);
        item_id = by_product.itemId;
        item_index = item_indices(item_id);
        item_count = by_product.itemCount;
        rate = by_product.weight / weigth_sum;
        rate = rate * item_count * by_product_rate;
        % the filed in D possibly already filled with cost so we add rate
        D(craft_index, item_index) = D(craft_index, item_index) + rate;
    end
end