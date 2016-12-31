function [ scorecard, crossMade ] = checkDecision( playerID, gameInfo, color, value)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
scorecard = gameInfo.player(playerID);
crossMade = 0;
debug = 0;

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


colorRow = scorecard.(color);
if ( strcmp(color, 'yellow') || strcmp(color, 'red'))
    indexMap = 2:1:12;
elseif ( strcmp(color, 'green') || strcmp(color, 'blue'))
    indexMap = 12:-1:2;
end

indexOfValue = find (indexMap == value);
numCrossesToRightOfValue = sum(colorRow(indexOfValue : end));

%nothing to right of choice
if (numCrossesToRightOfValue == 0)
    %if choosing rightmost value
    if( indexOfValue == 11)
        numCrossesToLeftOFValue = sum(colorRow(1: 10));
        %you need to have 5 crosses to mark the right most value
        if (numCrossesToLeftOFValue >= 5)
            colorRow(11) = 1;
            %close out bonus cross
            colorRow(12) = 1;
            scorecard.(color) = colorRow;
            crossMade = 1;
        end
    else
        colorRow(indexOfValue) = 1;
        scorecard.(color) = colorRow;
        crossMade = 1;
    end
end
end

