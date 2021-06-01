function action1 = evaluatePolicy(observation1)
%#codegen

% Reinforcement Learning Toolbox
% Generated on: 29-May-2021 19:36:24

action1 = localEvaluate(observation1);
end
%% Local Functions
function action1 = localEvaluate(observation1)
persistent policy
if isempty(policy)
	policy = coder.loadDeepLearningNetwork('agentData.mat','policy');
end
action1 = predict(policy, observation1);
end