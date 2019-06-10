function frontier_funct = frontier(record,Color,LineStyle,whether_plot)
%% NOTES
% INPUTS
%   whether_plot: boolean
% OUTPUT
%   frontier_funct: the INVERSE of the frontier function

%% Calculation
x=record(:,12);
y= record(:,11);

% find all points on the boundary
k =convhull(x,y);           %counterclockwise order

% find index of the right point in the original record
[xmax,ind1]=max (x);

% find index of the right point among boundary points
[~, kind1] = min(abs(k-ind1));

% find index of the highest point in the original record
[ymax,ind2]=max (y);

% find index of the highest point among boundary points
[~, kind2] = min(abs(k-ind2));

% reorder boundary points from the highest point to the right point
% and neglect the other point
if kind1<kind2
    knew=k(kind1:kind2);
else
    k1 = k(kind1:end-1);
    k2 = k(1:kind2);
    knew = [k1;k2];
end

% connect reordered boundary points with smooth curve (with interpolation)
if ind1~=ind2
    xi = linspace(x(ind1),x(ind2),15); % descend
    frontier_funct = pchip(y(knew),x(knew)); % inverse of the frontier function
else
    frontier_funct = NaN;
end

if whether_plot
    if ind1==ind2
       scatter(xmax,ymax,[],Color,'x')
    else
    yi=pchip(x(knew),y(knew),xi);
    plot(xi,yi,'Color',Color,'LineStyle',LineStyle,'LineWidth',0.635)

    end
end

end
