function [ valid ] = isValidChoice( playerID, gameInfo, color, value)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
scorecard = gameInfo.player(playerID);
valid = 0;
debug = 1;

% 2 gameInfo.dice can't produce values outside 2-12
if ( value == -1)
    
    if(debug)
        disp('Misthow!')
    end
    return;
    
elseif(value < 2 || value > 12)
    if(debug)
        disp('value not in range')
    end
    return;
    
end


%there are no color tracks beside RYGB
switch color
    case 'yellow'
        if gameInfo.closedColors(2)
            if(debug)
                disp('yellow is closed')
            end
            return
        end
    case 'green'
        if gameInfo.closedColors(3)
            if(debug)
                disp('green is closed')
            end
            return
        end
    case 'blue'
        if gameInfo.closedColors(4)
            if(debug)
                disp('blue is closed')
            end
            return
        end
    case 'red'
        if gameInfo.closedColors(1)
            if(debug)
                disp('red is closed')
            end
            return
        end
    otherwise
        return
end

if (gameInfo.action == 1)
    if (value ~= (gameInfo.dice.white(1)+gameInfo.dice.white(2)))
        if(debug)
            disp('value not the sum of white gameInfo.dice.')
        end
        return
    end
elseif (gameInfo.action == 2)
    possibleValue1 = gameInfo.dice.(color) + gameInfo.dice.white(1);
    possibleValue2 = gameInfo.dice.(color) + gameInfo.dice.white(2);
    if (value ~= possibleValue1 && value ~=possibleValue2)
        if(debug)
            disp('value not the sum of a white die + a colored die.')
        end
        return
    end
else
    return
end

indexRMC = gameInfo.player(playerID).rightMostIndex.(color);
indexOfNumber = getIndexOfNumber(gameInfo,color,value);

if indexRMC >= indexOfNumber
    if(debug)
                disp('number is marked or there exists a cross to the left')
    end
    return;
end


%if last spot check for 5 crosses
if (indexOfNumber == 11)
    numCrossesToLeftOFValue = sum(gameInfo.player(playerID).(color));
    %you need to have 5 crosses to mark the right most value
    if (numCrossesToLeftOFValue < 5)
            if(debug)
                disp('closing number but < 5 crosses')
            end
        return
    end
end


valid = 1;
 
end

