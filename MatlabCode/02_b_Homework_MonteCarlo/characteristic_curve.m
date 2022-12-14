function [eh]=characteristic_curve(vh)

% cut-in, v-rated, cut-out wind speed [m/s]
Vi=3;
Vr=15;
Vo=25;

% max energy [kWh]
E=2000;

% energy (eh) for given wind speed (vh)
if vh<Vi
    eh=0;
elseif vh<Vr
    eh=E/(Vr-Vi)^3*(vh-Vi)^3;
elseif vh<Vo
    eh=E;
else
    eh=0;
end



