function [winnerID,gameInfo] = qwixx(playerList,displayText)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%INITIALIZE GAME
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
gameInfo.playerNames = playerList; 
gameInfo.numPlayers = size(gameInfo.playerNames,2);
gameInfo.turnOrder = 1:gameInfo.numPlayers;
gameInfo.closedColors = zeros(1,4);
gameInfo.gameNotOver = 1;
gameInfo.action = 1;
gameInfo.dice = rollDice();
gameInfo.colorOptions = {'red', 'yellow', 'green', 'blue'};
gameInfo.list.red = 2:12;
gameInfo.list.yellow = 2:12;
gameInfo.list.green = 12:-1:2;
gameInfo.list.blue = 12:-1:2;

scorecard.red = zeros(1,12);
scorecard.yellow = zeros(1,12);
scorecard.green = zeros(1,12);
scorecard.blue = zeros(1,12);
scorecard.misthrow = zeros(1,4);
scorecard.score = 0;
%i think I need to used the deal function to do this proper but I don't
%know how yet. shouldn't manually type 6 scorecards but do it
%programaticaly
gameInfo.player(1:gameInfo.numPlayers)  = deal(scorecard);

debug = 0;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%PLAY GAME
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
while(gameInfo.gameNotOver)
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %NEW ROLLER
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
    gameInfo.dice = rollDice();
    newCrosses = 0;

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %ACTIONS 1 THEN 2  
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    for kk = 1:2
        gameInfo.action = kk;
        %CHECK IF GAME IS OVER BEFORE EACH ACTION
        if(gameInfo.gameNotOver)
            for i = 1:gameInfo.numPlayers
                playerID = gameInfo.turnOrder(i);
                %ASK FOR PLAYER DECISION FROM EVERYONE ROUND 1 OR FROM
                %ROLLER i==1 ON ROUND 2
                if((gameInfo.action == 1) || ((gameInfo.action == 2) && (i == 1)))
                    [color, number] = playerDecision(gameInfo, playerID);
                    [gameInfo.player(playerID), crossMade] = checkDecision(playerID, gameInfo, color, number);
                    %IF ITS THE ROLLER CHECK TO SEE IF CROSSES WERE MADE
                    if (i == 1)
                        newCrosses = newCrosses + crossMade;
                    end
                    if(debug)
                        display(['//////// ', cell2mat(gameInfo.playerNames(playerID)), ' \\\\\\\\']);
                        display(['w1 = ',num2str(gameInfo.dice.white(1)), ', ',...
                            'w2 = ',num2str(gameInfo.dice.white(2))]);
                        if (i == 1 && gameInfo.action == 2)
                            display(['red = ',num2str(gameInfo.dice.red), ', ',...
                                'yellow = ',num2str(gameInfo.dice.yellow), ', ',...
                                'green = ',num2str(gameInfo.dice.green), ', ',...
                                'blue = ',num2str(gameInfo.dice.blue)]);
                        end
                        printScorecard(gameInfo,playerID);
                        pause
                    end
                end
            end
            %AFTER DECISIONS ARE MADE CHECK TO SEE IF ROWS ARE CLOSED
            gameInfo.closedColors = updateClosedColors(gameInfo);
        end
        
        if(gameInfo.action == 2)
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %CHECK FOR MISTHROW AFTER ROLLER FINISHES ACTION 2
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            if (newCrosses == 0 )
                MT = sum(gameInfo.player(gameInfo.turnOrder(1)).misthrow);
                %ADD A MISTHROW
                gameInfo.player(gameInfo.turnOrder(1)).misthrow(MT+1) = 1;
            end
            
        end
        
        gameInfo.player = scoreGame(gameInfo);
        %CHECK IF THE GAME IS OVER AT THE END OF EACH ACTION PHASE
        gameInfo.gameNotOver = checkGameOver(gameInfo);
        
        
    end
    
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %CHANGE STARTING PLAYER
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    gameInfo.turnOrder = [gameInfo.turnOrder(2:end),gameInfo.turnOrder(1)];
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%SCORE THE GAME
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
gameInfo.player = scoreGame(gameInfo);

[sortedScores, sortIndicies] = sort(cell2mat({gameInfo.player.score}),'descend');
winnerID = sortIndicies(1);

if(displayText)
    for i = 1:gameInfo.numPlayers
%         str = sprintf('\n Player[%d]: %s',sortIndicies(i), cell2mat(gameInfo.playerNames(sortIndicies(i))));
        str = sprintf('\n Player[%d]: %s (%d pts)',i, cell2mat(gameInfo.playerNames(i)),gameInfo.player(i).score);
        disp(str);
%       printScorecard(gameInfo,sortIndicies(i));
        printScorecard(gameInfo,i);
    end

    if(winnerID <= gameInfo.numPlayers)
        str = sprintf('\nPlayer[%d] (%s) wins with %d points.',winnerID, cell2mat(gameInfo.playerNames(winnerID)),gameInfo.player(winnerID).score  );
        disp(str);
    end
end

end

