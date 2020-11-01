%% remove all unneeded recipes
craft_data = raw_craft_data;
field_names = fieldnames(raw_craft_data);
for i = 1:numel(field_names)
    % leave recipes related to materials
    if (raw_craft_data.(field_names{i}).formulaType == "F_EVOLVE")
        continue;
    end
    % leave recipes related to skill summaries
    if (raw_craft_data.(field_names{i}).formulaType == "F_SKILL")
        continue;
    end
    % leave recipes related to building materials and furniture
    if (raw_craft_data.(field_names{i}).formulaType == "F_BUILDING")
        continue;
    end
    % remove all other recipes
    craft_data = rmfield(craft_data, field_names{i});
end