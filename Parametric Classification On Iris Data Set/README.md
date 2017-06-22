## Parametric Classification on Iris Data Set

#### About the Project
In this project, I have investigated Iris Data Set and make parametric classification in MATLAB. I have assumed that the data is coming from Gaussian Distribution. 

In addition to investigation of Iris Data Set, I have also worked on bias/variance dilemma and error plot for cross-validation. To plot bias/variance dilemma graph, I have generated 20 values in the range [0,5] from uniform distribution. Then I generate, 100 samples each having 20 instances coming from function f(x) = 2 * sin(1.5 * x) + e where e is error and normally distributed. For each of the samples, I fit polynomial models of order 1,2,3,4 and 5 and plot bias, variance and error of these models. Secondly, by using 100 samples generated above, I split the set into training and validation sets and plot errors. You can find regarding codes for these two parts in the file Q1_2.m

Thirdly, on Iris Data Set, I have found what is the best feature for classifation among features (sepal length, sepal width, petal length, petal width). Since I assume that the data is from Gaussian Distribution, I predict the classes of samples by using maximum likelood estimate of parameters mean and variance. The code regarding to this part is in Q3.m file. 

#### The Classification Results
When creating datasets, I use 70 of the samples as training samples and 30 as test samples.

|features 		| Mean of IS | Variance of IS | Mean of IV  | Variance of IV | True Predicted | False Predicted |
| :----------:	| ---- | -------- | ---- | -------- | -------------- | :-------------- |
|sepal length	|4.948387 |0.138581 | 5.953846 | 0.252551 | 27 | 3|
|sepal width	|3.383871 | 0.159398 | 2.776923 | 0.103401 | 26 | 4 |
|petal length	|1.438710 | 0.031118 | 4.274359 | 0.232483 | 30 | 0|
|petal width	|0.222581 | 0.008473 | 1.333333 | 0.042807 | 29 | 1 |
