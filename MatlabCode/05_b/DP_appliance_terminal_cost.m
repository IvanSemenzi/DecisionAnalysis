function gT = DP_appliance_terminal_cost(xT,N_state)
%
% Returns terminal cost at time T, given the terminal state xT
%
% To complete the whole program by time T, xT must be N_state
%

if xT==N_state
    
  % At t=T state must be N_state (program complete)
  gT = 0; 

else
    
  gT = inf;

end
