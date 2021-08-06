# Modeling Just Noticeable Differences in Charts

Supplemental materials for the paper on _Modeling Just Noticeable Differences in Charts_ accepted in IEEE VIS'21.

<img src="https://github.com/deardeer/JND-in-Charts/blob/main/model_jnd.png" width=800></img>

## 'stimuli_data' folder 

the bounds for conditions, meta data driven 7200 plots

	- *_bounds.csv // (epsilon_lower epsilon_upper) for each conditions in three charts
	- plot_data/*_test_*.json // data for the 7200 plots, i.e., heights of bars (in pixel) for bar chart, radius for bubbles in bubble chart, angles of fan in pie chart
	- plot_data/*_meta_*.json // meta data for the 7200 plots, i.e., the 'intensity of standard stimulus' (baseHeight/baseR/baseAngle) in each plot, 'difference' (delta*), and 'distance' (gap*)

## "jnd" folder 

the estimated jnds, sorted by chart type

	- jnd_bar.csv
	- jnd_bubble.csv
	- jnd_pie.csv
	
Data dict:
- userid: [String] unique user id
- intensity: [Int] intensity of standard stimulus (i.e., height in bar chart, radius in bubble chart, degree in pie chart)
- distance: [float] distance between standard stimulus and compared stimulus
- jnd: [float] estimated Just Noticeable Difference
- pse: [float] estimated Point of Subjective Equality


## "rawdata" folder 

the raw data collected for each trial, for each chart type, the raw data sorted by user, in file name formate of "userid.csv"

	- bar/*.csv  
	- bubble/*.csv
	- pie/*.csv

Data dict:
- yes-answer: [Boolean] 1 if answering the compared stimulus is larger/taller than standard stimulus; 0 if not
- time: [Float] time cost of answering this trial- intensity: [Int] intensity standard stimulus in this trial
- distance: [float] distance in this trial- difference: [float] the intensity difference between compared stimulus and standard stimulus, if negative, it means compared stimulus is smaller/shorter than standard stimulus.

## "stat" folder 

the yes-answer counting for each condition, for each chart type, the yes-answer is sorted by each user, each condition, in file name formate of "userid_distance_intensity.csv"
	
	- bar/*.csv
	- bubble/*.csv
	- pie/*.csv


## "stat_dest” folder 

computed JND for each user at each condition, in each chart type, in file name formate of "userid_distance_intensity.csv.txt”
	
	- dest_bar/*.txt
	- dest_bubble/*.txt
	- dest_pie/*.txt


Date dict:
- X: [Float] the intensity of compared stimulus
- Yes: [Int] the number of yes-answer in that 10 trials 
- Total: [Int] the number of trials in that comparison, we repeat 10 trials, so it is 10

## “code” folder 

the python / R script that we run to analysis the data
	
	-draw_jnd_distribution.ipynb // draw the box plot distribution in Fig. 4
	-compJND_2021_submitted.R // read data from stat and compute JNDs
	-jnd_*2021_submitted.R // JND modeling in three charts

## To cite this work

```
@article{lu2021jnd,
  title={Modeling Just Noticeable Differences in Charts},
  author={Lu, Min and Lanir, Joel and Wang, Chufeng and Yao, Yucong and Zhang, Wen and Duessen, Oliver and Huang, Hui},
  journal={IEEE Transactions on Visualization and Computer Graphics},
  year={2021 (to appear)},
  publisher={IEEE}
}
```
