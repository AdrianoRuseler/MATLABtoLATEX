
% =========================================================================
%  data2tip - Return 2 points for text tip location
%
%   [xtip,ytip]=data2tip(xdata,ydata,quadrant);
%   
% =========================================================================
% 
% http://pgfplots.sourceforge.net/gallery.html
% =========================================================================

function [xtip,ytip]=data2tip(xdata,ydata,quadrant)


%         ydata=SCREENdata(:,c+1);
%         xdata=SCREENdata(:,1);
% quadrant=2; % First quadrant

y = downsample(ydata,length(ydata)/100);
x = downsample(xdata,length(xdata)/100);
%  figure
%  plot(x,y)

indexmin = find(min(y) == y);
xmin = x(indexmin);
ymin = y(indexmin);

indexmax = find(max(y) == y);
xmax = x(indexmax);
ymax = y(indexmax);

xall=vertcat(xmin, xmax);
yall=vertcat(ymin, ymax);
       
theta = angle(xall+1i*yall)*180/pi;

%% Select Quadrant
switch quadrant
    case 1
        indQ1=find((theta>0)&(theta<=90));
        if isempty(indQ1)
            randIDX=randi(numel(xall));
            xtip=xall(randIDX);
            ytip=yall(randIDX);
        elseif length(indQ1)>1
            randIDX=indQ1(randi(numel(indQ1)));    
            xtip=xall(randIDX);
            ytip=yall(randIDX);            
        else
            xtip=xall(indQ1);
            ytip=yall(indQ1);
        end        
    case 2
        indQ2=find((theta>90)&(theta<=180));
         if isempty(indQ2)
            randIDX=randi(numel(xall));
            xtip=xall(randIDX);
            ytip=yall(randIDX);
        elseif length(indQ2)>1
            randIDX=indQ2(randi(numel(indQ2)));    
            xtip=xall(randIDX);
            ytip=yall(randIDX);            
        else
            xtip=xall(indQ2);
            ytip=yall(indQ2);
        end
    case 3
        indQ3=find((theta>-180)&(theta<=-90));
         if isempty(indQ3)
            randIDX=randi(numel(xall));
            xtip=xall(randIDX);
            ytip=yall(randIDX);
        elseif length(indQ3)>1
            randIDX=indQ3(randi(numel(indQ3)));    
            xtip=xall(randIDX);
            ytip=yall(randIDX);            
        else
            xtip=xall(indQ3);
            ytip=yall(indQ3);
        end
    case 4
       indQ4=find((theta>-90)&(theta<=0));
        if isempty(indQ4)
            randIDX=randi(numel(xall));
            xtip=xall(randIDX);
            ytip=yall(randIDX);
        elseif length(indQ4)>1
            randIDX=randi(numel(indQ4));    
            xtip=xall(randIDX);
            ytip=yall(randIDX);            
        else
            xtip=xall(indQ4);
            ytip=yall(indQ4);
        end
    otherwise
         randIDX=randi(numel(xall));
            xtip=xall(randIDX);
            ytip=yall(randIDX);
end
% text(double(xtip),double(ytip),[' \leftarrow Q' num2str(quadrant)])

        

        
        