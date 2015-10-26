VERSION 1.0
===========
May.26, 2009


INTRODUCTION
============
This package contains the mesh segmentation benchmark as well as programs and
scripts to run mesh segmentation evaluation and analysis experiments. 


DIRECTORIES
===========
./data - Mesh models plus segmentations from human and 7 algorithms
./exe - Executables for evaluation and analysis. Pre-compiled Win32 programs are included.
./src - Source code for libraries and application programs
./util - Executables and scripts to conduct evaluation and analysis experiemnt  

./analysis - Will be generated once you run analysis, this is where analysis results reside
./evaluation - Will be generated once you run evaluation, this is where evaluation results reside


HUMAN-GENERATED SEGMENTATIONS
=============================
In "./data/seg/Benchmark/", there are 380 sub-directories each containing
the segmentations (".seg" file) from multiple persons on one model.    


COMPILE THE SOURCE CODE
=======================
Our programs compile in Linux(32/64 bit) and Windows(with MSVC2005), and
support mesh file format in OFF(default)/PLY/OBJ. 

Please make sure OpenGL is installed in your OS. 
  
See "./src/README.txt" for compiling details.


RUNNING EXPERIMENTS
===================
We provide programs and scripts in "./util" to: 
1. run a new algorithm, 
2. evaluate the resulted segmentations, 
3. analyze segmentation properties 
4. visualize both evaluation and analysis results.

The four tasks could be run separately or all together with
"./util/scripts/runAll.py" 

Before running any experiment, please configure "./util/parameters/algorithmList.py".
If you need to run a new segmentation program, you should first configure
"./util/scripts/runAlgorithm/config.py".
    
Most scripts are written in Python and portable in both Linux and Windows (not in Cygwin). 
Visualizations may use MATLAB scripts. 

See "./util/scripts/README.txt" for more details.

