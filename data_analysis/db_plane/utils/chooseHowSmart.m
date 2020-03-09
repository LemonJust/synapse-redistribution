function [howSmart,smartText] = chooseHowSmart(smartID, stu)

switch smartID
    case "NS"
        howSmart = stu.NStim;
        smartText = 'NStim';
    case  "US"
        howSmart = stu.UStim;
        smartText = 'UStim';
    case  "CS"
        howSmart = stu.CStim;
        smartText = 'CStim';
    case  "LR"
        howSmart = stu.Learners;
        smartText = 'Learners';
    case  "NL"
        howSmart = stu.Nonlearners;
        smartText = 'Nonlearners';
end
end