% ISS Live Tracker & Tempe, AZ Overpass Predictor (MATLAB R2024a)

%% 1. Define the Scenario Timeframe
startTime = datetime('now', 'TimeZone', 'UTC');
stopTime = startTime + days(1); % Look 24 hours ahead
sampleTime = 10; % Check position every 10 seconds

sc = satelliteScenario(startTime, stopTime, sampleTime);

%% 2. Fetch Live TLE Data
disp('Fetching live TLE data for the ISS...');
tleURL = 'https://celestrak.org/NORAD/elements/stations.txt';
tleData = webread(tleURL);

lines = splitlines(tleData);
issTLE = lines(1:3);

tleFilename = 'iss_live.tle';
writelines(issTLE, tleFilename);

%% 3. Add the ISS and Ground Station
% Add the ISS
iss = satellite(sc, tleFilename, "Name", "ISS");

% Add your location in Tempe, Arizona
% Coordinates: ~33.4255° N, 111.9400° W
tempe = groundStation(sc, 33.4255, -111.9400, "Name", "Tempe, AZ");

%% 4. Calculate Line-of-Sight Access
% Create an access analysis between the ISS and Tempe
ac = access(iss, tempe);

% Calculate the exact times the ISS is visible
% Note: This retrieves the schedule of overpasses!
overpasses = accessIntervals(ac);
disp('--- Upcoming ISS Overpasses for Tempe, AZ ---');
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
