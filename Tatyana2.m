function [ color , number ] = Tatyana2( gameInfo, playerID)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

%TO DO LIST
%how close each color is to becoming closed
%on our turn, check for passing and getting a misthrow

persistent iPassedLastTime;
if (isempty(iPassedLastTime)) %It does not already exist
    iPassedLastTime = 0;
end

debug = 1;
isItMyTurn = (gameInfo.turnOrder(1) == playerID);

%investigate player struct to make decisions...

%FIGURE OUT WHERE THE RIGHT MOST CROSSES ARE ON EACH ROW
rightMostCrossLocations = getRightMostCrosses(gameInfo,playerID);

%FIGURE OUT THE INDEX OF THE BEST DICE SUM FOR EACH COLOR/ROW
colorIndexOfDiceSum = findRowIndicies (gameInfo,playerID)

%CALCULATE OUR OBJECTIVE FUNCTION FOR EACH ROW

[ distanceToRightMostCross ] = calculateDistance(colorIndexOfDiceSum, rightMostCrossLocations, gameInfo  );

maxCrossesForEachColor = colorLifeExpectancy(gameInfo,playerID);
%DECIDE HOW TO USE THE OBJECTIVE FUNCTION AND CHOOSE A VALUE

if (gameInfo.action == 1)
    upperLimitDistance = 3;
elseif (gameInfo.action == 2)
    upperLimitDistance = 4;
    if(iPassedLastTime == 1)
        %Maybe I need to change some shit because I am about to take a -5
        %if I pass again, naw mean?
        upperLimitDistance = 5;
        %Should you fuck up a row at the start? because you still have 3
        %rows to work with. misthrow early on feels sadddddddddd
        %if we passed on action1, then increase bestDistance to 5?
    end
end
[color, number] = chooseTheBestNumber(...
    colorIndexOfDiceSum,distanceToRightMostCross,gameInfo,upperLimitDistance,playerID);


if (number < 0)
    iPassedLastTime = 1;
else
    iPassedLastTime = 0;
end
end


function [ distanceToRightMostCross ] = calculateDistance(...
    colorIndexOfDiceSum, rightMostCross, gameInfo  )

distanceToRightMostCross = colorIndexOfDiceSum - rightMostCross;

%CHECK IF THE COLOR TRACK IS CLOSE BY MAKING DISTANCE REALLY FAR
distanceChanger = gameInfo.closedColors*12;
distanceToRightMostCross = distanceToRightMostCross + distanceChanger;

%CHECK IF THE CROSS IS NOT A VALID POSITION
distanceChanger = (distanceToRightMostCross <= 0 )*24;
distanceToRightMostCross = distanceToRightMostCross + distanceChanger;
end


function  colorIndexOfDiceSum = findRowIndicies (gameInfo,playerID)
for i = 1:4
    color = cell2mat(gameInfo.colorOptions(i));
    if (gameInfo.action == 1)
        sumOfTheTwoDice = gameInfo.dice.white(2) + gameInfo.dice.white(1);
        bestIndex = getIndexOfNumber(gameInfo,color,sumOfTheTwoDice);
    elseif(gameInfo.action == 2)
        valueOfColorDie = gameInfo.dice.(color);
        Combo1 = valueOfColorDie + gameInfo.dice.white(1);
        Combo2 = valueOfColorDie + gameInfo.dice.white(2);
        indexCombo1 = getIndexOfNumber(gameInfo,color,Combo1);
        indexCombo2 = getIndexOfNumber(gameInfo,color,Combo2);
        
        combo1valid  = isValidChoice( playerID, gameInfo, color, Combo1);
        combo2valid  = isValidChoice( playerID, gameInfo, color, Combo2);

        if (combo1valid && combo2valid)
            if ( indexCombo1 <=  indexCombo2)
                bestIndex = indexCombo1;
            else
                bestIndex = indexCombo2;
            end
        elseif (combo1valid)
                bestIndex = indexCombo1;
        else
                bestIndex = indexCombo2;
        end
    end
    colorIndexOfDiceSum(i) = bestIndex;
end
end


function [color, number] = chooseTheBestNumber(...
    colorIndexOfDiceSum,distanceToRightMostCross,gameInfo,upperLimitDistance,playerID)

j = 1;
someOtherCritera = 1;
while (j <= upperLimitDistance && someOtherCritera)
    
    %FIND THE BEST COLOR TO CHOOSE
    whichRowsAreBelowBestDistance = (distanceToRightMostCross < j);
    
    numXs = zeros(1,4);
    for i = 1: length(whichRowsAreBelowBestDistance)
        if( whichRowsAreBelowBestDistance(i) == 1)
            color = cell2mat (gameInfo.colorOptions(i));
            numXs(i) = sum(gameInfo.player(playerID).(color));
        end
    end
    numXs;
    hhhhhh = numXs+whichRowsAreBelowBestDistance;

    if (j <= 2)
        [maxCrossesWithValidDistance, minColor] = max(hhhhhh);
        if (maxCrossesWithValidDistance > 0)
            someOtherCritera = 0;
            color = cell2mat(gameInfo.colorOptions(minColor));
            indexOfNumberInTheBestColorRow = colorIndexOfDiceSum(minColor);
            list = getRowValues(minColor);
            number = list( indexOfNumberInTheBestColorRow );
            return;
        else
            j = j + 1;
        end
    else
        minCrossesWithValidDistance = 100;
        minColor = 0;
        for k = 1:length(hhhhhh)
            if ( (hhhhhh(k) > 0) && (hhhhhh(k) < minCrossesWithValidDistance))
                minCrossesWithValidDistance = hhhhhh(k);
                minColor = k;
            end
        end
        if ((minCrossesWithValidDistance > 0)  && (minCrossesWithValidDistance ~= 100) )
            someOtherCritera = 0;
            color = cell2mat(gameInfo.colorOptions(minColor));
            indexOfNumberInTheBestColorRow = colorIndexOfDiceSum(minColor);
            list = getRowValues(minColor);
            number = list( indexOfNumberInTheBestColorRow );
            return;
        else
            j = j + 1;
        end
    end
    
end

    color = 'pass';
    number = -1;


end


function list = getRowValues(rowNumber)
decrementIndex = 12:-1:2;
incrementIndex = 2:12;
switch rowNumber
    case 1
        list = incrementIndex;
    case 2
        list = incrementIndex;
    case 3
        list = decrementIndex;
    case 4
        list = decrementIndex;
    otherwise
        list = zeros(1,12);
end
end


function rightMostCrossLocations = getRightMostCrosses(gameInfo,playerID)

rightMostCrossLocations = [0,0,0,0];
for j = 1:length(gameInfo.colorOptions)
    colorIamLookingAt  =  cell2mat(gameInfo.colorOptions(j));
    i = 11;
    CrossNotFound = 1;
    while( (i >= 1) && CrossNotFound )
        if(gameInfo.player(playerID).(colorIamLookingAt)(i) == 1)
            rightMostCrossLocations(j) = i;
            CrossNotFound = 0;
        end
        i = i - 1;
    end
end

end

function maxCrossesForEachColor = colorLifeExpectancy(gameInfo,playerID)
numColors = length(gameInfo.colorOptions);
maxCrossesForEachColor = zeros(1,numColors);
for i = 1:gameInfo.numPlayers
    for j = 1:1:numColors
        color = cell2mat (gameInfo.colorOptions(j));
        numXfor1guy1row = sum(gameInfo.player(i).(color));
        if (numXfor1guy1row > maxCrossesForEachColor(j)) 
            maxCrossesForEachColor(j) = numXfor1guy1row;
        end
    end
end 




end




