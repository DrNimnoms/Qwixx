%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
numGames = 500;
playerList = {'Tatyana', 'NimaIso2', 'NimaIso3'};%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



OnePercent = round(numGames/100);
clc
format compact
if (numGames == 1)
    displayText = true;
else
    displayText = false;
end
numWins = zeros(1,size(playerList,2));
tic;
for j=1:numGames
    if (mod(j,OnePercent) == 0)
        timeForOnePercent = toc;
        c = clock;
        hour = c(4);
        minute = c(5);
        seconds = c(6);
        percentLeft = 100 - round(j/numGames*100);
        
        second = seconds + timeForOnePercent*percentLeft;
        while (second >= 60)
            minute = minute + 1;
            second = second - 60;
        end
%         minute = minute + timeForOnePercent*percentLeft/60;
        while (minute >= 60)
            hour = hour + 1;
            minute = minute - 60;
        end
        clc
        display(['Will finish at ', num2str(hour),':',num2str(minute),':',num2str(second)])
        tic
    end
    [winner,gameInfo] = qwixx(playerList,displayText);
    numWins(winner) = numWins(winner) + 1;
end

%3 player 
%3680        3279        3041
%3687        3219        3094

%2 Player
%5180        4820
%
%4 player
%1475        1313        1179        1033
if(~displayText)
    figure
    pie(numWins)
    legend(playerList)
end
numWins