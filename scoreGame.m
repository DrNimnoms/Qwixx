function [ player ] = scoreGame( gameInfo )
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here
player = gameInfo.player;


for i = 1:gameInfo.numPlayers
    player(i).score = player(i).score + crossesToPoints(sum(player(i).red));
    player(i).score = player(i).score + crossesToPoints(sum(player(i).yellow));
    player(i).score = player(i).score + crossesToPoints(sum(player(i).green));
    player(i).score = player(i).score + crossesToPoints(sum(player(i).blue));
    player(i).score = player(i).score - 5*sum(player(i).misthrow);
end

end

