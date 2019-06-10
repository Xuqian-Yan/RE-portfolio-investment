function storage_operation_plot (detailstruct,name)
%% INPUT: "detailstruct" includes
%{
    .price = price;
	.weight=w * 100; % '%'
    .revenue = revenue;
    .risk = risk;

    .storageparam=storageparam;
    .storage=storage;
    .charge=charge;
    .utilization = utilization;

    name: a string, as the name of the figure
%}
set(0,'defaultAxesFontSize',12)

price = detailstruct.price;
storage = detailstruct.storage;
charge = detailstruct.charge;
storageparam = detailstruct.storageparam;
%utilization = cell2mat(struct2cell(detailstruct.utilization));

%% plot

figure('Name',name, 'Color', [1 1 1]);

n = length(storage);
n1 = 1;
n2 = 100;

ax1 = subplot(3,1,1);
plot(ax1,price(n1:n2),'k');
hold on

future = 24-1;   
price_ave = zeros(n2-n1+1,1);
for i = n1:n2         
    price_ave(i) = mean(price(i:(i+future)));
end

plot(ax1,price_ave,'k--');
plot(ax1,price_ave*0.9,'k:');
plot(ax1,price_ave*1.1,'k:');

ylabel (ax1,'Price [EUR/MWh]')
xlabel (ax1,'Hours ')
title (ax1,'Price development')
legend('Current price','Moving average (24 hours)','10% dead band around the average');
set(gca,'FontName','Times New Roman');
xlim([n1 n2]);

ax2 = subplot(3,1,2);
plot(ax2,storage(n1:n2),'k')
hold on
ylabel (ax2,'Storage [MWh]')
xlabel (ax2,'Hours ')
title (ax2,'State of charge')
set(gca,'FontName','Times New Roman');

try
    axis(ax2,[n1,n2,0,storageparam.ec*1.1])
%     hline=refline(ax1,[0,storageparam.ec]);
%     hline.Color='k';
%     hline.LineStyle='-.';
%    legend (ax3,'Storage','Energy capacity','Location','NorthEast')
catch exception
    axis(ax2,[n1,n2,0,1])
    legend (ax2,'Storage','Location','NorthEast')
end

% charge & discharge
ax3 = subplot(3,1,3);
plot(ax3,charge(n1:n2),'k')
hold on
ylabel (ax3,'Charge/discharge [MW]')
xlabel (ax3,'Hours')
title (ax3,'Charging cycle')
set(gca,'FontName','Times New Roman');

try
    axis(ax3,[n1,n2,-storageparam.pc*1.1,storageparam.pc*1.1])
catch exception
    axis(ax3,[n1,n2,0,1])
end

savefig(strcat(name,'.fig'))
% %% utilization pie chart
% figure
% pie(utilization);
% hold on
% legend('charge','discharge','idle','Location','eastoutside')
% title('Utilization rate') % in terms of time (hours)
end