function [ImgProcessTable, valid_points] = ProcessServoTestVideo(vidName)
% Process Servo Test Video

videoReader = VideoReader(vidName);
videoPlayer = vision.VideoPlayer('Position',[100,100,680,520]);

% Get frame
objectFrame = readFrame(videoReader);
figure; imshow(objectFrame);

objectRegion=round(getPosition(imrect));

%{
% %% Show
% objectImage = insertShape(objectFrame,'Rectangle',objectRegion,'Color','red');
% figure;
% imshow(objectImage);
% title('Red box shows object region');
% %% Detect interest points
% points = detectMinEigenFeatures(im2gray(objectFrame),'ROI',objectRegion);
% pointImage = insertMarker(objectFrame,points.Location,'+','Color','white');
% figure;
% imshow(pointImage);
% title('Detected interest points');
%}

% Execute
clear location points validity
points = detectMinEigenFeatures(im2gray(objectFrame),'ROI',objectRegion);
tracker = vision.PointTracker('MaxBidirectionalError',1);
initialize(tracker,points.Location,objectFrame);
ii = 1;
while hasFrame(videoReader)
      frame = readFrame(videoReader);
      [points,validity] = tracker(frame);
      out = insertMarker(frame,points(validity, :),'+');
      videoPlayer(out);
      location(:,:,ii) = points;
      ii = ii+1;
end

release(videoPlayer);

% Points
valid_points(1) = find(validity==1,1)
valid_locations1(:) = location(valid_points,1,:);
valid_locations2(:) = location(valid_points,2,:);
vlb = [valid_locations1(:),valid_locations2(:)];

% Time analysis
FrameRate = 1/videoReader.FrameRate;
% duration = videoReader.duration;
% timeVec = linspace(0,videoReader.duration,1/FrameRate)
timeVec = (0:length(valid_locations1)-1)*FrameRate;
% timeVec = timeVec1(1:length(vlb));
% Plot
plot(timeVec,vlb)
plotter(gcf,1)

ImgProcessTable = table(timeVec',vlb(:,1),vlb(:,2), 'VariableNames', {'Time', 'X', 'Y'});
end