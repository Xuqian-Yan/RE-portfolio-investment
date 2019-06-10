%% PV north rescale
funct = fitlm(solar_N_radiation_2015_2016,actual_monthly_prod_2015_2016); % slope = 1.2124, intercept = 1.1614e+05
solar_N_spec_calibrated = solar_N_spec * table2array(funct.Coefficients(2,1));
%% price rescale: adjust CV
original_mean = mean(price_original);
original_std = std(price_original);
cv = original_std/original_mean;
% -------------to change---------------
target_mean = original_mean * 0.65;
target_cv = cv * 2;
% -------------------------------------
target_sd = target_mean * target_cv;

price_rescale_test = (price_original - original_mean)/original_std * target_sd + target_mean;
%% price rescale: adjust SD
original_mean = mean(price_original);
original_sd = std(price_original);
cv = original_sd/original_mean;
% -------------to change---------------
target_mean = original_mean * 0.65;
target_sd = original_sd * 1.4;
% -------------------------------------
%target_cv = target_sd / target_mean; % not used

price_rescale_40pct_sd = (price_original - original_mean)/original_sd * target_sd + target_mean;
%% !!!sorted plot
figname = "price scenarios";

figure('Name',figname,'Color',[1 1 1]);
plot(sort(price_original,'descend'))
hold on
plot(sort(price_rescale_2cv,'descend'))
plot(sort(price_rescale_20pct_sd,'descend'))
plot(sort(price_rescale_40pct_sd,'descend'))

%plot(sort(price_rescale_3cv,'descend'),'r')
xlim([0,length(price)])
line([length(price),0],[0,0],'Color','k','LineStyle','--')
legend('Current price scenario','Future price scenario',...
    'Price SD increases by 20%','Price SD increases by 40%','zero','Location', 'eastoutside');
set(legend,'EdgeColor',[1 1 1]);
xlabel("Hours");
ylabel("Price [€/MWh]");
set(gca,'FontName','Times New Roman');

savefig(figname);
% 
% figure
% plot(price_rescale_2cv,'b')
% hold on
% plot(price_original,'k')
% title('Price [EUR/MWh]');
% legend('rescaled price','original price');
%% !!!mean-sd plot
%{
box_plot = figure;
axes1 = axes('Parent',box_plot);
grp = [zeros(1,365*24),zeros(1,365*24)+10,...
    ones(1,366*24),ones(1,366*24)+15,...
    ones(1,365*24)+1,ones(1,365*24)+10];
price_to_plot = [price_original(1:365*24);...
    price_rescale_2cv(1:365*24);...
    price_original((365*24+1):(365*24+366*24));...
    price_rescale_2cv((365*24+1):(365*24+366*24));...
    price_original((365*24+366*24+1):(365*24+366*24+365*24));...
    price_rescale_2cv((365*24+366*24+1):(365*24+366*24+365*24))];
c = ['k','b'];
sym_c = ['k+','b+'];

boxplot(price_to_plot,grp,'colors',c,'Symbol','k+','Whisker',2)
hold on
xlabel('Years')
ylabel('EUR/MWh')
title('current price and futre price')
set(axes1,'TickLabelInterpreter','none','XTick',[1.5 3.5 5.5],'XTickLabel',...
    {'2015','2016','2017'});

hold on;
for ii = 1:2
plot(NaN,1,'color', c(ii), 'LineWidth', 2);
end
legend({'current price','future price'});
savefig('price box plot.fig')
%}
figname = "comparison of mean and standard deviation";
mean_and_sd = figure('Name',figname,'Color',[1 1 1]);
axes1 = axes('Parent',mean_and_sd);

% mean_price = [mean(price_original(1:365*24)),mean(price_rescale_2cv(1:365*24)),mean(price_original((365*24+1):(365*24+366*24))),...
%     mean(price_rescale_2cv((365*24+1):(365*24+366*24))),mean(price_original((365*24+366*24+1):(365*24+366*24+365*24))),...
%     mean(price_rescale_2cv((365*24+366*24+1):(365*24+366*24+365*24)))];

mean_current = [mean(price_original(1:365*24)),mean(price_original((365*24+1):(365*24+366*24))),mean(price_original((365*24+366*24+1):(365*24+366*24+365*24)))];
mean_future = [mean(price_rescale_2cv(1:365*24)),mean(price_rescale_2cv((365*24+1):(365*24+366*24))),mean(price_rescale_2cv((365*24+366*24+1):(365*24+366*24+365*24)))];
mean_future_20 = [mean(price_rescale_20pct_sd(1:365*24)),mean(price_rescale_20pct_sd((365*24+1):(365*24+366*24))),mean(price_rescale_40pct_sd((365*24+366*24+1):(365*24+366*24+365*24)))];
mean_future_40 = [mean(price_rescale_40pct_sd(1:365*24)),mean(price_rescale_40pct_sd((365*24+1):(365*24+366*24))),mean(price_rescale_40pct_sd((365*24+366*24+1):(365*24+366*24+365*24)))];


% err = [std(price_original(1:365*24)),std(price_rescale_2cv(1:365*24)),std(price_original((365*24+1):(365*24+366*24))),...
%     std(price_rescale_2cv((365*24+1):(365*24+366*24))),std(price_original((365*24+366*24+1):(365*24+366*24+365*24))),...
%     std(price_rescale_2cv((365*24+366*24+1):(365*24+366*24+365*24)))];

sd_current = [std(price_original(1:365*24)),std(price_original((365*24+1):(365*24+366*24))),std(price_original((365*24+366*24+1):(365*24+366*24+365*24)))];
sd_future = [std(price_rescale_2cv(1:365*24)),std(price_rescale_2cv((365*24+1):(365*24+366*24))),std(price_rescale_2cv((365*24+366*24+1):(365*24+366*24+365*24)))];
sd_future_20 = [std(price_rescale_20pct_sd(1:365*24)),std(price_rescale_20pct_sd((365*24+1):(365*24+366*24))),std(price_rescale_40pct_sd((365*24+366*24+1):(365*24+366*24+365*24)))];
sd_future_40 = [std(price_rescale_40pct_sd(1:365*24)),std(price_rescale_40pct_sd((365*24+1):(365*24+366*24))),std(price_rescale_40pct_sd((365*24+366*24+1):(365*24+366*24+365*24)))];


errorbar([1.1:2:5.1],mean_current,sd_current,'o');
hold on
errorbar([1.3:2:5.3],mean_future,sd_future,'o');
errorbar([1.5:2:5.5],mean_future_20,sd_future_20,'o');
errorbar([1.7:2:5.7],mean_future_40,sd_future_40,'o');


ylabel('Price [€/MWh]')
title('current price and futre price')
xlim(axes1,[0 7])

set(axes1,'XTick',[1.4 3.4 5.4],'XTickLabel',{'2015','2016','2017'});

legend({'Current prices','Future prices', 'Price SD increases by 20%', 'Price SD increases by 40%'}, 'Location', 'eastoutside');
set(legend,'EdgeColor',[1 1 1]);
set(gca,'FontName','Times New Roman');
savefig(figname);
%% histogram
neg = (price_rescale_2cv < 0)'.*1; % logical->numerical
ii = strfind([0 neg 0],[0 1]);
jj = strfind([0 neg 0],[1 0]);
counts_2cv = jj-ii;

neg = (price_rescale_3cv < 0)'.*1; % logical->numerical
ii = strfind([0 neg 0],[0 1]);
jj = strfind([0 neg 0],[1 0]);
counts_3cv = jj-ii;

figure
histogram(counts_2cv,'FaceColor','b')
hold on
histogram(counts_3cv,'FaceColor','r','FaceAlpha',0.3)
legend('CV x 2','CV x 3')
xlabel('# of continuous negative prices');
%% monthly production check (Solar_N)
month_2015 =[31,28,31,30,31,30,31,31,30,31,30,31];
month_2016 =[31,29,31,30,31,30,31,31,30,31,30,31];
month_2017 =[31,28,31,30,31,30,31,31,30,31,30,31];
month = cat(2,month_2015,month_2016,month_2017);

monthlyprod_solar_N = zeros(length(month),1);
monthlyprod_solar_N(1)=sum(solar_N(1:(month(1)*24)));
for i = 2:length(month)
    hour1 = sum(month(1:i-1)*24);
    hour2 = sum(month(1:i)*24);
   monthlyprod_solar_N(i) = sum(solar_N(((hour1+1):hour2)));
end
figure
yaxis = 'Production [MWh]';
xaxis = 'Months';
ylabel (yaxis)
hold on
xlabel (xaxis)
plot(monthlyprod_solar_N,'r');
title('south solar');
title('# of continuous negative prices')
%% correlation: production vs. price
load('reshaped_data')
figure

wind = subplot(2,1,1);
scatter(wind,price_original, wind_N_spec,'bx');
hold on
title(wind,'Correlation between price and specific production of WIND NORTH')
xlabel(wind,'Price [EUR/MWh]')
ylabel(wind,'Specific production[KWh/KW]')
ylim(wind,[0 1.05])

solar = subplot(2,1,2);
scatter(solar,price_original, solar_S_spec,'rx');
title(solar,'Correlation between price and specific production os SOLAR SOUTH')
xlabel(solar,'Price [EUR/MWh]')
ylabel(solar,'Specific production [KWh/KW]')
ylim(solar,[0 1.05])
%% sensitivity: investment cost
%{
t = table;
num = 8;
sim = 10; % times of simulation
for ratio_PV = [0.9]
    for ratio_wind = [0.9]
        for ratio_storage = [0.9]
            record_diff_cost = zeros(sim,12);
            capital_cost = capital;
            capital_cost(1:4) = capital(1:4) * ratio_PV;
            capital_cost(5:8) = capital(5:8) * ratio_wind;
            capital_cost(9) = capital(9) * ratio_storage;
            
            for n = 1:sim
                rng(n);
                w = zeros (1,num+1);
                order = datasample([1:num+1],num+1,'Replace',false);
                for i = order(1:(end-1))
                    w (i) = (1-sum(w))*rand;
                end
                w (order(end)) = (1-sum(w));
                [revenue,risk]= RaR (w, budget, production,price,capital_cost);
                record_diff_cost(n,:) = [n,w,revenue,risk];
            end
             record_diff_cost_more = intensify(record_diff_cost,budget, production,price,capital_cost,true);
             record_diff_cost = [record_diff_cost;record_diff_cost_more];
                          
             t_diff_cost = some_points (3,record_diff_cost,budget, production,price,capital_cost);
             t_diff_cost.Properties.RowNames = ...
                 {sprintf('%.2f %.2f %.2f units',ratio_PV,ratio_wind,ratio_storage),...
                 sprintf('%.2f %.2f %.2f left',ratio_PV,ratio_wind,ratio_storage),...
                 sprintf('%.2f %.2f %.2f mid',ratio_PV,ratio_wind,ratio_storage),...
                 sprintf('%.2f %.2f %.2f right',ratio_PV,ratio_wind,ratio_storage)};

             t = [t;t_diff_cost];
             str = sprintf('done: %.2f %.2f %.2f',ratio_PV,ratio_wind,ratio_storage);
             disp(str)
        end
    end
end
writetable(t,'result_sensitivity_diff_cost.xlsx','WriteRowNames',true);
%}
%% feed-in-tariff
month_2015 =[31,28,31,30,31,30,31,31,30,31,30,31];
month_2016 =[31,29,31,30,31,30,31,31,30,31,30,31];
month_2017 =[31,28,31,30,31,30,31,31,30,31,30,31];
month = cat(2,month_2015,month_2016,month_2017);
fit_solar = [];
fit_wind = [];
for i = 1:length(fit_solar_ct_per_kwh) 
    fit = ones(month(i)*24,1)*fit_solar_ct_per_kwh(i)*10; % 1 ct/kwh = 1000 ct/MWh = 10 EUR/MWh
    fit_solar = [fit_solar;fit];
    fit = ones(month(i)*24,1)*fit_wind_ct_per_kwh(i)*10; % 1 ct/kwh = 1000 ct/MWh = 10 EUR/MWh
    fit_wind = [fit_wind;fit];
end
%% Capacity factor vs. risk and revenue
price = price_rescale_2cv;
whether_fit = false;
name = "capacity factors";

figure1 = figure('Name',figname);
rev = zeros(1,8);
cf = zeros(1,8);
risk = zeros(1,8);
for i = 1:8
    w = zeros(1,9);
    w(i) = i;
    record = RaR_detail (w, budget, production,price,capital,whether_fit,fit_wind,fit_solar);
    rev(i) = record.revenue;
    risk(i) = record.risk;
    cf(i) = record.cf(i);
    scatter(cf,rev);
end

savefig(name);
%% ------------------productivity 2015-2017----------------------------
load('data_time_series')
revenue_spec_solar = ts_price .* ts_solar_gen_mw ./ ts_solar_capa_mw; % [EUR/MW]
revenue_spec_wind = ts_price .* ts_wind_gen_mw ./ ts_wind_capa_mw; % [EUR/MW]

mean_revenue_spec_solar = mean(reshape(revenue_spec_solar(1:52560),730,[]),1)';
mean_revenue_spec_solar = fillmissing(mean_revenue_spec_solar,'linear');
mean_revenue_spec_wind = mean(reshape(revenue_spec_wind(1:52560),730,[]),1)';
mean_revenue_spec_wind = fillmissing(mean_revenue_spec_wind,'linear');

mean_revenue_spec_solar_reshape = reshape(mean_revenue_spec_solar,12,[]);
mean_revenue_spec_wind_reshape = reshape(mean_revenue_spec_wind,12,[]);

n = size(mean_revenue_spec_solar_reshape,2);
mean_year_solar = zeros(n,1);
RaR_year_solar = zeros(n,1);
mean_year_wind = zeros(n,1);
RaR_year_wind = zeros(n,1);

for i = 1:n
    monthly_revenue_spec_sort_solar = sort(mean_revenue_spec_solar_reshape(:,i), 'descend');
    monthly_revenue_spec_sort_wind = sort(mean_revenue_spec_wind_reshape(:,i), 'descend');
    
    mean_year_solar(i) = mean(monthly_revenue_spec_sort_solar);
    mean_year_wind(i) = mean(monthly_revenue_spec_sort_wind);

    alpha = 0.90;
    x = 11;                                         % 90% quantile between the 10th and 11th value
      
    VaR = monthly_revenue_spec_sort_solar(x);            
    phi = x/12;                              
    lambda = (phi-alpha)/(1-alpha);
    RaR_year_solar(i) = lambda * VaR + (1-lambda) * mean (monthly_revenue_spec_sort_solar((x+1):end));
    
    VaR = monthly_revenue_spec_sort_wind(x);            
    phi = x/12;                              
    lambda = (phi-alpha)/(1-alpha);
    RaR_year_wind(i) = lambda * VaR + (1-lambda) * mean (monthly_revenue_spec_sort_solar((x+1):end));
    
end
%% plot
productivity = figure('Name','Productivity')
axes1 = axes('Parent',productivity);

plot([1:n],mean_year_solar,'ro')
hold on
plot([1:n],RaR_year_solar,'r^')
plot(1.2:1:n+0.2,mean_year_wind,'bo')
plot(1.2:1:n+0.2,RaR_year_wind,'b^')
xlim([0.5,7])
ylim([0,7.5])
for i = 1:n
line([i,i],[mean_year_solar(i),RaR_year_solar(i)],'Color','r')
line([i+0.2,i+0.2],[mean_year_wind(i),RaR_year_wind(i)],'Color','b')
end
set(axes1,'XTick',[1.1:1:n+0.1],'XTickLabel',{'2012','2013','2014','2015','2016','2017'});
legend({'solar mean','solar RaR','wind mean','wind RaR'});
xlabel('years')
ylabel('[EUR/MW(capacity)]')
title('productivity across years')
savefig('productivity across years.fig')
%% ------------------Storage profitability under diff. time resolution-------------
% prediction period is 6 hours
figure('Name',"2016 Jan 15min (6 hours prediction, revenue)",'Color', [1 1 1]);
record.price = price_2016_15min(1:31*24*4); % Weighted Average Price (EUR/MWh)
w_storage = 1;
record.storageparam = storagetech(w_storage*budget,capital(end));
[record.revenue_arbitrage_15min,record.storage,record.charge,~] = storage_arbitrage (record.price, record.storageparam);
plot(record.revenue_arbitrage_15min)
savefig("2016 Jan 15min (6 hours prediction, revenue)")
sum(record.revenue_arbitrage_15min)
storage_operation_plot(record,"2016 Jan 15min (6 hours prediction, operation)");

figure('Name',"2016 Jan 1h (24 hours prediction, revenue)",'Color', [1 1 1]);
record.price = price_original((365*24+1):(365*24+31*24)); % Weighted Average Price (EUR/MWh)
w_storage = 1;
record.storageparam = storagetech(w_storage*budget,capital(end));
[record.revenue_arbitrage_1h,record.storage,record.charge,~] = storage_arbitrage (record.price, storageparam);
plot(record.revenue_arbitrage_1h)
savefig("2016 Jan 1h (24 hours prediction, revenue)")
sum(record.revenue_arbitrage_1h)
storage_operation_plot(record,"2016 Jan 1h (24 hours prediction, operation)");

% prediction period is still 24 hours
figure('Name',"2016 Jan 15min (24 hours prediction, revenue)",'Color', [1 1 1]);
record.price = price_2016_15min(1:31*24*4); % Weighted Average Price (EUR/MWh)
w_storage = 1;
record.storageparam = storagetech(w_storage*budget,capital(end));
[record.revenue_arbitrage_15min,record.storage,record.charge,~] = storage_arbitrage (record.price, record.storageparam);
plot(record.revenue_arbitrage_15min)
savefig("2016 Jan 15min (24 hours prediction,revenue)")
sum(record.revenue_arbitrage_15min)
storage_operation_plot(record,"2016 Jan 15min (24 hours prediction, operation)");
%% -------------- price comparison: CAISO vs. Germany--------------
%% DE (2015-2017)
month_2015 =[31,28,31,30,31,30,31,31,30,31,30,31];
month_2016 =[31,29,31,30,31,30,31,31,30,31,30,31]; % Nov. 3 missing
month_2017 =[31,28,31,30,31,30,31,31,30,31,30,31]; % Mar. 11, Mar. 12, Oct. 7, Nov. 11 missing
month = cat(2,month_2015,month_2016,month_2017);
%month = month_2015;
%price_CAISO_2015_EUR_per_MWh = price_CAISO_2015_USD_per_MWh*0.89;
monthly_price_ave_DE = zeros(length(month),1);
monthly_price_std_DE = zeros(length(month),1);

monthly_price_ave_DE(1)=mean(price_original(1:(month(1)*24)));
monthly_price_std_DE(1)=std(price_original(1:(month(1)*24)));

for i = 2:length(month)
    hour1 = sum(month(1:i-1)*24);
    hour2 = sum(month(1:i)*24);
    monthly_price_ave_DE(i)=mean(price_original(((hour1+1):hour2)));
    monthly_price_std_DE(i)=std(price_original(((hour1+1):hour2)));
end
%% PGEA
month_2015 =[31,28,31,30,31,30,31,31,30,31,30,31];
month_2016 =[31,29,31,30,31,30,31,31,30,31,29,31]; % Nov. 3 missing
month_2017 =[31,28,29,30,31,30,31,31,30,30,29,31]; % Mar. 11, Mar. 12, Oct. 7, Nov. 11 missing
month = cat(2,month_2015,month_2016,month_2017);
%month = month_2015;
%price_CAISO_2015_EUR_per_MWh = price_CAISO_2015_USD_per_MWh*0.89;
exchange_rate = 0.897368194; % EUR/USD
price_PGAE = cat(1, PGAE_2015_USD_per_MWh, PGAE_2016, PGAE_2017)*exchange_rate;
monthly_price_ave_CA = zeros(length(month),1);
%monthly_price_ave_DE = zeros(length(month),1);
monthly_price_std_CA = zeros(length(month),1);
%monthly_price_std_DE = zeros(length(month),1);

monthly_price_ave_CA(1)=mean(price_PGAE(1:(month(1)*24)));
%monthly_price_ave_DE(1)=mean(price_original(1:(month(1)*24)));
monthly_price_std_CA(1)=std(price_PGAE(1:(month(1)*24)));
%monthly_price_std_DE(1)=std(price_original(1:(month(1)*24)));

for i = 2:length(month)
    hour1 = sum(month(1:i-1)*24);
    hour2 = sum(month(1:i)*24);
    monthly_price_ave_CA(i) = mean(price_PGAE((hour1+1):hour2));
    %monthly_price_ave_DE(i)=mean(price_original(((hour1+1):hour2)));
    monthly_price_std_CA(i) = std(price_PGAE(((hour1+1):hour2)));
    %monthly_price_std_DE(i)=std(price_original(((hour1+1):hour2)));
end

figure
yaxis = 'Day-ahead price [€/MWh]';
xaxis = 'Months';
ylabel (yaxis)
hold on
xlabel (xaxis)
plot(monthly_price_ave_CA,'r');
plot(monthly_price_ave_DE,'b');
plot(monthly_price_std_CA,'r--');
plot(monthly_price_std_DE,'b--');
legend("California (PGAE region), mean", "Germany, mean", ...
    "California (PGAE region), standard deviation", "Germany, standard deviation")
title('Price comparison between Germany and the PGAE region')
std(monthly_price_ave_CA)
std(monthly_price_ave_DE)
%% SDGE vs DE
%month_2015 =[31,28,31,30,31,30,31,31,30,31,30,31];
month_2016 =[31,29,31,30,31,30,31,31,30,31,29,31]; % Nov. 3 missing
month_2017 =[31,28,29,30,31,30,31,31,30,30,29,31]; % Mar. 11, Mar. 12, Oct. 7, Nov. 11 missing
month = cat(2,month_2016,month_2017);
%month = month_2015;
%price_CAISO_2015_EUR_per_MWh = price_CAISO_2015_USD_per_MWh*0.89;
exchange_rate = 0.897368194; % EUR/USD
price_SDGE = cat(1, SDGE_2016, SDGE_2017)*exchange_rate;
monthly_price_ave_CA = zeros(length(month),1);
%monthly_price_ave_DE = zeros(length(month),1);
monthly_price_std_CA = zeros(length(month),1);
%monthly_price_std_DE = zeros(length(month),1);

monthly_price_ave_CA(1)=mean(price_SDGE(1:(month(1)*24)));
%monthly_price_ave_DE(1)=mean(price_original(1:(month(1)*24)));
monthly_price_std_CA(1)=std(price_SDGE(1:(month(1)*24)));
%monthly_price_std_DE(1)=std(price_original(1:(month(1)*24)));

for i = 2:length(month)
    hour1 = sum(month(1:i-1)*24);
    hour2 = sum(month(1:i)*24);
    monthly_price_ave_CA(i) = mean(price_SDGE((hour1+1):hour2));
    %monthly_price_ave_DE(i)=mean(price_original(((hour1+1):hour2)));
    monthly_price_std_CA(i) = std(price_SDGE(((hour1+1):hour2)));
    %monthly_price_std_DE(i)=std(price_original(((hour1+1):hour2)));
end

figure
yaxis = 'Day-ahead price [€/MWh]';
xaxis = 'Months';
ylabel (yaxis)
hold on
xlabel (xaxis)
plot(monthly_price_ave_CA,'r');
plot(monthly_price_ave_DE(13:end),'b');
plot(monthly_price_std_CA,'r--');
plot(monthly_price_std_DE(13:end),'b--');
legend("California (SDGE region), mean", "Germany, mean", ...
    "California (SDGE region), standard deviation", "Germany, standard deviation")
title('Price comparison between Germany and the SDGE region')
std(monthly_price_ave_CA)
std(monthly_price_ave_DE(13:end))