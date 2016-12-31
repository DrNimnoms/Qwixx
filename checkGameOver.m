function [ gameNotOver ] = checkGameOver( gameInfo  )
%UNTITLED7 Summary of this function goes here
%   Detailed explanation goes here
gameNotOver = 1;

for i = 1:gameInfo.numPlayers
    %too many misthrows
    if (sum(gameInfo.player(i).misthrow) == 4)
        gameNotOver = 0;
        return
    end
end

if (sum(gameInfo.closedColors) >= 2)
    gameNotOver = 0;
    return
end
    
end

