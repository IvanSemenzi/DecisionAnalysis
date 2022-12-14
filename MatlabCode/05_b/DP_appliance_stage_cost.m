function [g] = DP_appliance_stage_cost(x,u,t,price,power)
%
% Returns stage cost (g) at time t, given current state (x),
% current input (u), current time (t), energy price vector (price)
% power consuption profile (power)
%
% input u can be:
%       u=0 wait
%       u=1 run next washing cycle

  g=1/4*price(t)*power(x)*u;

 
% N.B. Each washing cycle lasts 1/4 hour, price(t) is in EUR/kWh
%      power(x) is in kW. So, 1/4*power(x) is the amount of 
%      energy required by x-th washing cycle (in kWh)
  
