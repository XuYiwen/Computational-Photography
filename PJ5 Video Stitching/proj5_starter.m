%% Library and Setting
clear;
clc;
close all;

addpath vlfeat-0.9.19/
addpath vlfeat-0.9.19/toolbox/
vl_setup;

% Setting
do_image_stitching = false;
    check_homo = false;
    check_stitch = false;
    
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
    two_image_stitching(check_homo,check_stitch);
end
%% Panorama Stitching
if do_panorama
    panorama_stitching(check_pano);
end

%% Panorama Movie
if do_pano_movie
    panorama_movie(recompute,sample_rate);
end

%% Background panorama
if do_background_panorama
    background_panorama(check_back_pano,sample_rate);
end
%% Background Movie
if do_background_movie 
    background_movie(sample_rate);
end
%% Foreground Movie
if do_foreground_movie
    foreground_movie(sample_rate);
end