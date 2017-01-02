function [ scorecard ] = updateCard( playerID, gameInfo, color, value)

scorecard = gameInfo.player(playerID);

indexOfNumber = getIndexOfNumber(gameInfo,color,value);


if (indexOfNumber == 11)
    scorecard.(color)(11) = 1;
    scorecard.(color)(12) = 1;
    scorecard.rightMostIndex.(color) = 12;
else
    scorecard.(color)(indexOfNumber) = 1;
    scorecard.rightMostIndex.(color) = indexOfNumber;
end

