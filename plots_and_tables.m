%% ------------------------Plots---------------------------------
clear;
load ('results.mat');
load ('data.mat');
%% global parameters
which = result_1week_pred_original;

range = [0,25,0,40];
xaxis = 'Revenue at Risk [Thousand EUR]';
yaxis = 'Average Monthly Renenue [Thousand EUR]';
set(0,'defaultAxesFontSize',15)
%% scatter (less)
figure
axis(range)
ylabel (yaxis)
xlabel (xaxis)
hold on
scatter (which.record_with_storage(:,12),which.record_with_storage(:,11),'mx')
scatter (which.record_without_storage(:,12),which.record_without_storage(:,11),'kx')

scatter (which.record_wind(:,12),which.record_wind(:,11),'bo')
scatter (which.record_solar(:,12),which.record_solar(:,11),'ro')

scatter (which.record_N(:,12),which.record_N(:,11),[],[0 0.5 0],'^')
scatter (which.record_E(:,12),which.record_E(:,11),[],[0 0.75 0.25],'^')
scatter (which.record_W(:,12),which.record_W(:,11),[],[0.5 0.7 0.2],'^')
scatter (which.record_S(:,12),which.record_S(:,11),[],[0.75 0.75 0],'^')

legend('all WITH storage','all WITHOUT storage','wind','solar',...
    'north','east','west','south','Location','southeast');
title('with rescaled price (CVx2)');
%% !!! frontier plots (5 plots)
figname = 'frontiers, current price, 90% production';
which = result_original_price_90_perc_production;
production = production_original * 0.9;
%range = [0,80,0,150];
range = [0,25,0,40];

figure1 = figure('Name',figname,'Color',[1 1 1]);
set(0,'defaultAxesFontSize',12)

% plot of single assets
single = axes('Position',[0.0621590909090909 0.701 0.4 0.25]);
title (single,'(a)')
hold on
axis(single,range)
mark={'ro','r+','r*','rs','bo','b+','b*','bs'};
for i = 1:8
    scatter (single, which.record_sce(i,end),which.record_sce(i,end-1),mark{i})
end
scatter (which.record_only_storage(1,end),which.record_only_storage(1,end-1),'ms');
set(single,'FontName','Times New Roman');

% plot of geological diversification
geo_div = axes('Position',[0.0621590909090909 0.3867 0.4 0.25]);
title (geo_div,'(b)')
hold on
axis(geo_div,range)
mark={'ro','r+','r*','rs','bo','b+','b*','bs'};
for i = 1:8
    scatter (geo_div, which.record_sce(i,end),which.record_sce(i,end-1),mark{i})
end
scatter (geo_div,which.record_only_storage(1,end),which.record_only_storage(1,end-1),'ms');
frontier(which.record_wind,'b','-.',true);
frontier(which.record_solar,'r','-.',true);
set(geo_div,'FontName','Times New Roman');

% plot of technological diversification
tech_div = axes('Position',[0.0621590909090909 0.0723495518204079 0.4 0.25]);
hold(tech_div,'on');

title (tech_div,'(c)')
axis(tech_div,range)

mark={'ro','r+','r*','rs','bo','b+','b*','bs'};
for i = 1:8
    scatter (tech_div, which.record_sce(i,end),which.record_sce(i,end-1),mark{i})
end
scatter (tech_div,which.record_only_storage(1,end),which.record_only_storage(1,end-1),'ms');
frontier(which.record_wind,'b','-.',true);
frontier(which.record_solar,'r','-.',true);

frontier(which.record_N,[0 0.5 0],'--',true);
frontier(which.record_E,[0 0.75 0.25],'--',true);
frontier(which.record_W,[0.5 0.7 0.2],'--',true);
frontier(which.record_S,[0.75 0.75 0],'--',true);

frontier(which.record_N_with,[0 0.5 0],'-',true);
frontier(which.record_E_with,[0 0.75 0.25],'-',true);
frontier(which.record_W_with,[0.5 0.7 0.2],'-',true);
frontier(which.record_S_with,[0.75 0.75 0],'-',true);
set(tech_div,'FontName','Times New Roman');


% plot of all diversification
all_div = axes('Position',[0.534886363636364 0.701 0.4 0.25]);
hold(all_div,'on');

axis(all_div,range)
title('(d)');

mark={'ro','r+','r*','rs','bo','b+','b*','bs'};
for i = 1:8
    scatter (all_div, which.record_sce(i,end),which.record_sce(i,end-1),mark{i})
end
scatter (all_div,which.record_only_storage(1,end),which.record_only_storage(1,end-1),'ms');
frontier(which.record_wind,'b','-.',true);
frontier(which.record_solar,'r','-.',true);

frontier(which.record_N,[0 0.5 0],'--',true);
frontier(which.record_E,[0 0.75 0.25],'--',true);
frontier(which.record_W,[0.5 0.7 0.2],'--',true);
frontier(which.record_S,[0.75 0.75 0],'--',true);

frontier(which.record_N_with,[0 0.5 0],'-',true);
frontier(which.record_E_with,[0 0.75 0.25],'-',true);
frontier(which.record_W_with,[0.5 0.7 0.2],'-',true);
frontier(which.record_S_with,[0.75 0.75 0],'-',true);

frontier(which.record_without_storage,'k','-.',true);
frontier(which.record_with_storage,'k','-',true);

legend(all_div,'PV north','PV east','PV west','PV south',...
    'Wind north','Wind east','Wind west','Wind south','Storage',...
    'Wind all locations','Solar all locations',...
    'PV & wind north','PV & wind east','PV & wind west','PV & wind south',...
    'VRE & storage north','VRE & storage east','VRE & storage west','VRE & storage south',...
    'VRE all locations', 'VRE & storage all locations',...
    'Location','southeast','Orientation','vertical')
set(all_div,'FontName','Times New Roman');

legend1 = legend(all_div,'show');
set(legend1,...
    'Position',[0.6025 0.201255265928185 0.205909090909091 0.411214953271028],...
    'FontSize',12,...
    'EdgeColor',[1 1 1]);

% Create textbox
annotation(figure1,'textbox',...
    [0.593727272727273 0.589822206335968 0.0580909090909092 0.0274150755066138],...
    'String',{'Legend'},...
    'FontWeight','bold',...
    'FontSize',12,...
    'FontName','Times New Roman',...
    'FitBoxToText','off',...
    'EdgeColor',[1 1 1]);

% Create textbox
annotation(figure1,'textbox',...
    [0.595545454545454 0.190036670770616 0.0580909090909092 0.0274150755066139],...
    'String','Axes',...
    'FontWeight','bold',...
    'FontSize',12,...
    'FontName','Times New Roman',...
    'FitBoxToText','off',...
    'EdgeColor',[1 1 1]);

% Create textbox
annotation(figure1,'textbox',...
    [0.597363636363636 0.143145743145743 0.244454545454545 0.0478024353435134],...
    'String',{'X - Monthly CVaR [1000 €]','Y - Monthly average revenue [1000 €]'},...
    'FontSize',12,...
    'FontName','Times New Roman',...
    'FitBoxToText','off',...
    'EdgeColor',[1 1 1]);

savefig(figname)
%% !!! Scatter plot
figname = 'scatter plots for current and future scenarios';
set(0,'defaultAxesFontSize',15)

figure1 = figure('Name',figname,'Color', [1 1 1]);
% scatter with current price
current = axes('Position',[0.06 0.6 0.6 0.35]);

which = result_90CVaR_original;
title(current,'(a)');
hold on

axis(current,[0,25,0,40]);

scatter (current,which.record_with_storage(:,12),which.record_with_storage(:,11),'mx')
scatter (current,which.record_without_storage(:,12),which.record_without_storage(:,11),'kx')

scatter (current,which.record_wind(:,12),which.record_wind(:,11),'bx')
scatter (current,which.record_solar(:,12),which.record_solar(:,11),'rx')

scatter (current,which.record_N(:,12),which.record_N(:,11),[],[0 0.5 0],'^')
scatter (current,which.record_E(:,12),which.record_E(:,11),[],[0 0.75 0.25],'^')
scatter (current,which.record_W(:,12),which.record_W(:,11),[],[0.5 0.7 0.2],'^')
scatter (current,which.record_S(:,12),which.record_S(:,11),[],[0.75 0.75 0],'^')

scatter (current,which.record_N_with(:,12),which.record_N_with(:,11),[],[0 0.5 0],'d')
scatter (current,which.record_E_with(:,12),which.record_E_with(:,11),[],[0 0.75 0.25],'d')
scatter (current,which.record_W_with(:,12),which.record_W_with(:,11),[],[0.5 0.7 0.2],'d')
scatter (current,which.record_S_with(:,12),which.record_S_with(:,11),[],[0.75 0.75 0],'d')

set(current,'FontName','Times New Roman');

% scatter with current price
future = axes('Position',[0.06 0.12 0.6 0.35]);
which = result_90CVaR_2cv;
title(future,'(b)');
hold on
axis(future,[0,15,0,25])

scatter (future,which.record_with_storage(:,12),which.record_with_storage(:,11),'mx')
scatter (future,which.record_without_storage(:,12),which.record_without_storage(:,11),'kx')

scatter (future,which.record_wind(:,12),which.record_wind(:,11),'bx')
scatter (future,which.record_solar(:,12),which.record_solar(:,11),'rx')

scatter (future,which.record_N(:,12),which.record_N(:,11),[],[0 0.5 0],'^')
scatter (future,which.record_E(:,12),which.record_E(:,11),[],[0 0.75 0.25],'^')
scatter (future,which.record_W(:,12),which.record_W(:,11),[],[0.5 0.7 0.2],'^')
scatter (future,which.record_S(:,12),which.record_S(:,11),[],[0.75 0.75 0],'^')

scatter (future,which.record_N_with(:,12),which.record_N_with(:,11),[],[0 0.5 0],'d')
scatter (future,which.record_E_with(:,12),which.record_E_with(:,11),[],[0 0.75 0.25],'d')
scatter (future,which.record_W_with(:,12),which.record_W_with(:,11),[],[0.5 0.7 0.2],'d')
scatter (future,which.record_S_with(:,12),which.record_S_with(:,11),[],[0.75 0.75 0],'d')


legend(future,'VRE & storage all locations','VRE all locations',...
    'Wind all locations','PV all locations',...
    'PV & wind north','PV & wind east','PV & wind west','PV & wind south',...
    'VRE & storage north','VRE & storage east','VRE & storage west','VRE & storage south',...
    'Location','eastoutside')
set(future,'FontName','Times New Roman');

% Create textbox for the legend
annotation(figure1,'textbox',...
    [0.68 0.72 0.0580909090909092 0.0274150755066138],...
    'String',{'Legend'},...
    'FontWeight','bold',...
    'FontSize',12,...
    'FontName','Times New Roman',...
    'FitBoxToText','off',...
    'EdgeColor',[1 1 1]);

legend1 = legend(future,'show');
set(legend1,...
    'Position',[0.73 0.35 0.205909090909091 0.411214953271028],...
    'FontSize',12,...
    'EdgeColor',[1 1 1]);

% Create textbox for axes
annotation(figure1,'textbox',...
    [0.68 0.35 0.0580909090909092 0.0274150755066139],...
    'String','Axes',...
    'FontWeight','bold',...
    'FontSize',12,...
    'FontName','Times New Roman',...
    'FitBoxToText','off',...
    'EdgeColor',[1 1 1]);

% Create textbox
annotation(figure1,'textbox',...
    [0.7 0.25 0.244454545454545 0.0478024353435134],...
    'String',{'X - Monthly CVaR [1000 €]','Y - Monthly average revenue [1000 €]'},...
    'FontSize',12,...
    'FontName','Times New Roman',...
    'FitBoxToText','off',...
    'EdgeColor',[1 1 1]);

savefig(figname);
%% frontier plots:varying costs (5 plots)
range = [0,30,0,45];
xaxis = 'Revenue at Risk [Thousand EUR]';
yaxis = 'Average Monthly Renenue [Thousand EUR]';
set(0,'defaultAxesFontSize',15)

for var_pv = 1:3
    for var_wind = 1:3
        for var_storage = 1:3
            which = result_diff_cost_original(var_pv,var_wind,var_storage);
            
            var = [0.9,1,1.1];
            ratio_PV = var(var_pv);
            ratio_wind = var(var_wind);
            ratio_storage = var(var_storage);
            
            str = sprintf('PV %.2f, wind %.2f, storage %.2f',ratio_PV,ratio_wind,ratio_storage);
            figure('Name', str)
            figname = sprintf('PV %.2f, wind %.2f, storage %.2f.fig',ratio_PV,ratio_wind,ratio_storage);

% plot of single assets
single = subplot(3,2,1);
title (single,'single assets')
hold on
axis(single,range)
ylabel (single,yaxis)
xlabel (single,xaxis)
mark={'ro','r+','r*','rs','bo','b+','b*','bs'};
for i = 1:8
    scatter (single, which.record_sce(i,end),which.record_sce(i,end-1),mark{i})
end
scatter (which.record_only_storage(1,end),which.record_only_storage(1,end-1),'ms');


% plot of geological diversification
geo_div = subplot(3,2,3);
title (geo_div,'geological diversification')
hold on
axis(geo_div,range)
ylabel (geo_div,yaxis)
xlabel (geo_div,xaxis)
mark={'ro','r+','r*','rs','bo','b+','b*','bs'};
for i = 1:8
    scatter (geo_div, which.record_sce(i,end),which.record_sce(i,end-1),mark{i})
end
scatter (geo_div,which.record_only_storage(1,end),which.record_only_storage(1,end-1),'ms');
frontier(which.record_wind,'b','-.',true);
frontier(which.record_solar,'r','-.',true);


% plot of technological diversification
tech_div = subplot(3,2,2);
title (tech_div,'technical diversification')
hold on
axis(tech_div,range)
ylabel (tech_div,yaxis)
xlabel (tech_div,xaxis)
mark={'ro','r+','r*','rs','bo','b+','b*','bs'};
for i = 1:8
    scatter (tech_div, which.record_sce(i,end),which.record_sce(i,end-1),mark{i})
end
scatter (tech_div,which.record_only_storage(1,end),which.record_only_storage(1,end-1),'ms');
frontier(which.record_wind,'b','-.',true);
frontier(which.record_solar,'r','-.',true);

frontier(which.record_N,[0 0.5 0],'--',true);
frontier(which.record_E,[0 0.75 0.25],'--',true);
frontier(which.record_W,[0.5 0.7 0.2],'--',true);
frontier(which.record_S,[0.75 0.75 0],'--',true);

frontier(which.record_N_with,[0 0.5 0],'-',true);
frontier(which.record_E_with,[0 0.75 0.25],'-',true);
frontier(which.record_W_with,[0.5 0.7 0.2],'-',true);
frontier(which.record_S_with,[0.75 0.75 0],'-',true);


% plot of all diversification
all_div = subplot(3,2,4);
title (all_div,'all diversification')
hold on
axis(all_div,range)
ylabel (all_div,yaxis)
xlabel (all_div,xaxis)
mark={'ro','r+','r*','rs','bo','b+','b*','bs'};
for i = 1:8
    scatter (all_div, which.record_sce(i,end),which.record_sce(i,end-1),mark{i})
end
scatter (all_div,which.record_only_storage(1,end),which.record_only_storage(1,end-1),'ms');
frontier(which.record_wind,'b','-.',true);
frontier(which.record_solar,'r','-.',true);

frontier(which.record_N,[0 0.5 0],'--',true);
frontier(which.record_E,[0 0.75 0.25],'--',true);
frontier(which.record_W,[0.5 0.7 0.2],'--',true);
frontier(which.record_S,[0.75 0.75 0],'--',true);

frontier(which.record_N_with,[0 0.5 0],'-',true);
frontier(which.record_E_with,[0 0.75 0.25],'-',true);
frontier(which.record_W_with,[0.5 0.7 0.2],'-',true);
frontier(which.record_S_with,[0.75 0.75 0],'-',true);

frontier(which.record_without_storage,'k','-.',true);
frontier(which.record_with_storage,'k','-',true);

legend(all_div,'Solar north','Solar east','Solar west','Solar south',...
    'Wind north','Wind east','Wind west','Wind south','Storage',...
    'Wind, geographically diversified','Solar, geographically diversified',...
    'Wind & PV, North','Wind & PV, East','Wind & PV, West','Wind & PV, South',...
    'Wind, PV & storage, North','Wind, PV & storage, East','Wind, PV & storage, West','Wind, PV & storage, South',...
    'All, without storage', 'All, with storage',...
    'Location','southeast','Orientation','vertical')

% scatter
simu = subplot(3,2,5);
title(simu,'scatters');
hold on
axis(simu,range)
ylabel (simu,yaxis)
xlabel (simu,xaxis)

scatter (simu,which.record_with_storage(:,12),which.record_with_storage(:,11),'mx')
scatter (simu,which.record_without_storage(:,12),which.record_without_storage(:,11),'kx')

scatter (simu,which.record_wind(:,12),which.record_wind(:,11),'bx')
scatter (simu,which.record_solar(:,12),which.record_solar(:,11),'rx')

scatter (simu,which.record_N(:,12),which.record_N(:,11),[],[0 0.5 0],'^')
scatter (simu,which.record_E(:,12),which.record_E(:,11),[],[0 0.75 0.25],'^')
scatter (simu,which.record_W(:,12),which.record_W(:,11),[],[0.5 0.7 0.2],'^')
scatter (simu,which.record_S(:,12),which.record_S(:,11),[],[0.75 0.75 0],'^')

scatter (simu,which.record_N_with(:,12),which.record_N_with(:,11),[],[0 0.5 0],'d')
scatter (simu,which.record_E_with(:,12),which.record_E_with(:,11),[],[0 0.75 0.25],'d')
scatter (simu,which.record_W_with(:,12),which.record_W_with(:,11),[],[0.5 0.7 0.2],'d')
scatter (simu,which.record_S_with(:,12),which.record_S_with(:,11),[],[0.75 0.75 0],'d')


legend(simu,'All, with storage','All, without storage',...
    'Wind, geographically diversified','Solar, geographically diversified',...
    'Wind & PV, North','Wind & PV, East','Wind & PV, West','Wind & PV, South',...
    'Wind, PV & storage, North','Wind, PV & storage, East','Wind, PV & storage, West','Wind, PV & storage, South',...
    'Location','southeast')


savefig(figname)
        end
    end
end
%% frontier plot
figure('Name','cv x2')
axis(range)
hold on
ylabel (yaxis)
xlabel (xaxis)

frontier(which.record_N,[0 0.5 0],'--',true);
frontier(which.record_E,[0 0.75 0.25],'--',true);
frontier(which.record_W,[0.5 0.7 0.2],'--',true);
frontier(which.record_S,[0.75 0.75 0],'--',true);

frontier(which.record_N_with,[0 0.5 0],'-',true);
frontier(which.record_E_with,[0 0.75 0.25],'-',true);
frontier(which.record_W_with,[0.5 0.7 0.2],'-',true);
frontier(which.record_S_with,[0.75 0.75 0],'-',true);

mark={'ro','r+','r*','rs','bo','b+','b*','bs'};
for i = 1:8
    scatter (which.record_sce(i,end),which.record_sce(i,end-1),mark{i})
end

scatter (which.record_only_storage(1,end),which.record_only_storage(1,end-1),'ms');

legend('Wind & PV, North','Wind & PV, East','Wind & PV, West','Wind & PV, South',...
    'Wind, PV & storage, North','Wind, PV & storage, East','Wind, PV & storage, West','Wind, PV & storage, South',...
    'Solar north','Solar east','Solar west','Solar south',...
    'Wind north','Wind east','Wind west','Wind south','Storage',...
   'Location','southeast');
title ('Efficient frontiers with cvx2 price');
%% frontier plots (With vs. Without)
figure
axis(range)
hold on
ylabel (yaxis)
xlabel (xaxis)

frontier(which.record_without_storage,'k','-',true);
frontier(which.record_with_storage,[0.5 0.5 0.5],'-.',true);

frontier(which.record_with_storage_10,[0 0.5 0],'-.',true);
frontier(which.record_with_storage_20,[0 0.75 0.25],'-.',true);
frontier(which.record_with_storage_50,[0.5 0.7 0.2],'-.',true);
frontier(which.record_with_storage_80,[0.75 0.75 0],'-.',true);

%line([0,0],[0,40],'Color','k','LineStyle','--')

title('Efficient Frontiers with Different Shares of Storage (CV x 2)')
legend('WITHOUT storage','WITH storage (>0%)',...
    'WITH storage (>10%)','WITH storage (>20%)',...
    'WITH storage (>50%)','WITH storage (>80%)',...
    'Location','northwest')
%% !!!With & without FIT
load ('results.mat');
load ('data.mat');

figname = 'with & without FIT';
which1 = result_90CVaR_original;
which2 = result_90CVaR_FIT_original;
range = [0,80,0,150];
%range = [0,25,0,40];

figure1 = figure('Name',figname,'Color',[1 1 1]);
set(0,'defaultAxesFontSize',12)

% plot of single assets
single = axes();
hold on
axis(single,range)
mark={'ro','r+','r*','rs','bo','b+','b*','bs'};
for i = 1:8
    scatter (single, which1.record_sce(i,end),which1.record_sce(i,end-1),mark{i});
end
color = [[0.4,0,0];[0.4,0,0];[0.4,0,0];[0.4,0,0];[0,0,0.4];[0,0,0.4];[0,0,0.4];[0,0,0.4]];
mark = {'o','+','*','s','o','+','*','s'};
for i = 1:8
    scatter (single, which2.record_sce(i,end),which2.record_sce(i,end-1),...
        [],color(i,:),mark{i});
end
xlabel('Monthly CVaR [1000 €]');
ylabel('Monthly Revenue [1000 €]');

set(single,'FontName','Times New Roman');

legend(single,'PV north','PV east','PV west','PV south',...
    'Wind north','Wind east','Wind west','Wind south',...
    'PV north, with FIT','PV east, with FIT','PV west, with FIT','PV south, with FIT',...
    'Wind north, with FIT','Wind east, with FIT','Wind west, with FIT','Wind south, with FIT',...
    'Location', 'eastoutside');
legend1 = legend(single,'show');
set(legend1, 'FontSize',12, 'EdgeColor',[1 1 1]);
set(gca,'FontName','Times New Roman');
savefig(figname);
%% Storage operation
name = 'storage activity (current price)';
price = price_original;
whether_fit = false;

w = zeros(1,9);
w(9) = 1;
record = RaR_detail (w, budget, production,price,capital,whether_fit,fit_wind,fit_solar);
storage_operation_plot(record,name);
%% !!!Capacity factor vs. risk and revenue
which = result_90CVaR_original;
price = which.price;
whether_fit = false;
figname = 'E, cf vs revenue and risks';

figure_cf_rev = figure('Name',figname,'Color', [1 1 1]);

t_with = some_points (50,which.record_with_storage,budget, production,price,capital,whether_fit,fit_wind,fit_solar);
weights = cell2mat(t_with{2:end,3});
revenues = cell2mat(t_with{2:end,1});
risks = cell2mat(t_with{2:end,2});
cfs = zeros(length(weights),1);
for i = 1:length(weights)
    cfs(i) = weights(i,1:8)*transpose(cf); % in [%]
end
plot(cfs,revenues);
hold on
plot(cfs,risks);
xlabel("Capacity factors [%]");
ylabel("[1000 €]");
legend("Revenue","CVaR", 'Location','eastoutside');
annotation('textbox','String',{'Note: this is calculated from all portfolios on the efficient frontier of "VRE & storage all locations" (with current price)'},'FitBoxToText','on');

set(legend,'EdgeColor',[1 1 1]);
set(gca,'FontName','Times New Roman');
savefig(figname);

[R_rev,P_rev] = corrcoef(cfs,revenues);
[R_risk,P_risk] = corrcoef(cfs,risks);

%% ----------------calculations for the paper------------------------
%% ave. wind CVaR vs solar CVaR
which = result_1week_pred_original;
cvar_wind = mean(which.record_sce(5:8,12));
cvar_solar = mean(which.record_sce(1:4,12));
x = cvar_wind/cvar_solar*100;    % [%]
%% future vs current
which = result_1week_pred_original;
ave_revenue_current = mean(which.record_sce(1:8,11));
which = result_1week_pred_2cv;
ave_revenue_future = mean(which.record_sce(1:8,11));
drop_percentage =(ave_revenue_current-ave_revenue_future)/ave_revenue_current*100;
%% !!!Pearson (normal) correlation matrix
%cov_mat = cov(production);
figname = "correlation, future price";
price = price_rescale_2cv;
whether_fit = false;

figure('Name',figname,'Color', [1 1 1]);
monthly_revenue = zeros(36,9);
for i = 1:9
    w = zeros(1,9);
    w(i) = i;
    record = RaR_detail (w, budget, production,price,capital,whether_fit,fit_wind,fit_solar);
    monthly_revenue(:,i) = record.monthlyrevenue;
end
[R,P] = corrcoef(monthly_revenue);
%revenue_mat_future = cov(monthly_revenue);
R = round(R,2);
names = {'Solar north','Solar east','Solar west','Solar south','Wind north','Wind east','Wind west','Wind south','Storage'};
h = heatmap(names,names,R);
set(legend,'EdgeColor',[1 1 1]);
set(gca,'FontName','Times New Roman');
savefig(figname);
%% !!! Seasonality
figname = "Seasonality, current price";
price = price_original;
production = production_original;
whether_fit = false;

figure('Name',figname,'Color', [1 1 1]);
monthly_revenue = zeros(36,8);
for i = 1:8
    w = zeros(1,9);
    w(i) = i;
    record = RaR_detail (w, budget, production,price,capital,whether_fit,fit_wind,fit_solar);
    monthly_revenue(:,i) = record.monthlyrevenue;
end

monthly_solar = mean(monthly_revenue(:,1:4),2);
monthly_wind = mean(monthly_revenue(:,5:8),2);

monthly_solar_ave = zeros(12,1);
monthly_wind_ave = zeros(12,1);

for i = 1:12
    monthly_solar_ave(i) = mean(monthly_solar([i,i+12,i+24]));
    monthly_wind_ave(i) = mean(monthly_wind([i,i+12,i+24]));
end

monthly_solar_ave_perc = monthly_solar_ave/max(monthly_solar_ave)*100;
monthly_wind_ave_perc = monthly_wind_ave/max(monthly_wind_ave)*100;

names = {'Solar north','Solar east','Solar west','Solar south','Wind north','Wind east','Wind west','Wind south','Storage'};
plot(monthly_solar_ave_perc, 'red');
hold on
plot(monthly_wind_ave_perc, 'blue');
xlim([0.5,12.5]);
xticks(1:1:12);
xticklabels({'Jan.','Feb.','Mar.','Apr.','May','Jun.','Jul.','Aug.','Sept.','Oct.','Nov.','Dec.'})
ylabel("Monthly revenue variation [%]");
legend('PV','Wind','Location','eastoutside');
set(legend,'EdgeColor',[1 1 1]);
set(gca,'FontName','Times New Roman');
savefig(figname);
%% ------------------------Tables---------------------------------
which = result_90CVaR_2cv;
price = which.price;
%% !!!summary
wind_all_loc = some_points (3,which.record_wind,budget, production,price,capital);
PV_all_loc = some_points (3,which.record_solar,budget, production,price,capital);

VRE_west = some_points (3,which.record_W,budget, production,price,capital);
VRE_south = some_points (3,which.record_S,budget, production,price,capital);

VRE_sto_west = some_points (3,which.record_W_with,budget, production,price,capital);
VRE_sto_south = some_points (3,which.record_S_with,budget, production,price,capital);

VRE_all_loc = some_points (3,which.record_with_storage,budget, production,price,capital);
VRE_sto_all_loc = some_points (3,which.record_without_storage,budget, production,price,capital);

fprintf('Max return: Revenue\n')
fprintf('%f\n', which.record_sce(5,11)) % wind north
fprintf('%f\n', which.record_sce(4,11)) % PV south
fprintf('%f\n', which.record_only_storage(1,11)) % storage
fprintf('%f\n', cell2mat(table2array(wind_all_loc('left','Revenue'))))
fprintf('%f\n', cell2mat(table2array(PV_all_loc('left','Revenue'))))
fprintf('%f\n', cell2mat(table2array(VRE_west('left','Revenue'))))
fprintf('%f\n', cell2mat(table2array(VRE_south('left','Revenue'))))
fprintf('%f\n', cell2mat(table2array(VRE_sto_west('left','Revenue'))))
fprintf('%f\n', cell2mat(table2array(VRE_sto_south('left','Revenue'))))
fprintf('%f\n', cell2mat(table2array(VRE_all_loc('left','Revenue'))))
fprintf('%f\n', cell2mat(table2array(VRE_sto_all_loc('left','Revenue'))))
fprintf('Max return: CVaR\n')
fprintf('%f\n', which.record_sce(5,12)) % wind north
fprintf('%f\n', which.record_sce(4,12)) % PV south
fprintf('%f\n', which.record_only_storage(1,12)) % storage
fprintf('%f\n', cell2mat(table2array(wind_all_loc('left','RaR'))))
fprintf('%f\n', cell2mat(table2array(PV_all_loc('left','RaR'))))
fprintf('%f\n', cell2mat(table2array(VRE_west('left','RaR'))))
fprintf('%f\n', cell2mat(table2array(VRE_south('left','RaR'))))
fprintf('%f\n', cell2mat(table2array(VRE_sto_west('left','RaR'))))
fprintf('%f\n', cell2mat(table2array(VRE_sto_south('left','RaR'))))
fprintf('%f\n', cell2mat(table2array(VRE_all_loc('left','RaR'))))
fprintf('%f\n', cell2mat(table2array(VRE_sto_all_loc('left','RaR'))))

fprintf('Mid return: Revenue\n')
fprintf('%f\n', cell2mat(table2array(wind_all_loc('Row3','Revenue'))))
fprintf('%f\n', cell2mat(table2array(PV_all_loc('Row3','Revenue'))))
fprintf('%f\n', cell2mat(table2array(VRE_west('Row3','Revenue'))))
fprintf('%f\n', cell2mat(table2array(VRE_south('Row3','Revenue'))))
fprintf('%f\n', cell2mat(table2array(VRE_sto_west('Row3','Revenue'))))
fprintf('%f\n', cell2mat(table2array(VRE_sto_south('Row3','Revenue'))))
fprintf('%f\n', cell2mat(table2array(VRE_all_loc('Row3','Revenue'))))
fprintf('%f\n', cell2mat(table2array(VRE_sto_all_loc('Row3','Revenue'))))
fprintf('Mid return: CVaR\n')
fprintf('%f\n', cell2mat(table2array(wind_all_loc('Row3','RaR'))))
fprintf('%f\n', cell2mat(table2array(PV_all_loc('Row3','RaR'))))
fprintf('%f\n', cell2mat(table2array(VRE_west('Row3','RaR'))))
fprintf('%f\n', cell2mat(table2array(VRE_south('Row3','RaR'))))
fprintf('%f\n', cell2mat(table2array(VRE_sto_west('Row3','RaR'))))
fprintf('%f\n', cell2mat(table2array(VRE_sto_south('Row3','RaR'))))
fprintf('%f\n', cell2mat(table2array(VRE_all_loc('Row3','RaR'))))
fprintf('%f\n', cell2mat(table2array(VRE_sto_all_loc('Row3','RaR'))))

fprintf('Min return: Revenue\n')
fprintf('%f\n', cell2mat(table2array(wind_all_loc('right','Revenue'))))
fprintf('%f\n', cell2mat(table2array(PV_all_loc('right','Revenue'))))
fprintf('%f\n', cell2mat(table2array(VRE_west('right','Revenue'))))
fprintf('%f\n', cell2mat(table2array(VRE_south('right','Revenue'))))
fprintf('%f\n', cell2mat(table2array(VRE_sto_west('right','Revenue'))))
fprintf('%f\n', cell2mat(table2array(VRE_sto_south('right','Revenue'))))
fprintf('%f\n', cell2mat(table2array(VRE_all_loc('right','Revenue'))))
fprintf('%f\n', cell2mat(table2array(VRE_sto_all_loc('right','Revenue'))))
fprintf('Min return: CVaR\n')
fprintf('%f\n', cell2mat(table2array(wind_all_loc('right','RaR'))))
fprintf('%f\n', cell2mat(table2array(PV_all_loc('right','RaR'))))
fprintf('%f\n', cell2mat(table2array(VRE_west('right','RaR'))))
fprintf('%f\n', cell2mat(table2array(VRE_south('right','RaR'))))
fprintf('%f\n', cell2mat(table2array(VRE_sto_west('right','RaR'))))
fprintf('%f\n', cell2mat(table2array(VRE_sto_south('right','RaR'))))
fprintf('%f\n', cell2mat(table2array(VRE_all_loc('right','RaR'))))
fprintf('%f\n', cell2mat(table2array(VRE_sto_all_loc('right','RaR'))))
%% Wind, geographically diversified
t_wind = some_points (3,which.record_wind,budget, production,price,capital);
writetable(t_wind,filename,'Sheet','Wind, geo diversified','WriteRowNames',true);
%% PV, geographically diversified
t_solar = some_points (3,which.record_solar,budget, production,price,capital);
writetable(t_solar,filename,'Sheet','PV, geographically diversified','WriteRowNames',true);
%% West, (wind & PV) techonogically diversified
t_west = some_points (3,which.record_W,budget, production,price,capital);
writetable(t_west,filename,'Sheet','West, tech diversified','WriteRowNames',true);
%% West, (wind & PV & storage) techonogically diversified
t_west_with = some_points (3,which.record_W_with,budget, production,price,capital);
writetable(t_west_with,filename,'Sheet','West, tech (incl store) div','WriteRowNames',true);
%% Wind & PV, geo diversified
t_without = some_points (3,which.record_without_storage,budget, production,price,capital);
writetable(t_without,filename,'Sheet','Wind&PV, geo diversified','WriteRowNames',true);
%% wind & PV & storage, geo diversified
t_with = some_points (3,which.record_with_storage,budget, production,price,capital);
writetable(t_with,filename,'Sheet','Wind&PV&sto, geo diversified','WriteRowNames',true);
%% !!!------------------------Composition graph---------------------------------
which = result_original_price_90_perc_production;
figname = 'composition, current price, 90% production';
production = production_original * 0.9;

figure_composition = figure('Name',figname,'Color', [1 1 1]);

price = which.price;
t_with = some_points (50,which.record_with_storage,budget, production,price,capital,whether_fit,fit_wind,fit_solar);
weights = cell2mat(t_with{2:end,3});
revenue = cell2mat(t_with{2:end,1});
risk = cell2mat(t_with{2:end,2});

[~,ind_unique] = unique(risk,'stable');
revenue_unique = revenue(ind_unique);
RaR_unique = risk(ind_unique);
weights_unique = weights(ind_unique,:);

b = area(RaR_unique, weights_unique);

hold on
set(b(1),'FaceColor',[0.75 0.2 0]);      % solar_N
set(b(2),'FaceColor',[0.75 0.75 0]);         
set(b(3),'FaceColor',[0.75 0.5 0]);
set(b(4),'FaceColor',[1 0 0]);
set(b(5),'FaceColor',[0 0 1]);    % wind_N
set(b(6),'FaceColor',[0 0.5 0.75]);
set(b(7),'FaceColor',[0 0.75 0.75]);
set(b(8),'FaceColor',[0 0.2 0.5]);
set(b(9),'FaceColor',[0 0 0]);      % storage

xlim([0 max(risk)*1.05])
ylim([0 100])
xlabel('CVaR [1000 €]')
ylabel('Investment shares [%]')

legend('Solar north','Solar east','Solar west','Solar south',...
    'Wind north','Wind east','Wind west','Wind south','Storage',...
    'Location','eastoutside');
set(legend,'EdgeColor',[1 1 1]);
set(gca,'FontName','Times New Roman');

savefig(figname)
%% -------------------Sensitivit analysis----------------------------
t_composition = table;
t_return = table;
t_risk = table;
for var_pv = 1:3
    for var_wind = 1:3
        for var_storage = 1:3
            which = result_diff_cost_original(var_pv,var_wind,var_storage);
            
            var = [0.9,1,1.1];
            ratio_PV = var(var_pv);
            ratio_wind = var(var_wind);
            ratio_storage = var(var_storage);
            
            t_temp = some_points (3,which.record_with_storage,budget, production,price,which.capital_cost,whether_fit,fit_wind,fit_solar);
            t_temp.Properties.RowNames = ...
                 {sprintf('%.2f %.2f %.2f units',ratio_PV,ratio_wind,ratio_storage),...
                 sprintf('%.2f %.2f %.2f left',ratio_PV,ratio_wind,ratio_storage),...
                 sprintf('%.2f %.2f %.2f mid',ratio_PV,ratio_wind,ratio_storage),...
                 sprintf('%.2f %.2f %.2f right',ratio_PV,ratio_wind,ratio_storage)};
            t_composition = [t_composition;t_temp(2:4,3)];
            t_return = [t_return;t_temp(2:4,1)];
            t_risk = [t_risk;t_temp(2:4,2)];
        end
    end
end
disp('done calculation');
t_composition_cell = table2cell(t_composition);
composition_cell = transpose(reshape(t_composition_cell,3,[]));
t_return_cell = table2cell(t_return);
return_cell = transpose(reshape(t_return_cell,3,[]));
t_risk_cell = table2cell(t_risk);
risk_cell = transpose(reshape(t_risk_cell,3,[]));
%% !!! boxplot: composition
figure('Name','sensitivity, composition','Color', [1 1 1]);

max_return = subplot(3,1,1);
data_temp = cell2mat(composition_cell(:,1));
boxplot(data_temp,'Color','k');
hold on
xticklabels(max_return,{'PV north','PV east','PV west','PV south',...
    'Wind north','Wind east','Wind west','Wind south','Storage'});
ylabel(max_return,'Investment share [%]');
title(max_return,'Maximum return');
set(gca,'FontName','Times New Roman');

mid_return = subplot(3,1,2);
data_temp = cell2mat(composition_cell(:,2));
boxplot(data_temp,'Color','k');
hold on
xticklabels(mid_return,{'PV north','PV east','PV west','PV south',...
    'Wind north','Wind east','Wind west','Wind south','Storage'});
ylabel(mid_return,'Investment share [%]');
title(mid_return,'Medium risk & return')
set(gca,'FontName','Times New Roman');


min_return = subplot(3,1,3);
data_temp = cell2mat(composition_cell(:,3));
boxplot(data_temp,'Color','k');
hold on
xticklabels(min_return,{'PV north','PV east','PV west','PV south',...
    'Wind north','Wind east','Wind west','Wind south','Storage'});
ylabel(min_return,'Investment share [%]')
title(min_return,'Minimum risk')

set(gca,'FontName','Times New Roman');

savefig('sensitivity, composition.fig')
%% !!! boxplot: return & risk
figure('Name','sensitivity, return and risk','Color', [1 1 1]);

max_return = subplot(3,1,1);
data_temp = cat(2,cell2mat(return_cell(:,1)),cell2mat(risk_cell(:,1)));
boxplot(data_temp,'Color','k');
hold on
xticklabels(max_return,{'Revenue','CVaR'});
ylabel(max_return,'[1000 €]')
title(max_return,'Maximum return')
set(gca,'FontName','Times New Roman');

mid_return = subplot(3,1,2);
data_temp = cat(2,cell2mat(return_cell(:,2)),cell2mat(risk_cell(:,2)));
boxplot(data_temp,'Color','k');
hold on
xticklabels(mid_return,{'Revenue','CVaR'});
ylabel(mid_return,'[1000 €]')
title(mid_return,'Medium risk & return')
set(gca,'FontName','Times New Roman');


min_return = subplot(3,1,3);
data_temp = cat(2,cell2mat(return_cell(:,3)),cell2mat(risk_cell(:,3)));
boxplot(data_temp,'Color','k');
hold on
xticklabels(min_return,{'Revenue','CVaR'});
ylabel(min_return,'[1000 €]')
title(min_return,'Minimum risk')

set(gca,'FontName','Times New Roman');

savefig('sensitivity, return and risk.fig')