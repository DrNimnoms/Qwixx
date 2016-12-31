function [ closedColors] = updateClosedColors(gameInfo)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
closedColors = zeros(1,4);

player = gameInfo.player;
numPlayers = gameInfo.numPlayers;
for i = 1:numPlayers
    if ( player(i).red(12) == 1)
        closedColors(1) = 1;
    end
    if ( player(i).yellow(12) == 1)
        closedColors(2) = 1;
    end
    if ( player(i).green(12) == 1)
        closedColors(3) = 1;
    end
    if ( player(i).blue(12) == 1)
        closedColors(4) = 1;
    end
end

end

