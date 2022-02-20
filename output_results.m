fprintf("%s\n", file_name);
fileID = fopen('output.txt','w');
%% calculate stage efficienies
% vector of activities' sanity costs
% S = -D(:,sanity_item_index);
% S = -sum((D<0).*D,2);
S = -(D<0).*D * V;
% vector of stage/craft efficiency
Eff = (S + R) ./ S;
% take care of rows with Nan and Inf corresponding to crafting
Eff(isinf(Eff)) = 0;
Eff(isnan(Eff)) = 0;
Eff = round(Eff, 4);
%% sort stages by efficiency and write their drops
fprintf(fileID, "Calculated best farming stages (based on CN statistics):\n");
fprintf(fileID, "Stage | Efficiency | Major Drops\n");
tmp = sortrows([Eff (1:numel(Eff))'], [1, 2], {'descend', 'ascend'});
sorted_stage_indices = tmp(:,2);
% now display stage information
stage_ids_not_to_display = {'x1' 'x10' 'x11' 'x12' 'x13' 'x14' 'x15' 'x16' ...
    'x17' 'x18' 'x19' 'x2' 'x20' 'x21' 'x22' 'x23' 'x24' 'x25' 'x26' 'x27' ...
    'x28' 'x29' 'x3' 'x30' 'x31' 'x32' 'x33' 'x34' 'x35' 'x36' 'x37' 'x38' ...
    'x4' 'x5' 'x55' 'x56' 'x57' 'x58' 'x6' 'x7' 'x8' 'x9' ...
    'act12side_01', 'act12side_02', 'act12side_03', 'act12side_04', 'act12side_05'...
    'act12side_06', 'act12side_07', 'act12side_08', 'act12side_09'};
stage_indices_not_to_display = [];
for stage_id_not_to_display = stage_ids_not_to_display
    stage_indices_not_to_display(end+1) = activity_indices(stage_id_not_to_display{1});
end
for i = 1 : numel(sorted_stage_indices)
    stage_index = sorted_stage_indices(i);
    % skip crafting activities and DH stages
    if ismember(stage_index, stage_indices_not_to_display)
        continue
    end
    stage_name = activity_names{stage_index};
    stage_efficiency = Eff(stage_index);
    % we just skip stages with small efficiency
    if stage_efficiency < efficiency_threshold
        continue
    end
    % determine stage's drops
    stage_drops = D(stage_index,:);
    stage_drops_sanity_distribution = stage_drops.*V';
    [tmp, stage_drops_sanity_distribution_indices] = sort(stage_drops_sanity_distribution,'descend');
    % we dispaly stage's most valuable drops
    tmp = drops_to_display_num;
    for j = 1 : drops_to_display_num
        % not display drops with stage_drops_sanity_distribution = 0
        if stage_drops_sanity_distribution(stage_drops_sanity_distribution_indices(j)) <= 0
            tmp = j - 1;
            break
        end
    end
    notable_drops = "";
    for j = 1 : tmp
        item_index = stage_drops_sanity_distribution_indices(j);
        item_name = item_names{item_index};
        item_drop_rate = stage_drops(item_index);
        stage_sanity_cost = -stage_drops(sanity_item_index);
        item_sanity_per_drop = stage_sanity_cost / item_drop_rate;
        if stage_sanity_cost ~= 0
            if item_index ~= LMD_item_index
                notable_drops = notable_drops + item_name + " [" + round(item_drop_rate*100, 2) + "%, " + round(item_sanity_per_drop, 2) + " per drop]";
            else
                notable_drops = notable_drops + item_name + " [" + item_drop_rate + "]";
            end
        else
            if item_index ~= LMD_item_index
                notable_drops = notable_drops + item_name + " [" + round(item_drop_rate*100, 2) + "%]";
            else
                notable_drops = notable_drops + item_name + " [" + item_drop_rate + "]";
            end
        end
        if j ~= tmp
            notable_drops = notable_drops + ", ";
        end
    end
    fprintf(fileID, "%s,%6.3f: %s\n", stage_name, stage_efficiency, notable_drops);
end
fprintf(fileID, "------------------------------------------------------------\n");
%% calculate efficiencies of event stages
event_R = event_D*V;
event_S = - (event_D<0) .* event_D * V;
% event_S = -event_D(:,sanity_item_index);
event_Eff = (event_S + event_R) ./ event_S;
% take care of rows with Nan and Inf
event_Eff(isinf(event_Eff)) = 0;
event_Eff(isnan(event_Eff)) = 0;
%% display best event farming stages
fprintf(fileID, "Notable event farming stages (based on CN statistics):\n");
fprintf(fileID, "Stage | Efficiency | Major Drops\n");
for i = 1 : numel(event_activity_names)
    % we don't sort them to preserve original order
    event_stage_index = i;
    event_stage_name = event_activity_names{i};
    event_stage_efficiency = event_Eff(event_stage_index);
    % we skip inefficient event stages
    if event_stage_efficiency < event_stages_efficiency_threshold
        continue
    end
    % determine event stage's drops
    event_stage_drops = event_D(event_stage_index,:);
    event_stage_drops_sanity_distribution = event_stage_drops.*V';
    [tmp, event_stage_drops_sanity_distribution_indices] = sort(event_stage_drops_sanity_distribution,'descend');
    % we dispaly stage's most valuable drops
    % not display drops with stage_drops_sanity_distribution = 0
    tmp = drops_to_display_num;
    for j = 1 : drops_to_display_num
        if event_stage_drops_sanity_distribution(event_stage_drops_sanity_distribution_indices(j)) <= 0
            tmp = j - 1;
            break
        end
    end
    notable_drops = "";
    for j = 1 : tmp
        item_index = event_stage_drops_sanity_distribution_indices(j);
        item_name = item_names{item_index};
        item_drop_rate = event_stage_drops(item_index);
        stage_sanity_cost = -event_stage_drops(sanity_item_index);
        item_sanity_per_drop = stage_sanity_cost / item_drop_rate;
        if stage_sanity_cost ~= 0
            if item_index ~= LMD_item_index
                notable_drops = notable_drops + item_name + " [" + round(item_drop_rate*100, 2) + "%, " + round(item_sanity_per_drop, 2) + " per drop]";
            else
                notable_drops = notable_drops + item_name + " [" + item_drop_rate + "]";
            end
        else
            if item_index ~= LMD_item_index
                notable_drops = notable_drops + item_name + " [" + round(item_drop_rate*100, 2) + "%]";
            else
                notable_drops = notable_drops + item_name + " [" + item_drop_rate + "]";
            end
        end
        if j ~= tmp
            notable_drops = notable_drops + ", ";
        end
    end
    fprintf(fileID, "%s,%6.3f: %s\n", event_stage_name, event_stage_efficiency, notable_drops);
end
fprintf(fileID, "------------------------------------------------------------\n");
%% display short event info
fprintf(fileID, "Event stages' code names info:\n");
fprintf(fileID, "A Light Spark in Darkness: TB-*\n");
fprintf(fileID, "Invitation to Wine: IW-*\n");
fprintf(fileID, "Break the Ice: BI-*\n");
fprintf(fileID, "Near Light: NL-*\n");
fprintf(fileID, "Pinus Sylvestris: PS-*\n");
fprintf(fileID, "Dossoles Holiday: DH-*\n");
fprintf(fileID, "Vigilo: VI-*\n");
fprintf(fileID, "Preluding Lights: PL-*\n");
fprintf(fileID, "Under Tides: SV-*\n");
fprintf(fileID, "A Walk In The Dust: WD-*\n");
fprintf(fileID, "Operation Originium Dust: OD-*\n");
fprintf(fileID, "Who is Real: WR-*\n");
fprintf(fileID, "Beyond Here: BH-*\n");
fprintf(fileID, "Mansfield Break: MB-*\n");
fprintf(fileID, "Maria Nearl: MN-*\n");
fprintf(fileID, "Rewinding Breeze: FA-*\n");
fprintf(fileID, "Gavial The Great Chief Returns: RI-*\n");
fprintf(fileID, "Twilight of Wolumonde: TW-*\n");
fprintf(fileID, "Children of Ursus: SV-*\n");
fprintf(fileID, "Darknights' Memoir: DM-*\n");
fprintf(fileID, "Stories of Afternoon: SA-*\n");
fprintf(fileID, "Ancient Forge: AF-*\n");
fprintf(fileID, "Code of Brawl: CB-*\n");
fprintf(fileID, "Heart of Surging Flame: OF-*\n");
fprintf(fileID, "Operational Intelligence: SW-EV-*\n");
fprintf(fileID, "Grani and the Knights' Treasure: GT-*\n");
fprintf(fileID, "------------------------------------------------------------\n");
%% credit shop efficiency
% I failed to find any data so I had to do this by hand...
% items appear with 99%, 95%, 75%, 50% or 0% discount
% I'm only displaying of efficiencies of 75%, 50% and no discount buys 
credit_shop_data{1}.item_id = '30062'; % device
credit_shop_data{1}.item_count = 1;
credit_shop_data{1}.credit_cost = 160;
credit_shop_data{2}.item_id = '30042'; % oriron
credit_shop_data{2}.item_count = 2;
credit_shop_data{2}.credit_cost = 240;
credit_shop_data{3}.item_id = '30052'; % polyketon
credit_shop_data{3}.item_count = 2;
credit_shop_data{3}.credit_cost = 240;
credit_shop_data{4}.item_id = '3302'; % skill summary - 2
credit_shop_data{4}.item_count = 3;
credit_shop_data{4}.credit_cost = 200;
credit_shop_data{5}.item_id = '30022'; % sugar
credit_shop_data{5}.item_count = 2;
credit_shop_data{5}.credit_cost = 200;
credit_shop_data{6}.item_id = '30032'; % polyester
credit_shop_data{6}.item_count = 2;
credit_shop_data{6}.credit_cost = 200;
credit_shop_data{7}.item_id = '3301'; % skill summary - 1
credit_shop_data{7}.item_count = 5;
credit_shop_data{7}.credit_cost = 160;
credit_shop_data{8}.item_id = '3003'; % pure gold
credit_shop_data{8}.item_count = 6;
credit_shop_data{8}.credit_cost = 160;
credit_shop_data{9}.item_id = '4001'; % LMD
credit_shop_data{9}.item_count = 1800;
credit_shop_data{9}.credit_cost = 100;
credit_shop_data{10}.item_id = '4001'; % LMD
credit_shop_data{10}.item_count = 3600;
credit_shop_data{10}.credit_cost = 200;
credit_shop_data{11}.item_id = '2002'; % Frontline Battle Record
credit_shop_data{11}.item_count = 9;
credit_shop_data{11}.credit_cost = 200;
credit_shop_data{12}.item_id = '2001'; % Drill Battle Record
credit_shop_data{12}.item_count = 9;
credit_shop_data{12}.credit_cost = 100;
credit_shop_data{13}.item_id = '30012'; % orirock cube
credit_shop_data{13}.item_count = 3;
credit_shop_data{13}.credit_cost = 200;
credit_shop_data{14}.item_id = '30061'; % damaged device
credit_shop_data{14}.item_count = 1;
credit_shop_data{14}.credit_cost = 80;
credit_shop_data{15}.item_id = '30041'; % Oriron shard
credit_shop_data{15}.item_count = 2;
credit_shop_data{15}.credit_cost = 120;
credit_shop_data{16}.item_id = '30051'; % Diketon
credit_shop_data{16}.item_count = 2;
credit_shop_data{16}.credit_cost = 120;
credit_shop_data{17}.item_id = '30021'; % Sugar Substitute
credit_shop_data{17}.item_count = 2;
credit_shop_data{17}.credit_cost = 100;
credit_shop_data{18}.item_id = '30031'; % ester
credit_shop_data{18}.item_count = 2;
credit_shop_data{18}.credit_cost = 100;
credit_shop_data{19}.item_id = '30011'; % orirock
credit_shop_data{19}.item_count = 2;
credit_shop_data{19}.credit_cost = 80;
credit_shop_data{20}.item_id = '3113'; % carbon brick
credit_shop_data{20}.item_count = 3;
credit_shop_data{20}.credit_cost = 200;
credit_shop_data{21}.item_id = '3112'; % carbon stick
credit_shop_data{21}.item_count = 5;
credit_shop_data{21}.credit_cost = 160;
credit_shop_data{22}.item_id = '3401'; % Furniture Part
credit_shop_data{22}.item_count = 20;
credit_shop_data{22}.credit_cost = 160;
credit_shop_data{23}.item_id = '3401'; % Furniture Part
credit_shop_data{23}.item_count = 25;
credit_shop_data{23}.credit_cost = 200;
% make shop entries
credit_shop_entry_names = {};
credit_shop_entry_credit_efficiencies = [];
for i = 1 : numel(credit_shop_data)
    item_id = credit_shop_data{i}.item_id;
    item_count = credit_shop_data{i}.item_count;
    item_credit_cost = credit_shop_data{i}.credit_cost;
    item_index = item_indices(item_id);
    item_name = item_names{item_index};
    item_sanity_value = V(item_index);
    % no discout
    entry_name = "" + item_count + " " + item_name + "(s) for " + item_credit_cost + " credit (no discount)";
    entry_efficiency = item_sanity_value * item_count / item_credit_cost;
    credit_shop_entry_names{(i-1)*3 + 1} = entry_name;
    credit_shop_entry_credit_efficiencies((i-1)*3 + 1) = entry_efficiency;
    % 50% discout
    entry_name = "" + item_count + " " + item_name + "(s) for " + item_credit_cost/2 + " credit (50% discount)";
    entry_efficiency = item_sanity_value * item_count / (item_credit_cost/2);
    credit_shop_entry_names{(i-1)*3 + 2} = entry_name;
    credit_shop_entry_credit_efficiencies((i-1)*3 + 2) = entry_efficiency;
    % 50% discout
    entry_name = "" + item_count + " " + item_name + "(s) for " + item_credit_cost/4 + " credit (75% discount)";
    entry_efficiency = item_sanity_value * item_count / (item_credit_cost/4);
    credit_shop_entry_names{(i-1)*3 + 3} = entry_name;
    credit_shop_entry_credit_efficiencies((i-1)*3 + 3) = entry_efficiency;
    % not even considering 99% and 95% discount, these are basically free
end
% sort and output
fprintf(fileID, "Calculated best Credit Store buys:\n");
[tmp, sorted_credit_shop_entry_credit_efficiencies_indices] = sort(credit_shop_entry_credit_efficiencies, 'descend');
for i = 1 : numel(credit_shop_entry_credit_efficiencies)
    entry_index = sorted_credit_shop_entry_credit_efficiencies_indices(i);
    entry_name = credit_shop_entry_names{entry_index};
    entry_efficiency = credit_shop_entry_credit_efficiencies(entry_index);
    fprintf(fileID, "%s (%g sanity per credit)\n", entry_name, entry_efficiency);
end
fprintf(fileID, "------------------------------------------------------------\n");
%% Commendations Certificate Store efficiency (green certs second tier)
green_cert_shop_data{1}.item_id = '30013'; % orirock cluster
green_cert_shop_data{1}.cc_cost = 25;
green_cert_shop_data{2}.item_id = '30023'; % sugar pack
green_cert_shop_data{2}.cc_cost = 30;
green_cert_shop_data{3}.item_id = '30033'; % polyester pack
green_cert_shop_data{3}.cc_cost = 30;
green_cert_shop_data{4}.item_id = '30043'; % oriron cluster
green_cert_shop_data{4}.cc_cost = 35;
green_cert_shop_data{5}.item_id = '30053'; % aketon
green_cert_shop_data{5}.cc_cost = 35;
green_cert_shop_data{6}.item_id = '30063'; % integrated device
green_cert_shop_data{6}.cc_cost = 45;
green_cert_shop_data{7}.item_id = '30073'; % loxic kohl
green_cert_shop_data{7}.cc_cost = 30;
green_cert_shop_data{8}.item_id = '30083'; % manganese ore
green_cert_shop_data{8}.cc_cost = 35;
green_cert_shop_data{9}.item_id = '30093'; % grindstone
green_cert_shop_data{9}.cc_cost = 40;
green_cert_shop_data{10}.item_id = '30103'; % rma70-12
green_cert_shop_data{10}.cc_cost = 45;
green_cert_shop_data{11}.item_id = '31013'; % coagulating gel
green_cert_shop_data{11}.cc_cost = 40;
green_cert_shop_data{12}.item_id = '31023'; % incandescent alloy
green_cert_shop_data{12}.cc_cost = 35;
green_cert_shop_data{13}.item_id = '31033'; % Crystalline Component
green_cert_shop_data{13}.cc_cost = 30;
% make shop entries
green_cert_shop_efficiencies = [];
for i = 1 : numel(green_cert_shop_data)
    item_id = green_cert_shop_data{i}.item_id;
    item_cc_cost = green_cert_shop_data{i}.cc_cost;
    item_index = item_indices(item_id);
    item_sanity_value = V(item_index);
    green_cert_shop_efficiencies(i) = item_sanity_value / item_cc_cost;
end
[tmp, sorted_green_cert_shop_efficiencies_indices] = sort(green_cert_shop_efficiencies, 'descend');
fprintf(fileID, "Calculated best Commendations Certificate(green certs) Store buys:\n");
for j = 1 : numel(sorted_green_cert_shop_efficiencies_indices)
    i = sorted_green_cert_shop_efficiencies_indices(j);
    item_id = green_cert_shop_data{i}.item_id;
    item_cc_cost = green_cert_shop_data{i}.cc_cost;
    item_index = item_indices(item_id);
    item_name = item_names{item_index};
    item_sanity_value = V(item_index);
    entry_name = "" + item_name + " for " + item_cc_cost + " Commendation Certificates(green certs)";
    entry_efficiency = green_cert_shop_efficiencies(i);
    fprintf(fileID, "%s (%g sanity per CC)\n", entry_name, entry_efficiency);
end
fprintf(fileID, "------------------------------------------------------------\n");
% I'm not gonna add yellow cert shop
% even whales should not buy that staff
%% Recruitment Data Models shop (Sparking system shop)
% once again, gotta do it by hand :(
% t1
sparking_system_shop_data{1}.item_id = '30011'; % 8 orirocks for 15
sparking_system_shop_data{1}.item_count = 8;
sparking_system_shop_data{1}.cost = 15;
sparking_system_shop_data{2}.item_id = '30021'; % 8 sugar substitute for 25
sparking_system_shop_data{2}.item_count = 8;
sparking_system_shop_data{2}.cost = 25;
sparking_system_shop_data{3}.item_id = '30031'; % 8 esters for 25
sparking_system_shop_data{3}.item_count = 8;
sparking_system_shop_data{3}.cost = 25;
sparking_system_shop_data{4}.item_id = '30041'; % 8 oriron shards for 30
sparking_system_shop_data{4}.item_count = 8;
sparking_system_shop_data{4}.cost = 30;
sparking_system_shop_data{5}.item_id = '30051'; % 8 diketon for 30
sparking_system_shop_data{5}.item_count = 8;
sparking_system_shop_data{5}.cost = 30;
sparking_system_shop_data{6}.item_id = '30061'; % 8 broken diveces for 40
sparking_system_shop_data{6}.item_count = 8;
sparking_system_shop_data{6}.cost = 40;
% t2
sparking_system_shop_data{7}.item_id = '30012'; % 4 orirock cubes for 15
sparking_system_shop_data{7}.item_count = 4;
sparking_system_shop_data{7}.cost = 15;
sparking_system_shop_data{8}.item_id = '30022'; % 4 sugar for 25
sparking_system_shop_data{8}.item_count = 4;
sparking_system_shop_data{8}.cost = 25;
sparking_system_shop_data{9}.item_id = '30032'; % 4 polyesters for 25
sparking_system_shop_data{9}.item_count = 4;
sparking_system_shop_data{9}.cost = 25;
sparking_system_shop_data{10}.item_id = '30042'; % 4 orirons for 30
sparking_system_shop_data{10}.item_count = 4;
sparking_system_shop_data{10}.cost = 30;
sparking_system_shop_data{11}.item_id = '30052'; % 4 polyketons for 30
sparking_system_shop_data{11}.item_count = 4;
sparking_system_shop_data{11}.cost = 30;
sparking_system_shop_data{12}.item_id = '30062'; % 4 diveces for 40
sparking_system_shop_data{12}.item_count = 4;
sparking_system_shop_data{12}.cost = 40;
% t3
sparking_system_shop_data{13}.item_id = '30013'; % 2 orirock clusters for 30
sparking_system_shop_data{13}.item_count = 2;
sparking_system_shop_data{13}.cost = 30;
sparking_system_shop_data{14}.item_id = '30023'; % 2 sugar packs for 35
sparking_system_shop_data{14}.item_count = 2;
sparking_system_shop_data{14}.cost = 35;
sparking_system_shop_data{15}.item_id = '30033'; % 2 polyester packs for 35
sparking_system_shop_data{15}.item_count = 2;
sparking_system_shop_data{15}.cost = 35;
sparking_system_shop_data{16}.item_id = '30043'; % 2 orirons clusters for 45
sparking_system_shop_data{16}.item_count = 2;
sparking_system_shop_data{16}.cost = 45;
sparking_system_shop_data{17}.item_id = '30053'; % 2 aketons for 45
sparking_system_shop_data{17}.item_count = 2;
sparking_system_shop_data{17}.cost = 45;
sparking_system_shop_data{18}.item_id = '30063'; % 2 integrated diveces for 60
sparking_system_shop_data{18}.item_count = 2;
sparking_system_shop_data{18}.cost = 60;
% more t3
sparking_system_shop_data{19}.item_id = '30073'; % 2 loxic kohls for 40
sparking_system_shop_data{19}.item_count = 2;
sparking_system_shop_data{19}.cost = 40;
sparking_system_shop_data{20}.item_id = '30083'; % 2 Manganese Ores for 45
sparking_system_shop_data{20}.item_count = 2;
sparking_system_shop_data{20}.cost = 45;
sparking_system_shop_data{21}.item_id = '30093'; % 2 grindstones for 50
sparking_system_shop_data{21}.item_count = 2;
sparking_system_shop_data{21}.cost = 50;
sparking_system_shop_data{22}.item_id = '30103'; % 2 RMA70-12 for 60
sparking_system_shop_data{22}.item_count = 2;
sparking_system_shop_data{22}.cost = 60;
sparking_system_shop_data{23}.item_id = '31013'; % 2 Coagulating Gel for 50
sparking_system_shop_data{23}.item_count = 2;
sparking_system_shop_data{23}.cost = 50;
sparking_system_shop_data{24}.item_id = '31023'; % 2 Incandescent Alloy for 40
sparking_system_shop_data{24}.item_count = 2;
sparking_system_shop_data{24}.cost = 40;
sparking_system_shop_data{37}.item_id = '31033'; % 2 Crystalline Component for 40
sparking_system_shop_data{37}.item_count = 2;
sparking_system_shop_data{37}.cost = 40;
% t4
sparking_system_shop_data{25}.item_id = '30014'; % 1 Orirock Concentration for 60
sparking_system_shop_data{25}.item_count = 1;
sparking_system_shop_data{25}.cost = 60;
sparking_system_shop_data{26}.item_id = '30024'; % 1 Sugar Lump for 75
sparking_system_shop_data{26}.item_count = 1;
sparking_system_shop_data{26}.cost = 75;
sparking_system_shop_data{27}.item_id = '30034'; % 1 Polyester Lump for 80
sparking_system_shop_data{27}.item_count = 1;
sparking_system_shop_data{27}.cost = 80;
sparking_system_shop_data{28}.item_id = '30044'; % 1 Oriron Block for 90
sparking_system_shop_data{28}.item_count = 1;
sparking_system_shop_data{28}.cost = 90;
sparking_system_shop_data{29}.item_id = '30054'; % 1 Keton Colloid for 85
sparking_system_shop_data{29}.item_count = 1;
sparking_system_shop_data{29}.cost = 85;
sparking_system_shop_data{30}.item_id = '30064'; % 1 Optimized Device for 85
sparking_system_shop_data{30}.item_count = 1;
sparking_system_shop_data{30}.cost = 85;
% more t4
sparking_system_shop_data{31}.item_id = '30074'; % 1 White Horse Kohl for 65
sparking_system_shop_data{31}.item_count = 1;
sparking_system_shop_data{31}.cost = 65;
sparking_system_shop_data{32}.item_id = '30084'; % 1 Manganese Trihydrate for 80
sparking_system_shop_data{32}.item_count = 1;
sparking_system_shop_data{32}.cost = 80;
sparking_system_shop_data{33}.item_id = '30094'; % 1 Grindstone Pentahydrate for 75
sparking_system_shop_data{33}.item_count = 1;
sparking_system_shop_data{33}.cost = 75;
sparking_system_shop_data{34}.item_id = '30104'; % 1 RMA70-24 for 80
sparking_system_shop_data{34}.item_count = 1;
sparking_system_shop_data{34}.cost = 80;
sparking_system_shop_data{35}.item_id = '31014'; % 1 Polymerized Gel for 65
sparking_system_shop_data{35}.item_count = 1;
sparking_system_shop_data{35}.cost = 65;
sparking_system_shop_data{36}.item_id = '31024'; % 1 Incandescent Alloy Block for 75
sparking_system_shop_data{36}.item_count = 1;
sparking_system_shop_data{36}.cost = 75;
sparking_system_shop_data{38}.item_id = '31034'; % 1 Crystalline Circuit for 90
sparking_system_shop_data{38}.item_count = 1;
sparking_system_shop_data{38}.cost = 90;
% calculate efficiency
sparking_system_shop_efficiencies = [];
for i = 1 : numel(sparking_system_shop_data)
    item_id = sparking_system_shop_data{i}.item_id;
    item_cost = sparking_system_shop_data{i}.cost;
    item_count = sparking_system_shop_data{i}.item_count;
    item_index = item_indices(item_id);
    item_sanity_value = V(item_index) * item_count;
    sparking_system_shop_efficiencies(i) = item_sanity_value / item_cost;
end
[tmp, sorted_sparking_system_shop_efficiencies_indices] = sort(sparking_system_shop_efficiencies, 'descend');
fprintf(fileID, "Calculated best Headhunting Parametric Models shop buys:\n");
for j = 1 : numel(sorted_sparking_system_shop_efficiencies_indices)
    i = sorted_sparking_system_shop_efficiencies_indices(j);
    item_id = sparking_system_shop_data{i}.item_id;
    item_count = sparking_system_shop_data{i}.item_count;
    item_cost = sparking_system_shop_data{i}.cost;
    item_index = item_indices(item_id);
    item_name = item_names{item_index};
    item_sanity_value = V(item_index) * item_count;
    entry_name = item_count + " " + item_name + "(s) for " + item_cost + " Headhunting Parametric Models";
    entry_efficiency = sparking_system_shop_efficiencies(i);
    fprintf(fileID, "%s (%g sanity per model)\n", entry_name, entry_efficiency);
end
fprintf(fileID, "------------------------------------------------------------\n");
%% display inefficient craft recipes
% tmp = round(R, 4);
% fprintf(fileID, "Inefficient craft recipes:\n");
% inefficient_craft_stage_indices = find( all([S<=0 tmp<0], 2) );
% for i = 1 : numel(inefficient_craft_stage_indices)
%     stage_index = inefficient_craft_stage_indices(i);
%     stage_name = activity_names{stage_index};
%     fprintf(fileID, "%s, revenue: %6.3f\n", stage_name, tmp(stage_index));
% end
% fprintf(fileID, "------------------------------------------------------------\n");
%% output technical more technical information
fprintf(fileID, "Calculated sanity values of items:\n");
fprintf(fileID, "Item | Sanity Value \n");
for i = 1 : numel(V)
    item_index = i;
    item_name = item_names{item_index};
    item_sanity_value = V(item_index);
    fprintf(fileID, "%s %f\n", item_name, item_sanity_value);
end
fprintf(fileID, "------------------------------------------------------------\n");
fprintf(fileID, "Calculated revenue values of activities(stages + crafts):\n");
fprintf(fileID, "Activitiy | Revenue \n");
for i = 1 : numel(R)
    activity_index = i;
    activity_name = activity_names{i};
    activity_revenue = R(i);
    fprintf(fileID, "%s %f\n", activity_name, activity_revenue);
end
%% close file and end
disp("Done")
fclose(fileID);
