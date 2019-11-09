%   Project for semester fall 2015
%   Members
%   Adel Ali Ansari U00038673
%   Abduallah Alketbi U00037021
%   Moutaz Elias U00036658
%   Monte carlo simulation


%% Section 1

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Defines the inputs and constants. %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc;
clear all;

%-------------- For input later to be made into a table
Y_tank=200;     %   water level
%---------------


run=1;
error=1;

X_tank=input('xtank')		% width of the tank
    

        
Y_water=input('yawater')	% inputs water level from user

% Setting the counter for heat map


heatmap=1;

%	cs-137 energy in kev
source=661.62;

%	density of air in cm3/g
Density_air=0.001225;

%	density o water
Density_water=1;



%	Defining functions
%	Ymax is a function that gets you the point of interaction
%	Inputs
%	X_tank= 30; % width of the tank
%	Defining variables
%	Givens are capital letters and variables are small letters



meu=zeros(2,5);



H_detector= 20;		%	Height of detector
X_source=0;			%	X cordinates of the source
Y_source=100;		%	Y cordinates of the source
X_detect=X_tank;	%	X cordinates of the detector
Y_detect=100;		%	Y cordinates of the detector
Y_detect_dimension=20;
Y_upper=Y_detect+(Y_detect_dimension/2);
Y_lower=Y_detect-(Y_detect_dimension/2);


collimator_limit_up=0;
collimator_limit_down=30;

Q_criticalcount=atand(((Y_detect_dimension/2)/X_tank));	%	Angle to direct detector hit
Q_criticalmax=atand((Y_source-Y_water)/X_tank);			%	Max angle before water interaction


%	Parcticles detected
nd=[0 0 0];


%	Looping starts from here
for(majorcounter=1:1000)
	
	
	%	Intermidiate positions
	x_countertemp=X_source;
	y_countertemp=Y_source;
	t_counter=0;
	
	% Particle positioncounters
	x_counter=X_source;
	y_counter=Y_source;


	klein=0;
	
	%	Have to be imported later.
	compton=source;
	[meu]=Meu(compton,Density_air,Density_water);
	
	%	Angle of emission calculations
	Q=acosd(1-2*rand);
	

	%	if it is inclosed by the collimater
	if(collimator_limit_up<Q & Q<collimator_limit_down)
		%	the X intersect with water
		x_inter=(y_counter-Y_water)/tand(Q);
		
		t_inter=(y_counter-Y_water)/sind(Q);
		
		y_inter=Y_water;
		
		%	case 1 interacted with air
		%	finding the distance traveled
		
		t_counter=(-1/meu(1,5))*log(rand);
		
		x_countertemp=x_countertemp+(t_counter*cosd(Q));
		y_countertemp=y_countertemp-(t_counter*sind(Q));
		
		%	Determining the place of interaction
		
		%	interaction in air
		%	setting the limit for X axis to make sure it is in the
		%	tank
		if(x_countertemp>0 & x_countertemp<=X_tank)
			
			%	checking if it is in air
			if (y_countertemp>=Y_water & y_countertemp<=Y_tank);
				x_counter=x_countertemp;%set xcounter to be equal to the intermediate position
				y_counter=y_countertemp;%set ycounter to be equal to the intermediate position
				
				%setting the heat map point
				x_counter_heat(heatmap)=x_counter;
				y_counter_heat(heatmap)=y_counter;
				heatmap=heatmap+1;
			end
			%	in the case that interaction is not within the tank we have to check
			%	if it is headed towards the detector count it.
			
		else if(Q>collimator_limit_up & Q<(collimator_limit_up+Q_criticalcount))
				
				%	counts that do directly to detector
				nd(1)=nd(1)+1;	
			end
			
		end
		
		%	Checking to see if the interactoin is in water
		%%%%%%%%%%%%
		
		%%	place the condition to check if the water level is above the detector
		%%%%%%%%%%%%
		
		if(Q>(30-Q_criticalmax))
			if(t_counter>t_inter)
				
				%	placing the starting point at the intersetion with water
				
				x_countertemp=x_inter;
				y_countertemp=y_inter;
				%	finding a new t  % finding a new x and y interaction  %positions
				%	finding a new x and y interaction  %positions
				
				%	The -ve sign for Y counter to account for downward
				%	direction
				t_counter=(-1/meu(2,5))*log(rand);
				x_countertemp=x_countertemp+(t_counter*cosd(Q));
				y_countertemp=y_countertemp-(t_counter*sind(Q));
				
				
				
				%	checking if it is in the
				%	water still
				
				if(x_countertemp>=0 & x_countertemp<=X_tank)
					if (y_countertemp>0 & y_countertemp<Y_water)
						
						x_counter=x_countertemp;
						y_counter=y_countertemp;
						
						
						%setting the heat map point
						x_counter_heat(heatmap)=x_counter;
						y_counter_heat(heatmap)=y_counter;
						heatmap=heatmap+1;
						
						
					end
				end
			end
		end
		
		
		
		
		
		
		%	after the first interaction location
		%	we enter the loop to find how it goes out
		
		q_counter=360-Q;
		
		
		%	add the energy condition
		%	i counter is for the material
		%	j counter is for the interaction type
		while (x_counter>0 & x_counter<=X_tank & y_counter>=0 & y_counter<=Y_tank)
			%	setting it to be the in air
			medium=1;

			%	checking if i am in water
			
			if(y_counter<=Y_water & y_counter>=0)
				%	setting it to be in water
				medium=2;
			end
			
			interaction=rand*meu(medium,5);
			
			
			%%%%%%%%%%
			
			%	j=2 Meu(medium,2) refers to probability of compton
			%	j=3 Meu(medium,3) refers to probability of aborbtion
			%	j=4 Meu(medium,4) refers to probability of pair production
			
			
			if(interaction<=meu(medium,2))
				j=2;
			   %	Then it's compton scattering
				
				
			else if (interaction<=(meu(medium,2)+meu(medium,3)))
					j=3;
				   %	It's photoelectric absorption
					
					
				else if (interaction>(meu(medium,2)+meu(medium,3)))
						j=4;
						
						%	It's pair production
						
					end
				end
			end
			
			
			
			%	breaking in case of absorbtion
			if (j==3)
				break;
			end
			
			
			
			%	breaking in case of pair production
			if (j==4)
				break;
			end
			
			
			%	In case of compton scattering
			if(j==2)
				
				%	getting new energy and angle
				%	Klein-Nishina
				[compton,q_counter]=Klein(compton,q_counter);
				
				%	getting meu
				%	The value of i will determine if the photon is in
				%	water or air
				
				%	the value of i being 1 or 2 tells me if i am in water or air
				[meu]=Meu(compton,Density_air,Density_water);
				
				
				
				%	new distance before interaction
				t_counter=(-1/meu(medium,5))*log(rand);
				
				%	getting new temp coordinates
				
				x_countertemp=x_counter+(t_counter*cosd(q_counter));
				y_countertemp=y_counter+(t_counter*sind(q_counter));
				

				
				%checking where was it at first
				if(medium==1)
					
					if(x_countertemp>=0 & x_countertemp<=X_tank & y_countertemp>=Y_water & y_countertemp<=Y_tank)
						
						
						x_counter=x_countertemp;
						y_counter=y_countertemp;
						
						
						%	setting the heat map point
						
						x_counter_heat(heatmap)=x_counter;
						y_counter_heat(heatmap)=y_counter;
						heatmap=heatmap+1;
						
						
					else
						%	if it was in air and is now out of the air i need to
						%	check if it left the tank or it went into the water
						
						%	checking the interception happens with water or leave;
						
						m_equation=(y_countertemp-y_counter)/(x_countertemp-x_counter);
						x_equation=((Y_water-y_counter)/m_equation)+x_counter;
						y_equation=((X_detect-x_counter)*m_equation)+y_counter;
						
						
						
						if(x_equation>0 & x_equation<=X_tank & y_countertemp<y_counter)
							
							%	checking the direction it is heading in downward
							%	directions

							
							%	placing the starting point at the intersetion with water or with
							%	air
							
							x_countertemp=x_equation;
							y_countertemp=Y_water;
							%interaction in water
							t_counter=(-1/meu(2,5))*log(rand);
							x_countertemp=x_countertemp+(t_counter*cosd(q_counter));
							y_countertemp=y_countertemp-(t_counter*sind(q_counter));
							
							if(x_countertemp>=0 & x_countertemp<=X_tank & y_countertemp>0 & y_countertemp<Y_water)
								
								
								x_counter=x_countertemp;
								y_counter=y_countertemp;
								
								%setting the heat map point
								x_counter_heat(heatmap)=x_counter;
								y_counter_heat(heatmap)=y_counter;
								heatmap=heatmap+1;
								
							end
							
							
							
							
							%	checking if it passes out of the detector
							%	using the line equation
						else if(y_equation>=Y_lower & y_equation<=Y_upper)
								if(x_countertemp>x_counter)
									
									nd(2)=nd(2)+1;
									
									
									break;
								end
							end
						end
					end
				end
				
%	If it's in water
				if(medium==2)
					if(x_countertemp>0 & x_countertemp<=X_tank & y_countertemp<=Y_water & y_countertemp>=0)
						
						x_counter=x_countertemp;
						y_counter=y_countertemp;
						
						%setting the heat map point
						x_counter_heat(heatmap)=x_counter;
						y_counter_heat(heatmap)=y_counter;
						heatmap=heatmap+1;
						
						
						
					else
						
						%	checking the interception happens with water or leave;
						
						m_equation=(y_countertemp-y_counter)/(x_countertemp-x_counter);
						x_equation=((Y_water-y_counter)/m_equation)+x_counter;
						y_equation=((X_detect-x_counter)*m_equation)+y_counter;
						
						if(x_equation>0 & x_equation<=X_tank)
							%	placing the starting point at the intersetion with water or with
							%	air
							
							x_countertemp=x_equation;
							y_countertemp=Y_water;
							%interaction in water
							t_counter=(-1/meu(1,5))*log(rand);
							x_countertemp=x_countertemp+(t_counter*cosd(q_counter));
							y_countertemp=y_countertemp+(t_counter*sind(q_counter));
							
							if(x_countertemp>0 & x_countertemp<X_tank)
								if(y_countertemp<Y_tank & y_countertemp>Y_water)
									
									x_counter=x_countertemp;
									y_counter=y_countertemp;
									
									
									%setting the heat map point
									x_counter_heat(heatmap)=x_counter;
									y_counter_heat(heatmap)=y_counter;
									heatmap=heatmap+1;
								end
								
							else if(y_equation>=Y_lower & y_equation<=Y_upper)
									if(x_countertemp>x_counter)
										
										nd(3)=nd(3)+1;
										
										
									end
								end
							end
							
							
							
							%	checking if it passes out of the detector
							%	using the line equation
						else if(y_equation>=Y_lower & y_equation<=Y_upper)
								if(x_countertemp>x_counter)
									
									
									nd(3)=nd(3)+1;
									
									
									
									break;
									
								end
							end
						end
					end
				end
			end
		end
	end
end


%%	This sections is for plotting I have to modify it to include all the sets
%	for all X and Y


Gamma_rays_detected(error,1)=nd(1);
Gamma_rays_detected(error,2)=nd(2);
Gamma_rays_detected(error,3)=nd(3);
Gamma_rays_detected(error,4)=sum(nd);
Gamma_rays_detected(error,5)=X_tank;
Gamma_rays_detected(error,6)=Y_water;

%	since it is an analog monte carlo we can use the feature for
%	standerd deviation



standerd_divasion(error)=((Gamma_rays_detected(error,4)/(majorcounter-1)))-((Gamma_rays_detected(error,4)^2)/(majorcounter^2));

error=error+1;

x_counter_heat(heatmap)=X_tank;
y_counter_heat(heatmap)=Y_tank;




for(ii=1:heatmap)
	heat(ii,2)=x_counter_heat(ii);
	heat(ii,1)=y_counter_heat(ii);
end





heat_plot=hist3(heat,[10 10]);



%	// Define integer grid of coordinates for the above data
[X,Y] = meshgrid(1:size(heat_plot,2), 1:size(heat_plot,1));

%	// Define a finer grid of points
[X2,Y2] = meshgrid(1:0.01:size(heat_plot,2), 1:0.01:size(heat_plot,1));

x_axis=0:X_tank;
y_axis=0:Y_tank;



%	// Interpolate the data and show the output
outData = interp2(X, Y, heat_plot, X2, Y2, 'linear');

%	// Cosmetic changes for the axes

%	plotting the figure for scattering
figure(run)
scatter(x_counter_heat,y_counter_heat),grid on
title(['Interactions in a tank of width  ', num2str(X_tank) ,' and waterlevel ' num2str(Y_water) ])
ylabel('Y axis (cm)')
xlabel('X axis (cm)')


%	plotting the figure for heat map
figure(run+1)
imagesc(x_axis,y_axis,outData),grid on
title(['Interactions in a tank of width  ', num2str(X_tank) ,' and water level ' num2str(Y_water) ])
set(gca,'YDir','normal')
ylabel('Y axis (cm)')
xlabel('X axis (cm)')
colorbar;
