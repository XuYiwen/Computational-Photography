close all;
clc;
clear;

reader = VideoReader('green.mp4');

% Read in all video frames.
vidFrames = read(reader);

% Get the number of frames.
numFrames = get(reader, 'NumberOfFrames');

% Create a MATLAB movie struct from the video frames.
for k = 1 : round(numFrames)
     toadd= vidFrames(:,:,:,k);
%      toadd = imresize(toadd,0.5,'bilinear' );
     imwrite(toadd,sprintf('frames/f%04d.jpg',k));
end