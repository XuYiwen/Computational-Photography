%% Setting Up Path and Library
clear; clc; close all;
addpath('./src');

% Set up VLFeat Library
addpath ('./vlfeat-0.9.19/');
addpath ('./vlfeat-0.9.19/toolbox/');
vl_setup;

% Set up address
% [total_pano_num, pano_addr] = unify_file_names('./lib/pano/', 'panorama_', '.jpg');
total_pano_num = 19;
pano_addr = ['./lib/pano/panorama_'];
back_addr = ['./lib/back/background_'];
fore_addr = ['./lib/fore/cat'];
output_addr = ['./lib/output/output_'];

% Setting Filmning window size
window.w = 480;
window.h= 360;
window.speed = 8;

%% Infinite Background Extraction
undo_lib = [1:total_pano_num]';

cursor = 1; % the initial panorama
undo_lib = undo_lib(undo_lib ~= cursor);
last_overlap_size = 0;
remainder = [];
frame_id = 1;
while(~isempty(undo_lib))
    % red the current panorama to fill
    cur_pano = im2single(imread([pano_addr,sprintf('%03d',cursor),'.jpg']));
    cur_pano = resize_cut_add_pano(cur_pano,last_overlap_size,remainder,window);
     
    % extract windows from panorama, pass out the remainder(overlapping)
    [remainder,frame_id] = cut_windows_from_pano(cur_pano,back_addr,window,frame_id,0);
    last_overlap_size = size(remainder,2);
    
    % find the next panorama based on remainder(overlapping) 
    [next_cursor,next_header] = find_next_pano(remainder,undo_lib,pano_addr,window);
    
    % blend the remainder with header part of next panorama
    overlap_pano = blend_overlap(remainder,next_header,window);
    
    % extract windows from blended panorama
    [remainder,frame_id] = cut_windows_from_pano(overlap_pano,back_addr,window,frame_id,0);
    last_overlap_size = size(remainder,2);
    
    % if there is no panorama to find for next cursor,end loop
    cursor = next_cursor;
    undo_lib = undo_lib(undo_lib ~= cursor);
end   
% handle last panorama
cur_pano = im2single(imread([pano_addr,sprintf('%03d',cursor),'.jpg']));
cur_pano = resize_cut_add_pano(cur_pano,last_overlap_size,remainder,window);
[~,frame_id] = cut_windows_from_pano(cur_pano,back_addr,window,frame_id,1);
sum_of_frame = frame_id -1;

%% foreground animation
foreground_main(30,sum_of_frame,back_addr,output_addr,fore_addr);
%% Movie Generation

% Record to movie
disp(' --- Video Processing  --- ');
v = VideoWriter(sprintf('output_movie'));
open(v);
for i = 1:sum_of_frame
    toadd = im2single(imread(sprintf('lib/output/output_%03d.jpg',i)));
    writeVideo(v,toadd);
end
close(v); 
