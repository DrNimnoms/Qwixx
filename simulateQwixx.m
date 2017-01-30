%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
numGames = 1000;
playerList = {'nimaOptimus1','Tatyana2','NimaIso4'};%, 'NimaIso3''Tatyana',
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


timeLP=0;
alpha=0.08;
OnePercent = round(numGames/100);
clc
format compact
if (numGames == 1)
    displayText = true;
else
    displayText = false;
    h = waitbar(0,'1','Name','Estimating finish time...',...
        'CreateCancelBtn',...
        'setappdata(gcbf,''canceling'',1)');
    setappdata(h,'canceling',0)
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
        if (timeLP==0)
            timeLP=timeForOnePercent*percentLeft;
        else
            timeLP = (1-alpha)*timeLP+alpha*timeForOnePercent*percentLeft;
        end
        second = seconds + timeLP;
        while (second >= 60)
            minute = minute + 1;
            second = second - 60;
        end
%         minute = minute + timeForOnePercent*percentLeft/60;
        while (minute >= 60)
            hour = hour + 1;
            minute = minute - 60;
        end
        if(~displayText)
            clc
            str=(['Will finish at ', num2str(hour),':',num2str(minute),':',num2str(round(second))]);
            waitbar(j/numGames,h,str)
        end
        tic
    end
    [winner,gameInfo] = qwixx(playerList,displayText);
    numWins(winner) = numWins(winner) + 1;
end
      

if(~displayText)
    delete(h) % DELETE the waitbar; don't try to CLOSE it.
    figure
    pie(numWins)
    legend(playerList)
    title([num2str(numGames),' Games Played']);
    numWins
end
