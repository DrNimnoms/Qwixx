function [ dice] = rollDice( )
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
dice.red    = randi([1,6],1);
dice.yellow = randi([1,6],1);
dice.green  = randi([1,6],1);
dice.blue   = randi([1,6],1);
dice.white  = randi([1 6],1,2);

% dice.red    = 4;
% dice.yellow = 2;
% dice.green  = 5;
% dice.blue   = 1;
% dice.white  = [6 3];

end

