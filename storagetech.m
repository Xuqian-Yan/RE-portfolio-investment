function storageparam = storagetech(investment,capital_cost)
%% NOTES:
% input: 
%   investment [EUR]
%   capital_cost [EUR/KWh]: assume 316 EUR/kWh (316,000 EUR/MWh)

% output: 
%   storagetech: struct
%   storagetech.ec: energy capacity [MWh]
%   storagetech.pc: power capacity [MW]
%   storagetech.dod: depth of discharge [-]
%   storagetech.ef: efficiency [-]
%% CALCULATION
storageparam=struct;
if investment==0
storageparam.ec = 0; 
storageparam.pc = 0; 
storageparam.dod = 0;
storageparam.ef = 0;
else
storageparam.ec = investment/(capital_cost*1000); %[MWh]
storageparam.pc = storageparam.ec/6; %[MW], assume c-rate = 6 hrs
storageparam.dod = 0.8;
storageparam.ef = sqrt(0.85);
end
end

