function [value] = crossesToPoints(numCrosses)

switch numCrosses
    case 0
        value = 0;
    case 1
        value = 1;
    case 2
        value = 3;
    case 3
        value = 6;
    case 4
        value = 10;
    case 5
        value = 15;
    case 6
        value = 21;
    case 7
        value = 28;
    case 8
        value = 36;
    case 9
        value = 45;
    case 10
        value = 55;
    case 11
        value = 66;
    case 12
        value = 78;
    otherwise
        value = 0;
end
end

