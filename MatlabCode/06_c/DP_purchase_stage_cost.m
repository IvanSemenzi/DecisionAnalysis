function g = DP_purchase_stage_cost(x,u,F,H)
%
% Returns stage cost at time t (g), given current state x=(i,j,k),
% current input (u) and flight and hotel price vector F, H
%

if u==1 % wait
  g = 0;
else % buy
  g = F(x(1))+H(x(2));
end

end
