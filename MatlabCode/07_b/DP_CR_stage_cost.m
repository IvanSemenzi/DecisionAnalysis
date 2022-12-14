function g = DP_CR_stage_cost(x,u,r,c)


% Returns stage cost (g), given current state (x),
% current input (u), replacement cost (r) and cost coefficient (c)
%

if u==1 % replace
  g = r;
else % do not replace
  g = c*x^2;
end

end
