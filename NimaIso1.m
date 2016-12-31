function [ color , number ] = NimaIso1( gameInfo, playerID)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

myName = 'NimaIso1';
rollersName = gameInfo.playerNames(gameInfo.turnOrder(1));
isItMyTurn = strcmp(rollersName, myName);

colorOptions = {'red', 'yellow', 'green', 'blue'};

%investigate player struct to make decisions...
number =0;
color = cell2mat(colorOptions(randi([1,4])));
value =0;
bestNum=0;
bestCol=color;
a1=0;

if (isItMyTurn)
    testNum = gameInfo.dice.white(2) + gameInfo.dice.white(1);
    for ii=1:4
        testColor=cell2mat(colorOptions(ii)); 
        testNum(2)=gameInfo.dice.white(1) + gameInfo.dice.(testColor);
        testNum(3)=gameInfo.dice.white(2) + gameInfo.dice.(testColor);
        for jj=1:3
            testvalue = whatPos(gameInfo,playerID, testColor ,testNum(jj));
            if(testvalue>value)
                value = testvalue;
                bestNum = testNum(jj);
                bestCol = testColor;
                if(jj==1) 
                    a1=1;
                else
                    a1=0;
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
else
    whiteNum =gameInfo.dice.white(2) + gameInfo.dice.white(1);
    
end

end

function pos = whatPos(gameInfo,playerID, color , number)

    scorecard = gameInfo.player(playerID);
    colorRow = scorecard.(color);
    if ( strcmp(color, 'yellow') || strcmp(color, 'red'))
        indexMap = 2:1:12;
    elseif ( strcmp(color, 'green') || strcmp(color, 'blue'))
        indexMap = 12:-1:2;
    end
    
    indexOfValue = find (indexMap == number);
    numCrossesToRightOfValue = sum(colorRow(indexOfValue : end));
    
    if (numCrossesToRightOfValue>0)
        pos = 0;
    else
        pos = 11-indexOfValue;
    end
    
end