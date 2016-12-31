function [ color , number ] = playerDecision( gameInfo, playerID)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here


funcName = cell2mat(gameInfo.playerNames(playerID));
returnVals = '[ color , number ] = ';
argList = '( gameInfo, playerID);';
eval([returnVals,funcName,argList]);

end

