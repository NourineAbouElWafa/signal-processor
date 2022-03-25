disp("---------Signal Generator---------");

frequency = str2double (input('Sampling Frequecny: ','s'));
while(frequency<=0) || isnan(frequency) 
    frequency=str2double(input('Enter a valid sampling Frequecny: ','s'));
end
startTime = str2double(input('Start time: ','s'));
while isnan(startTime) 
   startTime =str2double(input('Enter a valid start time: ','s'));
end
endTime = str2double(input('End time: ','s')); 
while isnan(endTime) || (endTime<startTime)
    endTime =str2double(input('Enter a valid end time: ','s'));
end

breakPointsNo = str2double(input('Number of break points: ','s')); 
while isnan(breakPointsNo) || (breakPointsNo<0)
   breakPointsNo =str2double(input('Enter a valid number > 0: ','s'));
end
breakPoints =[];
for i = 1:breakPointsNo
  breakPoints(i) = input(['End time for break point ' num2str(i) ': ']);   
end
breakPoints(breakPointsNo+1)= endTime;
regionStartTime = startTime;
timeTotal = [];
yTotal = [];
for i = 1:breakPointsNo+1
  region = strcat(num2str(regionStartTime), ' > ', num2str(breakPoints(i)));
  signalType = input(['Choose signal type for region ' char(region) ':\n1- DC Signal\n2- Ramp Signal\n3- General Order Polynomial Signal\n4-Exponential Signal\n5- Sinusoidal Signal\n']);  
  sampleRegion = (breakPoints(i)-regionStartTime)*frequency; 
  t = linspace(regionStartTime, breakPoints(i), sampleRegion);
   switch (signalType)
     case 1 %DC
        amplitude = input('Amplitude of DC: '); 
        y = amplitude*ones(1, fix(sampleRegion));
     case 2 %Ramp
       slope = input('Slope of Ramp signal: '); 
       intercept = input('Intercept of Ramp signal: '); 
       y = slope*t + intercept;
     case 3 %General Order Polynomial
        power =str2double( input('Enter the General Order Polynomial''s power: '));
        amplitudePolynominal = zeros(1, power+1);
        z = 1;
       for x=power:-1:1
       fprintf('Enter the t^%i coefficient: \n',x);
      amplitudePolynominal(z) = input('');
         z= z+1;
       end 
      intercept = str2double(input('Enter the General Order Polynomial''s intercept: ')); 
      amplitudePolynominal(power+1) = intercept;
       y = polyval(amplitudePolynominal, t);
     case 4 %Exponential
       amplitude = input('Amplitude of Exponential signal: '); 
       exponent = input('Exponent of Exponential signal: '); 
       y = amplitude*exp(exponent*t);
     case 5%"Sinusoidal
        amplitude = input('Amplitude of Sinosoidal signal: '); 
        freq = input('Freqency of Sinosoidal signal: '); 
        phase = input('Phase of Sinosoidal signal: '); 
        y = amplitude*sin(2*pi*freq*t + phase);
   end
   regionStartTime = breakPoints(i);
   timeTotal = [timeTotal t];
   yTotal = [yTotal y];
end
figure
plot(timeTotal, yTotal);
xlim([startTime endTime]);
grid on;

while(1)
    signalOperation = input(['Choose any of the following operations: ' '\n1-Amplitude Scaling' '\n2-Time Reversal' '\n3-Time Shift' '\n4-Expanding the signal' '\n5-Compressing the signal\n']);
    tOperated= timeTotal;
    yOperation = yTotal;
    switch (signalOperation)
        case 1 %"Amplitude Scaling"
            scale = str2double(input('Scale value: ')); 
            yOperation = scale*yTotal;
        case 2 %"Time Reversal"
            tOperated = fliplr(-timeTotal);
            yOperation = fliplr(yTotal);
        case 3 %"Time Shift"
            shift = str2double(input('Shift value: ')); 
            tOperated = timeTotal + shift;
           
        case 4 %"Expanding the signal"
            c =str2double( input('Expanding value: '));
            while (c>1)
                c =str2double( input('Please enter a expanding value between 0 and 1: '));
            end
            if c ~= 0
                tOperated = c*timeTotal;
                
            end
        case 5 %"Compressing"
            c =str2double( input('Compressing value: '));
            while (c<1)
                c =str2double( input('Please enter a compressing value > 1: '));
            end   
                tOperated = c*timeTotal;
                 
            
        otherwise break;
    end
    figure
    plot(tOperated, yOperation);
    grid on;
 end