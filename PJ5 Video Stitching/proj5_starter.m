%% Library and Setting
clear;
clc;
close all;

addpath vlfeat-0.9.19/
addpath vlfeat-0.9.19/toolbox/
vl_setup;
% Image setting 
video_num = 4;
if video_num ==1 % street1
    start_f=1; end_f =900;
    ref=450;
    src = 270;
    master=[90   270   450   630   810];
    Xd = [-651 980];
    Yd = [-51 460];
elseif video_num == 2 %yuuqan
    start_f=1; end_f =544;
    ref= 270;
    src = 160;
    master=[40 165 270 385 500];
    Xd = [-801 1600];
    Yd = [-81 500];
elseif video_num ==3 % cross
    start_f=1; end_f =350;
    ref= 175;
    src = 144;
    master=[40 144 175 350 420];
    Xd = [-1001 1800];
    Yd = [-251 700];
elseif video_num ==4
    start_f=1; end_f =180;
    ref= 100;
    src = 60;
    master=[20 60 100 140 160];
    Xd = [-1801 2200];
    Yd = [-351 750];
end


% Setting
do_image_stitching = false;
    check_homo = true;
    check_stitch = true;
    
do_panorama = false;
    check_pano = true;
    
do_pano_movie = false;
    recompute = true;
    sample_rate =1;
    
do_background_panorama = false;
    check_back_pano = true;
    
do_background_movie = false;
do_foreground_movie = true;

%% Image Stitching
if do_image_stitching
    two_image_stitching(check_homo,check_stitch,ref,src,Xd,Yd);
end
%% Panorama Stitching
if do_panorama
    panorama_stitching(check_pano,master,ref,Xd,Yd);
end

%% Panorama Movie
if do_pano_movie
    panorama_movie(recompute,sample_rate,ref,start_f,end_f,Xd,Yd);
end

%% Background panorama
if do_background_panorama
    background_panorama(check_back_pano,sample_rate,ref);
end
%% Background Movie
if do_background_movie 
    background_movie(sample_rate,ref,Xd,Yd);
end
%% Foreground Movie
if do_foreground_movie
    foreground_movie(sample_rate,Xd,Yd);
end