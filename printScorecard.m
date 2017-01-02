function scorecard  = printScorecard(gameInfo,playerID)
        for i = 1 : length(gameInfo.colorOptions)

            color = cell2mat(gameInfo.colorOptions(i));

            numList = gameInfo.list.(color);
            scorecardText = '';
            scorecardText = [scorecardText, ' ['];
            numListLength = length(numList);
            for j = 1: numListLength
                extraText = '';
                if (gameInfo.player(playerID).(color)(j) == 1)
                    if (j == numListLength)
                        displayText = ' X';
                        extraText =' X';
                    else
                        displayText = ' X';
                    end
                else
                    if (j == numListLength)
                        displayText = [num2str(numList(j))];
                        extraText =' L';
                    else
                        displayText = [num2str(numList(j))];
                    end

                end 
                if (length(displayText) == 2)
                    displayText = [' ', displayText];
                end
                if (length(displayText) == 1)
                    displayText = ['  ', displayText];
                end
                scorecardText = [scorecardText,' ',displayText,extraText];
            end
            
            scorecardText =  [scorecardText, ']: ',color];
            str = sprintf('%s',scorecardText);
            disp(str)
        end
        misthrowText = ' [ ';
        for j = 1:4
            if(gameInfo.player(playerID).misthrow(j) == 1)
                misthrowText = [misthrowText, '  X '];
            else
                misthrowText = [misthrowText, ' -5 '];
            end
        end
        misthrowText = [misthrowText, ' ]: misthrows'];
        str = sprintf('%s (%d)',misthrowText, sum(gameInfo.player(playerID).misthrow));
        disp(str)
        
 
        scorecard = gameInfo.player(playerID);
end
