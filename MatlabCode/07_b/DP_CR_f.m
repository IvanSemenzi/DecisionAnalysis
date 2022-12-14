function x_next = DP_CR_f(x,u,p,N_state)


% Returns next state (x_next), given current state (x) and
% current input (u), and probability p
%


if u==1 % replace
  
  % When replace --> new component --> start from state 1
  x_next = 1;
  
else % do not replace
  
  % Transition probability matrix when no replacement occurs
  % Exploit the structure of P,  see "help private/circul"
  v=[1-p p zeros(1,N_state-2)];
  P=gallery('circul',v);
  
  % Transition probabilities when in state N_state
  P(N_state,:)=[zeros(1,N_state-1) 1]; 
  
  % Generate next state: select the row of P corresponding to
  % current state x
  x_next = randsample([1:N_state],1,true,P(x,:));
  
end
