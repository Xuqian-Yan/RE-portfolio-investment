function record_more = intensify(record,budget, production,price,capital,WITH_storage,whether_fit,fit_wind,fit_solar)
%% NOTES
%   INPUT:
%   WITH_storage: boolean, 'True': storage is included

%% Setting
step = 0.02;
trans = 50;             % number of transitions between two extreme weight vectors

%% original boundary -> boost each point -> record_more_1

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
    knew = [k1;k2];             % simulation between points in knew
end

if WITH_storage
    n = 9;
else
    n = 8;
end
    
record_more_1 = zeros(length(knew)*fix(1/step)*(n-1),12);

for i = 1:length(knew)-1
    ind_1 = knew(i);
    w = record (ind_1,2:10);
    RaR_reference = record (ind_1,12); 
    revenue_reference = record (ind_1,11);
    
    [w_max, ind] = max (w);
    
    for ii = 1:fix(w_max/step)
    w(ind) = w(ind)-step;            % each loop: dominant (highest profit) asset decreases by 2%
    
    revenue = zeros(n,1);
    risk = zeros(n,1);
    
    for j = 1:n                     % the 2% used in other assets
        if j ~= ind
            w(j) = w(j) + step;
            [revenue(j),risk(j)]= RaR (w, budget, production,price,capital,whether_fit,fit_wind,fit_solar);
            record_more_1((i-1)*fix(1/step)*(ii-1)*(n-1)+j,:) = [j,w,revenue(j,1),risk(j,1)];
            w(j) = w(j) - step;
        else
            revenue(j) = NaN;
            risk(j) = NaN;
            continue
        end
    end
    
    
    [RaR_new,ind_new] = max(risk);
    if RaR_new > RaR_reference      % until RaR doesn't increase
        w(ind_new) = w(ind_new) + step;
        RaR_reference = RaR_new;
    else
        [revenue_new,ind_new] = max(revenue);
        
        if revenue_new > revenue_reference      % until RaR doesn't increase
        w(ind_new) = w(ind_new) + step;
        revenue_reference = revenue_new;
        else
            break
        end
    end
    
    end
    
end

record_more_1 = record_more_1(any(record_more_1,2),:);    % delete unused rows

%% new boundary -> connect points -> record_more_2
record_all = [record;record_more_1];

x=record_all(:,12);
y= record_all(:,11);

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
    knew = [k1;k2];             % simulation between points in knew
end

record_more_2 = zeros(trans*(length(knew)-1),12);
for i = 1:length(knew)-1
   w_1 = record_all(knew(i),2:10);
   w_2 = record_all(knew(i+1),2:10);
   w = zeros(trans, length(w_1));

for j = 1:length(w_1)
   w(:,j) = linspace(w_1(j),w_2(j),trans); 
end

for j = 1:trans
    [revenue,risk]= RaR (w(j,:), budget, production,price,capital,whether_fit,fit_wind,fit_solar);
    record_more_2(((i-1)*trans+j),:) = [j,w(j,:),revenue,risk];
end
end
record_more = [record_more_1; record_more_2];

end