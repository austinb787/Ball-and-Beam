function action1 = evaluatePolicy_slowController(observation1)
%#codegen

% Reinforcement Learning Toolbox
% Generated on: 09-May-2021 14:30:11

action1 = localEvaluate(observation1);
end
%% Local Functions
function action1 = localEvaluate(observation1)
persistent policy
if isempty(policy)
	policy = coder.loadDeepLearningNetwork('agentData.mat','policy');
end
observation1 = observation1(:)';
action1 = predict(policy, observation1);
end