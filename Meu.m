%%%%%%%%%%%%%
%This funciton extracts and interpolates the meu for air and water from the
%data files present in the folder. 
%It takes an input of the energy and densities and gives back the
%attenuation coeffecients
%%%%%%%%%%%%%%%%%%%%
function [meu]=Meu(compton,density_air,density_water)

%as we inported the source from main in KeV we have to conver it to MeV
source=compton/1000;%since the table is in MeV not KeV


% opening the data files
cross_section_water = dlmread('h2o.txt',' ',0,7);
cross_section_air = dlmread('air.txt',' ',0,7);


%assigning meu as a 2 by 5 matrix filled with 0 to start with
meu=zeros(2,5);


%Extracting the data first from the files from air
for (i=1:length(cross_section_air))
 %the energy is the first colloum
 meu_air(i,1)=cross_section_air(i,1);%energy
 
 %addition of the second and third colloum
 meu_air(i,2)=(cross_section_air(i,2)+cross_section_air(i,3))*density_air;%compton
 
 %the absorbtion cross section is the forth colloum
 meu_air(i,3)=cross_section_air(i,4)*density_air; %absorbtion
 
 %addition of pair production in atom (fifth) and nucleus (sixth)
 meu_air(i,4)=(cross_section_air(i,5)+cross_section_air(i,6))*density_air;%pair production
 
 %the total scattering 
 meu_air(i,5)=cross_section_air(i,7)*density_air;%total
end

%Extracting the data first from the files
for (i=1:length(cross_section_water))
    
 %the energy is the first colloum
 meu_water(i,1)=cross_section_water(i,1);%energy
 
 %addition of the second and third colloum
 meu_water(i,2)=(cross_section_water(i,2)+cross_section_water(i,3))*density_water;%compton
 
 %the absorbtion cross section is the forth colloum
 meu_water(i,3)=cross_section_water(i,4)*density_water;%absorbtion
 
 %addition of pair production in atom (fifth) and nucleus (sixth)
 meu_water(i,4)=(cross_section_water(i,5)+cross_section_water(i,6))*density_water;%pair
 
 %the total scattering 
 meu_water(i,5)=cross_section_water(i,7)*density_water;%total
 
end






j=1;
%taking the gradient between the two points y2-y1/x2-x1 then
        %multiplying by source-x1 and adding it to Y1
        %this is done for every colloum
meu(j,1)=source;%energy
        %interpolation
meu(j,2)=meu_air(1,2);%compton
meu(j,3)=meu_air(1,3);%absorbtion
meu(j,4)=meu_air(1,4);%pair
meu(j,5)=meu_air(1,5);%total        
        
        
for (i=1:length(cross_section_air))
    if(source>=meu_air(i,1) & source<meu_air(i+1,1))
        
        meu(j,1)=source;%energy
        %interpolation
        meu(j,2)=meu_air(i,2)+(((source-meu_air(i,1))/(meu_air(i+1,1)-meu_air(i,1)))*(meu_air(i+1,2)-meu_air(i,2)));%compton
        meu(j,3)=meu_air(i,3)+(((source-meu_air(i,1))/(meu_air(i+1,1)-meu_air(i,1)))*(meu_air(i+1,3)-meu_air(i,3)));%absorbtion
        meu(j,4)=meu_air(i,4)+(((source-meu_air(i,1))/(meu_air(i+1,1)-meu_air(i,1)))*(meu_air(i+1,4)-meu_air(i,4)));%pair
        meu(j,5)=meu_air(i,5)+(((source-meu_air(i,1))/(meu_air(i+1,1)-meu_air(i,1)))*(meu_air(i+1,5)-meu_air(i,5)));%total
    end
end
%converted meu into a matrix
%water being 2
j=2;

meu(j,1)=source;%energy
meu(j,2)=meu_water(1,2);%compton
meu(j,3)=meu_water(1,3);%absorbtion
meu(j,4)=meu_water(1,4);%pair
meu(j,5)=meu_water(1,5);%total 



%taking the gradient between the two points y2-y1/x2-x1 then
%multiplying by source-x1 and adding it to Y1
%this is done for every colloum

for (i=1:length(cross_section_water))
    if(source>=meu_water(i,1) & source<meu_water(i+1,1))
        meu(j,1)=source;;%energy
        meu(j,2)=meu_water(i,2)+(((source-meu_water(i,1))/(meu_water(i+1,1)-meu_water(i,1)))*(meu_water(i+1,2)-meu_water(i,2)));%compton
        meu(j,3)=meu_water(i,3)+(((source-meu_water(i,1))/(meu_water(i+1,1)-meu_water(i,1)))*(meu_water(i+1,3)-meu_water(i,3)));%absorbtion
        meu(j,4)=meu_water(i,4)+(((source-meu_water(i,1))/(meu_water(i+1,1)-meu_water(i,1)))*(meu_water(i+1,4)-meu_water(i,4)));%pair
        meu(j,5)=meu_water(i,5)+(((source-meu_water(i,1))/(meu_water(i+1,1)-meu_water(i,1)))*(meu_water(i+1,5)-meu_water(i,5)));%total
    end
end

%if the energy is less than the first energy value it stays as the first
%defined previously and hence it implicitly sets an energy limit it never
%enter the energy interpolation loop 

