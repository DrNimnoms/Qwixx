function [ dice] = rollDice( )
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
dice.red    = randi([1,6],1);
dice.yellow = randi([1,6],1);
dice.green  = randi([1,6],1);
dice.blue   = randi([1,6],1);
dice.white  = randi([1 6],1,2);

end

