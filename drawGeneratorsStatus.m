function [dailyGeneratorsStatus] = drawGeneratorsStatus(psi, features)
alpha = 1./(1+exp(-psi'*features));
dailyGeneratorsStatus = rand<alpha;
end