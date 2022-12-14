function [F,H,pF,pH,NF,NH,NK]=DP_purchase_setup()
%
%  F = row vector of possible flight ticket prices
% pF = corresponding probabilities
%
%  H = row vector of possible hotel room prices
% pH = corresponding probabilities
%

% Range of F
Fmin = 1010;
Fmax = 1200;
Fstep = 10;

% Range of H
Hmin = 610;
Hmax = 900;
Hstep = 10;

% Probability of k-th value of F is proportional to p1^k
p1 = 0.95;

% Probability of k-th value of H is proportional to p2^k
p2 = 1.05;

% Build output parameters
F = [Fmin:Fstep:Fmax];
H = [Hmin:Hstep:Hmax];

% Length
NF = length(F);
NH = length(H);
NK=2;

% Probability vector
pF = p1.^[1:NF];
pF = pF/sum(pF); % Normalization so that sum(pF)=1

% Probability vector
pH = p2.^[1:NH];
pH = pH/sum(pH); % Normalization so that sum(pH)=1
