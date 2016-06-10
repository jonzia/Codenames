% Codenames AI: Give Clues
% Created by: Jonathan Zia

clear;clc;

% -------------------------------------------------------------------------
% Obtaining Game Information
% -------------------------------------------------------------------------

% Obtaining the codenames for Team A (AI)
prompt = 'Number of Codenames for AI: ';
numA = input(prompt);
TeamA = cell(numA,1);
for i = 1:numA
    prompt = ['Enter Codename #' num2str(i) ': '];
    TeamA{i,1} = input(prompt,'s');
end
disp(char(10));

% disp('Opponent Codenames');
% % Obtaining the codenames for Team B (Opponent)
numB = 17-numA;
% TeamB = cell(numB,1);
% for i = 1:numB
%     prompt = ['Enter Codename #' num2str(i) ': '];
%     TeamB{i,1} = input(prompt,'s');
% end
% disp(char(10));

% disp('Civilian Codenames');
% % Obtaining the codenames for Team C (Civilians)
numC = 7;
% TeamC = cell(numC,1);
% for i = 1:numC
%     prompt = ['Enter Codename #' num2str(i) ': '];
%     TeamC{i,1} = input(prompt,'s');
% end
% disp(char(10));

% disp('Assassin Codenames');
% % Obtaining the codenames for Team D (Assassin)
% TeamD = cell(1,1);
% prompt = ['Enter Codename: '];
% TeamD{1,1} = input(prompt,'s');
% disp(char(10));

while numA > 0 && numB > 0
    % Creating cell arrays to hold hypernyms
    HypeA = cell(numA,1); HypeB = cell(numB,1);
    HypeC = cell(numC,1); HypeD = cell(1,1);
    % Creating cell arrays to hold hyponyms
    HypoA = cell(numA,1); HypoB = cell(numB,1);
    HypoC = cell(numC,1); HypoD = cell(1,1);
    % Creating cell arrays to hold meronyms
    MerA = cell(numA,1); MerB = cell(numB,1);
    MerC = cell(numC,1); MerD = cell(1,1);

    % Importing .mat data files for all codenames
    % TeamA
    for i = 1:numA
        filename1 = [TeamA{i,1} '.mat'];
        filename2 = [TeamA{i,1} ' meronyms.mat'];
        load(filename1);
        if isempty(temp1) == false
            HypoA{i,1} = temp1(:,1:2);
            HypeA{i,1} = temp1(:,3:end);
        end
        load(filename2);
        if isempty(temp2) == false
            MerA{i,1} = temp2;
        end
    end
    % TeamB
%     for i = 1:numB
%         filename1 = [TeamB{i,1} '.mat'];
%         filename2 = [TeamB{i,1} ' meronyms.mat'];
%         load(filename1);
%         if isempty(temp1) == false
%             HypoB{i,1} = temp1(:,1:2);
%             HypeB{i,1} = temp1(:,3:end);
%         end
%         load(filename2);
%         if isempty(temp2) == false
%             MerB{i,1} = temp2;
%         end
%     end
    % TeamC
%     for i = 1:numC
%         filename1 = [TeamC{i,1} '.mat'];
%         filename2 = [TeamC{i,1} ' meronyms.mat'];
%         load(filename1);
%         if isempty(temp1) == false
%             HypoC{i,1} = temp1(:,1:2);
%             HypeC{i,1} = temp1(:,3:end);
%         end
%         load(filename2);
%         if isempty(temp2) == false
%             MerC{i,1} = temp2;
%         end
%     end
    % TeamD
%     for i = 1:1
%         filename1 = [TeamD{i,1} '.mat'];
%         filename2 = [TeamD{i,1} ' meronyms.mat'];
%         load(filename1);
%         if isempty(temp1) == false
%             HypoD{i,1} = temp1(:,1:2);
%             HypeD{i,1} = temp1(:,3:end);
%         end
%         load(filename2);
%         if isempty(temp2) == false
%             MerD{i,1} = temp2;
%         end
%     end

    % -------------------------------------------------------------------------
    % Generating Clue
    % -------------------------------------------------------------------------

    % -------------------------------------------------------------------------
    % Search for hypernym connections
    % -------------------------------------------------------------------------

    specialCase = 0; % Special Case = no connections returned

    hypArray = cell(numA,numA); wCounter = 0; hCounter1 = 0;
    h = waitbar(wCounter/(numA-1),'Searching Hypernym Trees');
    for i = 1:numA-1
        progress = wCounter/(numA-1);
        waitbar(progress);
        breaker = 0;
        for j = i+1:numA % The word (i) is being compared to word (j)
            iSize = size(HypeA{i,1}); jSize = size(HypeA{j,1});
            iTemp = 0; jTemp = 0;
            % Picking a hypernym from word (i)
            for k = 1:2:iSize(1,2) % Column counter for word (i)
                for l = 1:iSize(1,1) % Row counter for word (i)
                    iTemp = HypeA{i,1}{l,k};
                    for m = 1:2:jSize(1,2) % Column counter for word (j)
                        for n = 1:jSize(1,1) % Row counter for word (j)
                            jTemp = HypeA{j,1}{n,m};
                            if strcmp(iTemp,jTemp) == 1 && isempty(strfind(iTemp,'_'))
                                % Calculate certainty
                                temp1 = str2double(HypeA{i,1}{l,k+1});
                                temp2 = str2double(HypeA{j,1}{n,m+1});
                                certainty = 1/temp1 + 1/temp2;
                                hypArray{i,j} = {iTemp, certainty};
                                breaker = 1; break;
                            end
                        end
                        if breaker == 1
                            break;
                        end
                    end
                end
                if breaker == 1
                    hCounter1 = hCounter1 + 1;
                    break;
                end
            end
        end
        wCounter = wCounter + 1;
    end
    close(h);
    % Analyzing hypArray to find best hypernyms
    hCounter2 = 0;
    temp1 = cell(hCounter1,1); % Creating cell array for duplicate-checking
    for i = 1:(numA-1)
        for j = i:numA
            if isempty(hypArray{i,j}) == 0
                hCounter2 = hCounter2 + 1;
                temp1{hCounter2,1} = hypArray{i,j};
            end
        end
    end
    % Consolidating duplicates
    if hCounter2 > 0
        temp2 = hCounter2;
        temp3 = cell(hCounter2,2); temp3{1,1} = temp1{1,1};
        for i = 1:hCounter2
            temp3{i,2} = 2;
        end
        for i = 1:hCounter2-1
            breaker = 0;
            for j = i+1:hCounter2
                if isempty(temp1{j,1}) == 0
                    t1 = temp1{j,1}{1,1};
                    t3 = temp3{i,1}{1,1};
                    bool = contains(temp3,temp1,i,j);
                    if strcmp(t1,t3)
                        temp = temp1{j,1}{1,2};
                        temp3{i,1}{1,2} = temp3{i,1}{1,2}*temp;
                        temp3{i,2} = temp3{i,2} + 1;
                        temp2 = temp2 - 1;
                    elseif breaker == 0 && bool == 0
                        temp3{i+1,1} = temp1{j,1};
                        breaker = 1;
                        temp1{j,1} = [];
                    end
                end
            end
            if breaker == 0
                break;
            end
        end
        hypernymConnections = temp3(1:temp2,1:2);
        % Outputting best hypernym clue
        maxIndex = 1;
        max = 0;
        for i = 1:temp2
            if temp3{i,1}{1,2}*2^(temp3{i,2}) > max;
                max = temp3{i,1}{1,2}*2^(temp3{i,2});
                maxIndex = i;
            end
        end
        HypernymClue = {temp3{maxIndex,1}{1,1}, temp3{maxIndex,2}};
        else
            HypernymClue = cell(1,1);
            specialCase = specialCase + 1;
    end

    % -------------------------------------------------------------------------
    % Search for hyponym connections
    % -------------------------------------------------------------------------

    hypoArray = cell(numA,numA); wCounter = 0; hCounter1 = 0;
    h = waitbar(wCounter/(numA-1),'Searching Hyponyms');
    for i = 1:numA-1
        progress = wCounter/(numB-1);
        waitbar(progress);
        breaker = 0;
        for j = i+1:numA % The word (i) is being compared to word (j)
            iSize = size(HypoA{i,1}); jSize = size(HypoA{j,1});
            iTemp = 0; jTemp = 0;
            % Picking a hypernym from word (i)
            for k = 1:1 % Column counter for word (i)
                for l = 1:iSize(1,1) % Row counter for word (i)
                    iTemp = HypoA{i,1}{l,k};
                    for m = 1:1 % Column counter for word (j)
                        for n = 1:jSize(1,1) % Row counter for word (j)
                            jTemp = HypoA{j,1}{n,m};
                            if strcmp(iTemp,jTemp) == 1 && isempty(strfind(iTemp,'_'))
                                % Calculate certainty
                                temp1 = str2double(HypoA{i,1}{l,k+1});
                                temp2 = str2double(HypoA{j,1}{n,m+1});
                                certainty = temp1 + temp2;
                                hypoArray{i,j} = {iTemp, certainty};
                                breaker = 1; break;
                            end
                        end
                        if breaker == 1
                            break;
                        end
                    end
                end
                if breaker == 1
                    hCounter1 = hCounter1 + 1;
                    break;
                end
            end
        end
        wCounter = wCounter + 1;
    end
    close(h);
    % Analyzing hypArray to find best hypernyms
    hCounter2 = 0;
    temp1 = cell(hCounter1,1); % Creating cell array for duplicate-checking
    for i = 1:(numA-1)
        for j = i:numA
            if isempty(hypoArray{i,j}) == 0
                hCounter2 = hCounter2 + 1;
                temp1{hCounter2,1} = hypoArray{i,j};
            end
        end
    end
    % Consolidating duplicates
    if hCounter2 > 0
        temp2 = hCounter2;
        temp3 = cell(hCounter2,2); temp3{1,1} = temp1{1,1};
        for i = 1:hCounter2
            temp3{i,2} = 2;
        end
        for i = 1:hCounter2-1
            breaker = 0;
            for j = i+1:hCounter2
                if isempty(temp1{j,1}) == 0
                    t1 = temp1{j,1}{1,1};
                    t3 = temp3{i,1}{1,1};
                    bool = contains(temp3,temp1,i,j);
                    if strcmp(t1,t3)
                        temp = temp1{j,1}{1,2};
                        temp3{i,1}{1,2} = temp3{i,1}{1,2}*temp;
                        temp3{i,2} = temp3{i,2} + 1;
                        temp2 = temp2 - 1;
                    elseif breaker == 0 && bool == 0
                        temp3{i+1,1} = temp1{j,1};
                        breaker = 1;
                        temp1{j,1} = [];
                    end
                end
            end
            if breaker == 0
                break;
            end
        end
        hyponymConnections = temp3(1:temp2,1:2);
        % Outputting best hypernym clue
        maxIndex = 1;
        max = 0;
        for i = 1:temp2
            if temp3{i,1}{1,2}*2^(temp3{i,2}) > max;
                max = temp3{i,1}{1,2}*2^(temp3{i,2});
                maxIndex = i;
            end
        end
        HyponymClue = {temp3{maxIndex,1}{1,1}, temp3{maxIndex,2}};
    else
        HyponymClue = cell(1,2);
        specialCase = specialCase + 1;
    end

    % -------------------------------------------------------------------------
    % Search for meronym connections
    % -------------------------------------------------------------------------

    merArray = cell(numA,numA); wCounter = 0; hCounter1 = 0;
    h = waitbar(wCounter/(numA-1),'Searching Part Meronyms');
    for i = 1:numA-1
        progress = wCounter/(numA-1);
        waitbar(progress);
        breaker = 0;
        for j = i+1:numA % The word (i) is being compared to word (j)
            iSize = size(MerA{i,1}); jSize = size(MerA{j,1});
            iTemp = 0; jTemp = 0;
            % Picking a hypernym from word (i)
            for k = 1:1 % Column counter for word (i)
                for l = 1:iSize(1,1) % Row counter for word (i)
                    iTemp = MerA{i,1}{l,k};
                    for m = 1:1 % Column counter for word (j)
                        for n = 1:jSize(1,1) % Row counter for word (j)
                            jTemp = MerA{j,1}{n,m};
                            if strcmp(iTemp,jTemp) == 1 && isempty(strfind(iTemp,'_'))
                                % Calculate certainty
                                temp1 = str2double(MerA{i,1}{l,k+1});
                                temp2 = str2double(MerA{j,1}{n,m+1});
                                certainty = temp1 + temp2;
                                merArray{i,j} = {iTemp, certainty};
                                breaker = 1; break;
                            end
                        end
                        if breaker == 1
                            break;
                        end
                    end
                end
                if breaker == 1
                    hCounter1 = hCounter1 + 1;
                    break;
                end
            end
        end
        wCounter = wCounter + 1;
    end
    close(h);
    % Analyzing hypArray to find best hypernyms
    hCounter2 = 0;
    temp1 = cell(hCounter1,1); % Creating cell array for duplicate-checking
    for i = 1:(numA-1)
        for j = i:numA
            if isempty(merArray{i,j}) == 0
                hCounter2 = hCounter2 + 1;
                temp1{hCounter2,1} = merArray{i,j};
            end
        end
    end
    % Consolidating duplicates
    if hCounter2 > 0
        temp2 = hCounter2;
        temp3 = cell(hCounter2,2); temp3{1,1} = temp1{1,1};
        for i = 1:hCounter2
            temp3{i,2} = 2;
        end
        for i = 1:hCounter2-1
            breaker = 0;
            for j = i+1:hCounter2
                if isempty(temp1{j,1}) == 0
                    t1 = temp1{j,1}{1,1};
                    t3 = temp3{i,1}{1,1};
                    bool = contains(temp3,temp1,i,j);
                    if strcmp(t1,t3)
                        temp = temp1{j,1}{1,2};
                        temp3{i,1}{1,2} = temp3{i,1}{1,2}*temp;
                        temp3{i,2} = temp3{i,2} + 1;
                        temp2 = temp2 - 1;
                    elseif breaker == 0 && bool == 0
                        temp3{i+1,1} = temp1{j,1};
                        breaker = 1;
                        temp1{j,1} = [];
                    end
                end
            end
            if breaker == 0
                break;
            end
        end
        meronymConnections = temp3(1:temp2,1:2);
        % Outputting best hypernym clue
        maxIndex = 1;
        max = 0;
        for i = 1:temp2
            if temp3{i,1}{1,2}*2^(temp3{i,2}) > max;
                max = temp3{i,1}{1,2}*2^(temp3{i,2});
                maxIndex = i;
            end
        end
        MeronymClue = {temp3{maxIndex,1}{1,1}, temp3{maxIndex,2}};
    else
        MeronymClue = cell(1,2);
        specialCase = specialCase + 1;
    end

    % -------------------------------------------------------------------------
    % Special case (no other connections)
    % -------------------------------------------------------------------------
    if specialCase == 3
        index = round(numA*rand(1,1)); % Choosing a random index
        iSize = size(HypeA{index,1}); breaker = 0;
        jSize = size(HypoA{index,1});
        for i = 1:2:iSize(1,2)
            for j = 1:iSize(1,1);
                if isempty(HypeA{index,1}{j,i}) == 0 && isempty(strfind(HypeA{index,1}{j,i},'_')) == 1
                    Clue = {HypeA{index,1}{j,i},1};
                    h = msgbox([Clue{1,1} ' ' num2str(Clue{1,2})]);
                    breaker = 1; break;
                end
            end
            if breaker == 1
                break;
            end
        end
        if breaker == 0
            for i = 1:1
                for j = 1:jSize(1,1);
                    if isempty(HypoA{index,1}{j,i}) == 0 && isempty(strfind(HypoA{index,1}{j,i},'_')) == 1
                        Clue = {HypoA{index,1}{j,i},1};
                        h = msgbox([Clue{1,1} ' ' num2str(Clue{1,2})]);
                        breaker = 1; break;
                    end
                end
                if breaker == 1
                    break;
                end
            end
        end
        if breaker == 0
            Clue = 'Idk bru';
            h = msgbox(Clue{1,1});
        end
    end
    
    % -------------------------------------------------------------------------
    % Return clue
    % -------------------------------------------------------------------------
    if specialCase ~= 3
        if isempty(MeronymClue{1,1}) == 0
            Clue = MeronymClue;
            h = msgbox([Clue{1,1} ' ' num2str(Clue{1,2})]);
        elseif isempty(HypernymClue{1,1}) == 0
            Clue = HypernymClue;
            h = msgbox([Clue{1,1} ' ' num2str(Clue{1,2})]);
        else
            Clue = HyponymClue;
            h = msgbox([Clue{1,1} ' ' num2str(Clue{1,2})]);
        end
    end
    
    % -------------------------------------------------------------------------
    % Receive input from user and loop back
    % -------------------------------------------------------------------------
    prompt = 'Number of codenames guessed correctly: ';
    guesses = input(prompt);
    if guesses ~= 0
        temp1 = TeamA;
        for i = 1:guesses
            prompt = ['Enter guess #' num2str(i) ':'];
            temp2 = input(prompt,'s');
            for j = 1:numA
                if strcmp(TeamA{j,1},temp2) == 1
                    temp1{j,1} = [];
                end
            end
        end
        counter = 1;
        TeamA = cell(numA-guesses,1);
        for i = 1:numA
            if isempty(temp1{i,1}) == 0
                TeamA{counter,1} = temp1{i,1};
                counter = counter + 1;
            end
        end
        numA = numA - guesses;
    else
        index = round(numA*rand(1,1)); % Choosing a random index
        iSize = size(HypeA{index,1}); breaker = 0;
        jSize = size(HypoA{index,1});
        for i = 1:2:iSize(1,2)
            for j = 1:iSize(1,1);
                if isempty(HypeA{index,1}{j,i}) == 0 && isempty(strfind(HypeA{index,1}{j,i},'_')) == 1
                    Clue = {HypeA{index,1}{j,i},1};
                    h2 = msgbox([Clue{1,1} ' ' num2str(Clue{1,2})]);
                    breaker = 1; break;
                end
            end
            if breaker == 1
                break;
            end
        end
        if breaker == 0
            for i = 1:1
                for j = 1:jSize(1,1);
                    if isempty(HypoA{index,1}{j,i}) == 0 && isempty(strfind(HypoA{index,1}{j,i},'_')) == 1
                        Clue = {HypoA{index,1}{j,i},1};
                        h2 = msgbox([Clue{1,1} ' ' num2str(Clue{1,2})]);
                        breaker = 1; break;
                    end
                end
                if breaker == 1
                    break;
                end
            end
        end
        if breaker == 0
            Clue = 'Idk bru';
            h2 = msgbox(Clue{1,1});
        end
    end
    close all;
end