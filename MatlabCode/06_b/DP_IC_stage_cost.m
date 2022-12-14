function g = DP_IC_stage_cost(s,u,cost)

%% Returns stage cost at time t (g), given current state (s),
% current input (u) and cost vector cost=[c1 c2]
%

if u==0 % no ordering, only storage cost
  g = cost(2)*s;
else % ordering cost + storage cost 
  g = cost(1) + cost(2)*s;
end

end
