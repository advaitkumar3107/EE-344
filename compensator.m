audio_data = readtable('noise_cancel.xlsx');  % Read data from excel sheet

freqs = table2array(audio_data(1:end,1));     % Store frequency values in Hz
mags = table2array(audio_data(1:end,12));     % Store magnitude values
phases = table2array(audio_data(1:end, 16));  % Store phase values

C_s = C(1i*freqs);                            % Compensator C(jw)
G_s = 10.^(mags./20).*exp(1i.*2.*pi.*phases/360);  % Convert DB into amplitude
closed_tf_noise = (G_s)./(1 + C_s.*G_s);      % Closed loop transfer function from noise to output
closed_tf_v = (C_s.*G_s)./(1 + C_s.*G_s);     % Closed loop transfer function of the entire system

Open_loop_mag = 20*log10(abs(C_s.*G_s));      % Magnitude in DB of open loop transfer function
Open_loop_ph = angle(C_s.*G_s);               % Phase of open loop transfer function
figure;  
subplot(2,1,1);                               % Select the upper plot
magnit = semilogx(freqs, Open_loop_mag)       % Bode magnitude plot
yline(0);                                     % Draw a line to indicate 0 DB gain for gain crossover frequency calculation
title('OL mag');                              % Title the plot
xlabel("Frequency (Hz)");                     % Label X Axis
ylabel("Magnitude (dB)");                     % Label Y Axis
subplot(2,1,2);                               % Select the lower plot
phased = semilogx(freqs, 180/pi*Open_loop_ph) % Bode phase plot
yline(-180);                                  % Draw a line to indicate the -180 degree phase gain for phase crossover frequency calculation
xlabel("Frequency (Hz)");                     % Label X Axis
ylabel("Phase (deg)");                        % Label Y Axis
title('OL phase');                            % Title the plot

function val = C(w)                           % Function to calculate the compensator transfer function stored in the variable val, with input as freq in Hz
    w = w*2*pi;                               % Convert Hz to rad/s
    val = ((w.^2 + 2*0.3*2*pi*1010.15*w + (2*pi*1010.15)^2).*(1 + (3*3.67e-4)*w).*(w + 2*pi*70))./((w.^2 + 2*0.3*2*pi*101.015*w + (2*pi*101.015)^2).*(1 + (3.67e-4)*w).*(w + 2*pi*40))/(17.78);    % The transfer function which we obtained for the compensator satisfying the constraints
end