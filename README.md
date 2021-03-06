# Background

These codes are to simulate the risk and return of renewable energy investment portfolios for the study "Building resilient renewable power generation portfolios: the impact of diversification on investors’ risk and return" [1]. 

The motivation and outcome are well summarized in the abstract -

"Over the coming years, variable renewables such as wind and photovoltaics will become increasingly exposed to market risks due to the gradual reduction in policy support. Building diversified portfolios of variable renewables and complementary technologies such as storage (i.e. technological diversification), and in different regions (i.e. geographical diversification) seem to be promising options to mitigate these risks. The extant literature, however, does not provide a comprehensive comparison of these two diversification strategies. Using actual production data from eight wind and photovoltaics plants across Germany from 2015 until 2017 and a storage unit for arbitrage operations, we build a quantitative model to evaluate the impact of these strategies on investors’ risk and return. In our analysis, we compare the results of two scenarios: the first with actual prices and the second which assumes prices reflecting higher shares of variable renewables in the power system. In doing so, our study provides the following important insights for investors: 

(1) technological diversification largely yields lower risk levels than geographical diversification, 

(2) maximizing the capacity factor of wind and photovoltaics is an effective way to mitigate risk, and 

(3) while technological diversification with another variable renewable technology is more effective under current conditions, storage gains importance for mitigating risk in times of high shares of variable renewables. "


# Code structure

In the main folder, there are all codes for the publication - not only codes for the model (model.m), but also codes for visualization, generating tables, plotting additional graphs etc.

In the folder "GUI", the main model is packed as a Matlab GUI application (RE_portfolio_investment.mlapp). User could upload data of power plants and storage to run the simulation. However, the application is not yet flexible to deal with different data dimensions.


[1] (Submitted) Sinsel, S. R., Yan, X., & Stephan, A. (2019). Building resilient renewable power generation portfolios: the impact of diversification on investors’ risk and return, Applied Energy.
