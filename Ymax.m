%%Project for semester fall 2015
%Members
%Adel Ali Ansari U00038673
%Abduallah Alketbi u00037021
%Moutaz Elias U00036658
%Monte carlo simulation
%function that lets us get the values of interaction
%takes in angle and water level

function [x_inter,t_inter,y_inter]=Ymax(q_counter,Y_water,y_counter)

x_inter=tand(q_counter)*(y_counter-Y_water);
t_inter=(y_counter-Y_water)/cosd(q_counter);
y_inter=Y_water;
