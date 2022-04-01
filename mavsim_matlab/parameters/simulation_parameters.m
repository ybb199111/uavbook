%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% simulation parameters
%
% mavMatSim
%   - Beard & McLain, PUP 2012
%   - Modification History:
%       12/15/2018 - RWB

SIM.ts_simulation = 0.02;  % smallest time step for simulation 最小时间步
SIM.ts_control = SIM.ts_simulation;
SIM.ts_plotting = 0.5;
SIM.ts_video = 0.1;

SIM.start_time = 0;%起始时间
SIM.end_time = 30;%结束时间
