## 1. Specific words Recognition, using MATLAB
	A. Pre-emphasis
	B. Hamming Window
	C. Feature Extraction
	D. Training
	E. Test
## 2. Open/Close door-lock with Arduino

***
## 1. Specific words Recognition, using MATLAB
 ### A. Pre-emphasis:
		1. smoothing filter

		2. remove silence


 ### B. Hamming Window
 ### C. Feature Extraction
		1. pitch
			split Voice and Unvoice
			(we use Voice Only)
		2. MFCC
			13 first MFCC coefficient
			
 ### D. Training
		1. standardize
		2. KNN algorithm
		
		use makeNewClassifier.m
** trainedClassifier is in "func" folder already; Use 'makeNewClassifier.m' if you need train new classifier. **
		
 ### E. Test
		use CheckAudio.m
 
***
 ## 2. Open/Close door-lock with Arduino
		upload "/arduino/door/door.ino" to the Arduino board
		use CheckAudioA.m
		
***
**notice: extract trainFiles.zip in order to use for training**
