%this solves the klein nishina for the solid angle
%getting the first random number

function [compton,q_counter]=Klein(source,q_counter)

source=source;
%source=662;
%the electron radius

E_radius= (2.818E-13)^2;% i already difined it as r^2 since i dont use r alone

plank=4.135667662E-15; %in electron volts

E_mass=511;%electron mass in kev

R=1;
x=0;
rejection=0;




while (R>rejection)
    
%the random number representing the solid angle
q_klein=acosd(1-(2*rand));


%random number representing the cross section
R=(E_radius)*rand;



%geting the new hv as a function of the old one
%hv'/hv
compton=source/(1+((source/E_mass)*(1-cosd(q_klein))));

%rejection is for the case of probability for the scattering
rejection= (E_radius/2)*((compton/source)^2)*((source/compton)+(compton/source)-(((sind(q_klein))^2)));

end


%chosing the sign of the angle

sign=rand;
if(sign<0.5)
q_counter=q_counter+q_klein;
else if (sign>=0.5)
        q_counter=q_counter-q_klein;
    end
end









