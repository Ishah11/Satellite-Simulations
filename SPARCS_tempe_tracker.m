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

% Give the 3D window a second to physically open before we move the camera
pause(2); 

% 1. Extract SPARCS's exact starting coordinates [Latitude; Longitude; Altitude]
[startPos, ~] = states(sparcsSat, startTime, "CoordinateFrame", "geographic");

% 2. Move the camera to those coordinates, but 2,000 km higher up
% startPos(3) is the satellite's altitude in meters. We add 2,000,000 meters.
campos(viewer, startPos(1), startPos(2), startPos(3) + 2000000);

% 3. Lock the target onto SPARCS
camtarget(viewer, sparcsSat);

% Add the ground track 
leadTime = 5800; 
trailTime = 5800;
groundTrack(sparcsSat, "LeadTime", leadTime, "TrailTime", trailTime);

%% 6. Animate the Orbit
% Set playback speed
viewer.PlaybackSpeedMultiplier = 500; 

disp('Starting animation...');
play(sc);


