%%Main Script Assignment 2 
test = Dobot_Launch;
test.PlotAndColourRobot()
q = zeros(1,4);         
test.Dobot.plotopt = {'nojoints', 'noname', 'noshadow', 'nowrist'};
% test.Dobot.plot(q);
test.Dobot.teach();

