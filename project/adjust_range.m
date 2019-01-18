function [range] = adjust_range(sensor_id,range)
 %This function is to adjust the range from different part of sensor to the center
 
 r_2 = sqrt(range^2 - 1.524^2);
 range = sqrt(r_2^2 - 0.279^2);
%  if sensor_id == 0 ||  sensor_id == 3
%      range = range + sqrt(0.55^2+0.457^2);
%  else
%      range = range + sqrt(0.368^2+2.43^2);
%  end
 
end