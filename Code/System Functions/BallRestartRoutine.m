% function BallRestartRoutine(cs)
%BallRestartRoutine Roll Ball Back to Pins

% for k = 1:2
%     pause(0.1)
%     writePosition(cs.s,0.49);
% end
% for k = 1:2
%     pause(0.1)
%     writePosition(cs.s,0.47);
% end
% 
% for K = 1:3
%     for k = 1:4
%         pause(0.1)
%         writePosition(cs.s,0.48);
%     end
%     % Reduce Ball Speed
%     for k = 1:2
%         pause(0.1)
%         writePosition(cs.s,0.46);
%     end
% end
% 
% % Set Ball Against Pins
% for k = 1:10
%     pause(0.1)
%     writePosition(cs.s,0.47);
% end
% REALLY Set Ball Against Pins
for k = 1:15
    pause(0.1)
    writePosition(cs.s,0.5);
end
for k = 1:15
    pause(0.01)
    writePosition(cs.s,0.48);
end
for k = 1:15
    pause(0.01)
    writePosition(cs.s,0.48);
end
for k = 1:15
    pause(0.01)
    writePosition(cs.s,0.47);
end
for k = 1:15
    pause(0.01)
    writePosition(cs.s,0.46);
end
lightend(cs);
% end

