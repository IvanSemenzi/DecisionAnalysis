function [x_next] = DP_appliance_f(x,u)

% Returns next state (x_next), given current state (x) and
% current input (u)
%
% input u can be:
%       u=0 wait
%       u=1 run next washing cycle

x_next = x + u;
