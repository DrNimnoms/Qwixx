function [ color , number ] = Joe( gameInfo, playerID)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here


colorOptions = {'red', 'yellow', 'green', 'blue'};
myName = gameInfo.playerNames(playerID);
rollersName = gameInfo.playerNames(gameInfo.turnOrder(1));
isItMyTurn = strcmp(rollersName, myName); % equivalently gameInfo.turnOrder(1) == playerID 


%investigate player struct to make decisions...

if (gameInfo.action == 1)
    %randomly pick a color
    color = cell2mat(colorOptions(randi([1,4])));
    number = gameInfo.dice.white(2) + gameInfo.dice.white(1);
end

if (gameInfo.action == 2)
    %randomly pick one of the white gameInfo.dice and one of the colors
    color = cell2mat(colorOptions(randi([1,4])));
    number = gameInfo.dice.white(randi([1,2])) + gameInfo.dice.(color);
end

end

