close all;
clc;
clear;

reader = VideoReader('beijing.mp4');

% Read in all video frames.
vidFrames = read(reader);

% Get the number of frames.
numFrames = get(reader, 'NumberOfFrames');

% Create a MATLAB movie struct from the video frames.
for k = 1 : numFrames
     toadd= vidFrames(:,:,:,k);
     mov(k).colormap = [];
end