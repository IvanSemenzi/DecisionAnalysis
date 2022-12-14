function x_next = DP_IC_f(s,u,w)
%
% Returns next state (x_next), given current state (s) and
% current input (u)
%
x_next = max([s + u - w, 0]); % Actually, given the contraints on u, the
                              % max should not be needed

end
