function [ color , number ] = NimaIso3( gameInfo, playerID)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

% array of the colors
colorOptions = {'red', 'yellow', 'green', 'blue'};

% set the number and color to a mishrow
number =-1;
color = 'perpule';

cost =0;
bestNum=0;
bestCol=color;
a1=false;

%% check if its my turn
isItMyTurn = false;
if (gameInfo.turnOrder(1)==playerID) 
    isItMyTurn=true;
end

%% decide on an action when your turn
for colorIdx=1:4  % loop through
    whiteNum = gameInfo.dice.white(2) + gameInfo.dice.white(1); % add the number of withs rolled not on your turn
    testColor = cell2mat(colorOptions(colorIdx));
    if (isItMyTurn)
        if gameInfo.newCrosses
        
        
    else
     
        
        [pos,skipProb,rightProb,prob,xNum] = getRollInfo(gameInfo,playerID, testColor ,whiteNum);
        if (pos ~= -1 && skipProb <= 3) % consider taking the number
            tempCost=rightProb;
            if(tempCost > cost)
%                 display(['\\\\\\\\\\\\not my trun\\\\\\\\\\\\\'])
%                 display(['number rolled = ',num2str(whiteNum)])
%                 display(['color num = ',num2str(ii)])
%                 display(['number pos = ',num2str(pos)])
%                 display(['number skipProb = ',num2str(skipProb)])
%                 display(['number rightProb = ',num2str(rightProb)])
%                 display(['number prob = ',num2str(prob)])
                cost = tempCost;
                color = testColor;
                number = whiteNum;
            end
        end
        
    end
    

end
% scorecard = gameInfo.player(playerID)
end

function [pos,skipProb,rightProb,prob,xNum] = getRollInfo(gameInfo,playerID, color , number)
    scorecard = gameInfo.player(playerID);
    colorRow = scorecard.(color);
    probVec = [1:6,5:-1:1];
    if ( strcmp(color, 'yellow') || strcmp(color, 'red'))
        indexMap = 2:1:12;
    elseif ( strcmp(color, 'green') || strcmp(color, 'blue'))
        indexMap = 12:-1:2;
    end
    
    xNum = sum(colorRow);
    indexOfValue = find (indexMap == number);
    if(xNum>0)
        indexOfLeftX = find(colorRow == 1,1,'last');
    else
        indexOfLeftX = 0;
    end
    
    
    if(indexOfLeftX >= indexOfValue)
        pos=-1;
        skipProb=-1;
        rightProb=-1;
        prob=-1;
    else
        pos = indexOfValue;
        skipProb=sum(probVec(indexOfLeftX+1:indexOfValue-1));
        rightProb=sum(probVec(indexOfValue+1:end));
        prob=probVec(indexOfValue);
    end
    
end





















