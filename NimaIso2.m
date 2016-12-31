function [ color , number ] = NimaIso2( gameInfo, playerID)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here


colorOptions = {'red', 'yellow', 'green', 'blue'};

%% check if its my turn
isItMyTurn = false;
if (gameInfo.turnOrder(1)==playerID) 
    isItMyTurn=true;
end

colorOptions = {'red', 'yellow', 'green', 'blue'};

%investigate player struct to make decisions...
number =0;
color = cell2mat(colorOptions(randi([1,4])));
cost =0;
bestNum=0;
bestCol=color;
a1=false;

%% decide on an action when your turn
if (isItMyTurn)
    testNum = gameInfo.dice.white(2) + gameInfo.dice.white(1);
    for ii=1:4
        testColor=cell2mat(colorOptions(ii)); 
        testNum(2)=gameInfo.dice.white(1) + gameInfo.dice.(testColor);
        testNum(3)=gameInfo.dice.white(2) + gameInfo.dice.(testColor);
        for jj=1:3
            [pos,skipProb,rightProb,prob,xNum] = getRollInfo(gameInfo,playerID, testColor ,testNum(jj));
%             display(['\\\\\\\\\\\\my turn\\\\\\\\\\\\'])
%             display(['number rolled = ',num2str(testNum(jj))])
%             display(['color num = ',num2str(ii)])
            if(rightProb>cost)
%                 display(['number pos = ',num2str(pos)])
%                 display(['number skipProb = ',num2str(skipProb)])
%                 display(['number rightProb = ',num2str(rightProb)])
%                 display(['number prob = ',num2str(prob)])
                cost = rightProb;
                bestNum = testNum(jj);
                bestCol = testColor;
                if(jj==1) 
                    a1=true;
                else
                    a1=false;
                end
            end
        end
    end
    
    if (gameInfo.action == 1 && a1)
        %randomly pick a color
        color = bestCol;
        number = bestNum;
    end

    if (gameInfo.action == 2 && ~a1)
        %randomly pick one of the white gameInfo.dice and one of the colors
        color = bestCol;
        number = bestNum;
    end
%% decide on an action when not your turn
else
    whiteNum =gameInfo.dice.white(2) + gameInfo.dice.white(1); % add the number of withs rolled not on your turn
    for ii=1:4  %
        testColor=cell2mat(colorOptions(ii));
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





















