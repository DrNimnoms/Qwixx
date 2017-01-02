function index = getIndexOfNumber(gameInfo,color,number)
list = gameInfo.list.(color);
index = find(list == number);
end