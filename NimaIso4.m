function [ color , number ] = NimaIso4( gameInfo, playerID)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

% array of the colors
colorOptions = {'red', 'yellow', 'green', 'blue'};
MAXCOST=36;
CLOSEPOS=11;
X2CLOSE = 5;
%% check if its my turn
if (gameInfo.turnOrder(1) == playerID)
    isItMyTurn=true;
else
    isItMyTurn = false;
end

%% variables used for decision
cost = 0;
bestIdx = 0;
bestNumber =-1;
bestColor = 'purple';
persistent action2Num;
persistent action2Color;
persistent takeAction2;


%% get information about the rolled dice
rollInfo = getRollInfo(gameInfo,playerID,isItMyTurn);

for colorIdx=1:4  % loop through colors
    currentColor = cell2mat(colorOptions(colorIdx));
    if (isItMyTurn) %% decide on an action when it is your turn
        % action 1
        if (gameInfo.action == 1) % can pick from white dice
            takeAction2 = false;
            action2Num = -1;
            action2Color = 'purple';
            action1taken =false;
            if( rollInfo.Wpos(colorIdx)==CLOSEPOS && rollInfo.xNum(colorIdx) > X2CLOSE...
                    && max(rollInfo.Cpos(colorIdx,:)) ~= CLOSEPOS) % check if the row can be closed by the white roll
                if(cost==MAXCOST && rollInfo.xNum(colorIdx) <= rollInfo.xNum(bestIdx)) % if more than one can be closed
                    % do nothing
                else
                    cost = MAXCOST;
                    action1taken = true;
                    bestIdx = colorIdx;
                    bestColor = currentColor;
                    bestNumber = rollInfo.whiteRoll;
                end
                
            elseif (rollInfo.Wpos(colorIdx) ~= 0 && rollInfo.WskipProb(colorIdx) <= 3) % consider taking the number
                tempCost = rollInfo.WrightProb(colorIdx)-rollInfo.WskipProb(colorIdx);
                if(tempCost > cost)
                    cost = tempCost;
                    action1taken = true;
                    bestIdx = colorIdx;
                    bestColor = currentColor;
                    bestNumber = rollInfo.whiteRoll;
                end
            end
            
            if(~action1taken)
                % check if both the colored and the white roll can be taken in the
                % same row
                for ii=1:2
                    if(rollInfo.Wpos(colorIdx) ~= 0 ...
                            && rollInfo.Wpos(colorIdx) < rollInfo.Cpos(colorIdx,ii) )
                        % check if the row can be closed
                        if(rollInfo.Cpos(colorIdx,ii) == CLOSEPOS && rollInfo.xNum(colorIdx)> X2CLOSE-1)
                            % then take both rolls in this row
                            if(cost==MAXCOST && rollInfo.xNum(colorIdx) <= rollInfo.xNum(bestIdx)) % if more than one can be closed
                                % do nothing
                            else
                                cost=MAXCOST;
                                bestIdx = colorIdx;
                                bestColor = currentColor;
                                bestNumber = rollInfo.whiteRoll;
                                takeAction2 = true;
                                action2Num = rollInfo.colorRoll(colorIdx,ii);
                                action2Color = currentColor;
                            end
                            
                        elseif(rollInfo.Cpos(colorIdx,ii) ~= CLOSEPOS)
                            % check if it's better to take both of them
                            tempCost = rollInfo.CrightProb(colorIdx,ii) - rollInfo.CskipProb(colorIdx,ii) + rollInfo.Wprob(colorIdx);
                            if(tempCost > cost)
                                cost = tempCost;
                                bestIdx = colorIdx;
                                bestColor = currentColor;
                                bestNumber = rollInfo.whiteRoll;
                                takeAction2 = true;
                                action2Num = rollInfo.colorRoll(colorIdx,ii);
                                action2Color = currentColor;
                            end
                            
                        end
                    end
                    % check if just the white is better
                    if(rollInfo.Wpos(colorIdx) ~= 0)
                        % check if the row can be closed
                        if(rollInfo.Wpos(colorIdx) == CLOSEPOS && rollInfo.xNum(colorIdx)> X2CLOSE)
                            if(cost==MAXCOST && rollInfo.xNum(colorIdx) <= rollInfo.xNum(bestIdx)) % if more than one can be closed
                                % do nothing
                            else
                                cost = MAXCOST;
                                bestIdx = colorIdx;
                                bestColor = currentColor;
                                bestNumber = rollInfo.whiteRoll;
                                takeAction2 = false;
                            end
                        else
                            % check if just the white roll is good
                            tempCost = rollInfo.WrightProb(colorIdx)-rollInfo.WskipProb(colorIdx);
                            if(tempCost > cost)
                                cost = tempCost;
                                bestIdx = colorIdx;
                                bestColor = currentColor;
                                bestNumber = rollInfo.whiteRoll;
                                takeAction2 = false;
                            end
                        end
                    end
                    % check if just the colored roll is better
                    if(rollInfo.Cpos(colorIdx,ii) ~= 0)
                        if( rollInfo.Cpos(colorIdx,ii)==CLOSEPOS && rollInfo.xNum(colorIdx) > X2CLOSE) % check if the row can be closed
                            if(cost==MAXCOST && rollInfo.xNum(colorIdx) <= rollInfo.xNum(bestIdx)) % if more than one can be closed
                                % do nothing
                            else
                                cost = MAXCOST;
                                bestIdx = colorIdx;
                                bestColor =  'purple';
                                bestNumber = -1;
                                takeAction2 = true;
                                action2Num = rollInfo.colorRoll(colorIdx,ii);
                                action2Color = currentColor;
                            end
                            
                        elseif (rollInfo.Cpos(colorIdx,ii) ~= 0) % consider taking the number
                            tempCost = rollInfo.CrightProb(colorIdx,ii)-rollInfo.CskipProb(colorIdx,ii);
                            if(tempCost > cost)
                                cost = tempCost;
                                bestIdx = colorIdx;
                                bestColor =  'purple';
                                bestNumber = -1;
                                takeAction2 = true;
                                action2Num = rollInfo.colorRoll(colorIdx,ii);
                                action2Color = currentColor;
                            end
                        end
                    end
                end
            end

       % action 2
        else
            if (takeAction2) % pick from the colored dice
                bestNumber = action2Num;
                bestColor = action2Color;
            else
                for ii=1:2
                    if (rollInfo.Cpos(colorIdx,ii) ~= 0 && rollInfo.CskipProb(colorIdx,ii) <= 3) % consider taking the number
                        tempCost = rollInfo.CrightProb(colorIdx,ii)-rollInfo.CskipProb(colorIdx,ii);
                        if(tempCost > cost)
                            cost = tempCost;
                            bestIdx = colorIdx;
                            bestNumber = rollInfo.colorRoll(colorIdx,ii);
                            bestColor = currentColor;
                        end
                    end
                end
                
            end
            
        end
        
    else %% decide on an action when it is not your turn
        if( rollInfo.Wpos(colorIdx)==CLOSEPOS && rollInfo.xNum(colorIdx) > X2CLOSE) % check if the row can be closed
            if(cost==MAXCOST && rollInfo.xNum(colorIdx) <= rollInfo.xNum(bestIdx)) % if more than one can be closed
                % do nothing
            else
                cost = MAXCOST;
                bestIdx = colorIdx;
                bestColor = currentColor;
                bestNumber = rollInfo.whiteRoll;
            end
            
        elseif (rollInfo.Wpos(colorIdx) ~= 0 && rollInfo.WskipProb(colorIdx) <= 3) % consider taking the number
            tempCost = rollInfo.WrightProb(colorIdx)-rollInfo.WskipProb(colorIdx);
            if(tempCost > cost)
                cost = tempCost;
                bestIdx = colorIdx;
                bestColor = currentColor;
                bestNumber = rollInfo.whiteRoll;
            elseif(tempCost == cost ... % two similar options
                    && ((colorIdx==3 || colorIdx==4) && (bestIdx==1 || bestIdx==2)))% one from the first two row and the second from the last two 
                if(rollInfo.xNum(colorIdx) > rollInfo.xNum(bestIdx))
                    cost = tempCost;
                    bestIdx = colorIdx;
                    bestColor = currentColor;
                    bestNumber = rollInfo.whiteRoll;
                end
                    
            end
        end
    end
end
color = bestColor;
number = bestNumber;
% scorecard = gameInfo.player(playerID)
end

function rollInfo= getRollInfo(gameInfo,playerID,isItMyTurn)
rollInfo.whiteRoll = gameInfo.dice.white(1) + gameInfo.dice.white(2); % add the number of white dice rolled
scorecard = gameInfo.player(playerID);
probVec = [1:6,5:-1:1];
for colorIdx=1:4  % loop through colors
    
    color = cell2mat(gameInfo.colorOptions(colorIdx));
    colorRow = scorecard.(color);
    rollInfo.xNum(colorIdx) = sum(colorRow);
    % set defailt values
    rollInfo.Wpos(colorIdx)=0;
    rollInfo.WskipProb(colorIdx)=-1;
    rollInfo.WrightProb(colorIdx)=-1;
    rollInfo.Wprob(colorIdx)=-1;
    rollInfo.Cpos(colorIdx,1:2)=[0,0];
    rollInfo.CskipProb(colorIdx,1:2)=[-1,-1];
    rollInfo.CrightProb(colorIdx,1:2)=[-1,-1];
    rollInfo.Cprob(colorIdx,1:2)=[-1,-1];
    
    % check if color is NOT closed
    if(~gameInfo.closedColors(colorIdx))
        
        % set the color map depending of the color
        if ( colorIdx <=2 )
            indexMap = 2:1:12;
        else
            indexMap = 12:-1:2;
        end
        
        % get the position of the most right X
        if(rollInfo.xNum(colorIdx)>0)
            indexOfLeftX = find(colorRow == 1,1,'last');
        else
            indexOfLeftX = 0;
        end
        
        %%%%%%%%%%%%%% get info on the white roll %%%%%%%%%%%%%
        % get the position of the white roll
        indexOfValue = find (indexMap == rollInfo.whiteRoll);
        
        % check if the white roll is valid
        if(indexOfLeftX < indexOfValue)
            rollInfo.Wpos(colorIdx) = indexOfValue;
            rollInfo.WskipProb(colorIdx) = sum(probVec(indexOfLeftX+1:indexOfValue-1));
            rollInfo.WrightProb(colorIdx) = sum(probVec(indexOfValue+1:end));
            rollInfo.Wprob(colorIdx) = probVec(indexOfValue);
        end
        
        %%%%%%%%%%%%%% get info on the colored roll %%%%%%%%%%%%%
        if (isItMyTurn)
            colorRoll(1) = gameInfo.dice.white(1) + gameInfo.dice.(color);
            colorRoll(2) = gameInfo.dice.white(2) + gameInfo.dice.(color);
            
            
            % get the position of the color roll
            indexOfValue(1) = find (indexMap == colorRoll(1));
            indexOfValue(2) = find (indexMap == colorRoll(2));
            indexOfValue=sort(indexOfValue);
            
            % check if the colored rolls are valid
            if (indexOfLeftX >= indexOfValue(2)) % both options don't work
                indexOfValue=[0,0];
            elseif (indexOfLeftX >= indexOfValue(1)) % option 2 works but one does not
                indexOfValue(1) = 0;
            elseif (indexOfValue(1) == indexOfValue(2)) % both options work but second option is the same as the first
                indexOfValue(2) = 0;
            end
            
            % check if there is a good colored roll
            for ii=1:2
                if(indexOfValue(ii)>0)
                    rollInfo.Cpos(colorIdx,ii) = indexOfValue(ii);
                    rollInfo.colorRoll(colorIdx,ii) = indexMap(indexOfValue(ii));
                    rollInfo.CskipProb(colorIdx,ii) = sum(probVec(indexOfLeftX+1:indexOfValue(ii)-1));
                    rollInfo.CrightProb(colorIdx,ii) = sum(probVec(indexOfValue(ii)+1:end));
                    rollInfo.Cprob(colorIdx,ii) = probVec(indexOfValue(ii));
                end
            end
        end
    end
end
end



















