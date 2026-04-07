% SPARCS Tracker & Tempe, AZ Overpass Predictor (MATLAB R2024a)

%% 1. Define the Scenario Timeframe
startTime = datetime('now', 'TimeZone', 'UTC');
stopTime = startTime + days(1); % Look 24 hours ahead
sampleTime = 10; % Check position every 10 seconds

sc = satelliteScenario(startTime, stopTime, sampleTime);

%% 2. Define the Custom TLE Data for SPARCS
disp('Loading custom TLE data for SPARCS...');

% Hardcode the user-provided TLE strings
tleLine0 = 'SPARCS';
tleLine1 = '1 99973U 26004Z   26050.54039672  .00003742  00000-0  40948-3 0  9992';
tleLine2 = '2 99973  97.7983  51.0779 0003822 131.3500 228.8046 14.88403184  5791';

% Combine the lines and write them to a local file
sparcsTLE = [string(tleLine0); string(tleLine1); string(tleLine2)];
tleFilename = 'sparcs_custom.tle';
writelines(sparcsTLE, tleFilename);

%% 3. Add SPARCS and Ground Station
% Create the satellite object using the custom TLE file
sparcsSat = satellite(sc, tleFilename, "Name", "SPARCS");

% Keep your ground station in Tempe, Arizona
tempe = groundStation(sc, 33.4255, -111.9400, "Name", "Tempe, AZ");

%% 4. Calculate Line-of-Sight Access
% Create an access analysis between SPARCS and Tempe
ac = access(sparcsSat, tempe);

% Calculate the exact times SPARCS is visible
overpasses = accessIntervals(ac);
disp('--- Upcoming SPARCS Overpasses for Tempe, AZ ---');
if isempty(overpasses)
    disp('No visible overpasses in the next 24 hours.');
else
    disp(overpasses(:, {'StartTime', 'EndTime', 'Duration'}));
end

%% 5. Configure the Visualization
viewer = satelliteScenarioViewer(sc);

% Add a ground track (1.5 hours ahead/behind in seconds)
leadTime = 5400; 
trailTime = 5400;
groundTrack(iss, "LeadTime", leadTime, "TrailTime", trailTime);

%% 6. Animate the Orbit
% The PlaybackSpeedMultiplier belongs to the viewer, NOT the scenario!
viewer.PlaybackSpeedMultiplier = 60; 

disp('Starting animation...');
play(sc);
