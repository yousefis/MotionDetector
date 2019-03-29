# MotionDetector


#######################################################
#######################################################


    3D-DWT Motion Detector  
    
    Developed by: Sahar Yousefi
 
 
#######################################################
#######################################################

for more information : http://dspl.ce.sharif.edu/motiondetector.html

Team: Sahar Yousefi, M.T. Manzuri Shalmani, Jeremy Lin, Marius Staring


## Team Members

Sahar Yousefi <a href="s.yousefi.radi@lumc.nl">s.yousefi.radi@lumc.nl</a>

M.T. Manzuri Shalmani <a href="manzuri@sharif.edu">manzuri@sharif.edu</a>

Jeremy Lin <a href="Jeremy.Lin@pjm.com">Jeremy.Lin@pjm.com</a>

Marius Staring <a href="m.staring@lumc.nl">m.staring@lumc.nl</a>

## Run:
    main.m
    
## Flow diagram 

![Alt Text](image170.png)

 Flow diagram of the proposed method. The input is a sequence of video frames; Step 1: Extracting the cubic patches; Step 2: Applying the 3D-DWT on each patch for computing wavelet coefficients, and wavelet leaders. The seven green patches are the wavelet coefficients extracted from the original patch, the yellow patch is the wavelet leader of 3rd scale, the seven blue patches are the wavelet coefficients extracted from W3_{LLL}, the orange patch is the wavelet leader of 2nd scale, the eight cubic red patches are the wavelet coefficients extracted from W2_{LLL}, and the purple patch is the wavelet leader of 1 st patch. Step 3: Computing the feature descriptors using the wavelet coefficients and the wavelet leaders, here the value of features for all the wavelet coefficients and the wavelet leaders are shown. The green arrows depict the feature descriptor values for the moving objects in the video sequences. As can be seen, the feature descriptors F_{LHH}, F_{HLH}, F_{LLH}, Fleader can model the motion pattern obviously; Step 4: Applying K-means classification. Finally, the result of the classifier which illustrate moving objects (red regions) and static regions (green regions).

## Results

![Alt Text](image256.gif)

![Alt Text](image255.gif)

![Alt Text](image254.gif)

![Alt Text](image253.gif)

![Alt Text](image252.gif)

![Alt Text](image250.gif)




## Acknowledgments

Thanks to S. Cai et al.[1] for their Wavelet Transforms package. 

1. S. Cai, K. Li, and I. Selesnick. Matlab Implementation of Wavelet Transforms. Retrieved from http://eeweb.poly.edu/iselesni/WaveletSoftware on February 13, 2018.
