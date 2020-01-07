
# Examining Racial Discrimination in the US Job Market

### Background
Racial discrimination continues to be pervasive in cultures throughout the world. Researchers examined the level of racial discrimination in the United States labor market by randomly assigning identical résumés to black-sounding or white-sounding names and observing the impact on requests for interviews from employers.

### Data
In the dataset provided, each row represents a resume. The 'race' column has two values, 'b' and 'w', indicating black-sounding and white-sounding. The column 'call' has two values, 1 and 0, indicating whether the resume received a call from employers or not.

Note that the 'b' and 'w' values in race are assigned randomly to the resumes when presented to the employer.

<div class="span5 alert alert-info">
### Exercises
You will perform a statistical analysis to establish whether race has a significant impact on the rate of callbacks for resumes.

Answer the following questions **in this notebook below and submit to your Github account**. 

   1. What test is appropriate for this problem? Does CLT apply?
   2. What are the null and alternate hypotheses?
   3. Compute margin of error, confidence interval, and p-value. Try using both the bootstrapping and the frequentist statistical approaches.
   4. Write a story describing the statistical significance in the context or the original problem.
   5. Does your analysis mean that race/name is the most important factor in callback success? Why or why not? If not, how would you amend your analysis?

You can include written notes in notebook cells using Markdown: 
   - In the control panel at the top, choose Cell > Cell Type > Markdown
   - Markdown syntax: http://nestacms.com/docs/creating-content/markdown-cheat-sheet


#### Resources
+ Experiment information and data source: http://www.povertyactionlab.org/evaluation/discrimination-job-market-united-states
+ Scipy statistical methods: http://docs.scipy.org/doc/scipy/reference/stats.html 
+ Markdown syntax: http://nestacms.com/docs/creating-content/markdown-cheat-sheet
+ Formulas for the Bernoulli distribution: https://en.wikipedia.org/wiki/Bernoulli_distribution
</div>
****


```python
import pandas as pd
import numpy as np
from scipy import stats
```


```python
data = pd.io.stata.read_stata('data/us_job_market_discrimination.dta')
```


```python
# number of callbacks for black-sounding names
sum(data[data.race=='w'].call)
```




    235.0




```python
data.head()
```




<div>
<style>
    .dataframe thead tr:only-child th {
        text-align: right;
    }

    .dataframe thead th {
        text-align: left;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>id</th>
      <th>ad</th>
      <th>education</th>
      <th>ofjobs</th>
      <th>yearsexp</th>
      <th>honors</th>
      <th>volunteer</th>
      <th>military</th>
      <th>empholes</th>
      <th>occupspecific</th>
      <th>...</th>
      <th>compreq</th>
      <th>orgreq</th>
      <th>manuf</th>
      <th>transcom</th>
      <th>bankreal</th>
      <th>trade</th>
      <th>busservice</th>
      <th>othservice</th>
      <th>missind</th>
      <th>ownership</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>b</td>
      <td>1</td>
      <td>4</td>
      <td>2</td>
      <td>6</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>1</td>
      <td>17</td>
      <td>...</td>
      <td>1.0</td>
      <td>0.0</td>
      <td>1.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td></td>
    </tr>
    <tr>
      <th>1</th>
      <td>b</td>
      <td>1</td>
      <td>3</td>
      <td>3</td>
      <td>6</td>
      <td>0</td>
      <td>1</td>
      <td>1</td>
      <td>0</td>
      <td>316</td>
      <td>...</td>
      <td>1.0</td>
      <td>0.0</td>
      <td>1.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td></td>
    </tr>
    <tr>
      <th>2</th>
      <td>b</td>
      <td>1</td>
      <td>4</td>
      <td>1</td>
      <td>6</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>19</td>
      <td>...</td>
      <td>1.0</td>
      <td>0.0</td>
      <td>1.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td></td>
    </tr>
    <tr>
      <th>3</th>
      <td>b</td>
      <td>1</td>
      <td>3</td>
      <td>4</td>
      <td>6</td>
      <td>0</td>
      <td>1</td>
      <td>0</td>
      <td>1</td>
      <td>313</td>
      <td>...</td>
      <td>1.0</td>
      <td>0.0</td>
      <td>1.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td></td>
    </tr>
    <tr>
      <th>4</th>
      <td>b</td>
      <td>1</td>
      <td>3</td>
      <td>3</td>
      <td>22</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>0</td>
      <td>313</td>
      <td>...</td>
      <td>1.0</td>
      <td>1.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>0.0</td>
      <td>1.0</td>
      <td>0.0</td>
      <td>Nonprofit</td>
    </tr>
  </tbody>
</table>
<p>5 rows × 65 columns</p>
</div>



<div class="span5 alert alert-success">
<p>A1:I will use two proportion z-test. The CLT does apply.  
A2:The null hypothesis is the callback rates are equal across racial groups. The alternative hypothesis is the callback rates are not equal across racial groups. </p>
</div>


```python
w = data[data.race=='w']
b = data[data.race=='b']
```


```python
# Your solution to Q3 here
```


```python
def ztest_proportion_two_samples(x1,n1,x2,n2,one_sided=False):
    p1=x1/n1
    p2=x2/n2
    p=(x1+x2)/(n1+n2)
    se=np.sqrt(p*(1-p)*(1/n1+1/n2))
    
    z=(p1-p2)/se
    p=1-stats.norm.cdf(abs(z))
    p*=2-one_sided
    return z,p
```


```python
w_call=np.array(w.iloc[:,20])
b_call=np.array(b.iloc[:,20])

w_x1=np.sum(w_call)
b_x1=np.sum(b_call)

w_n1=len(w_call)
b_n1=len(b_call)

z,p=ztest_proportion_two_samples(w_x1,w_n1,b_x1,b_n1,False)
```


```python
def compute_SE_two_sample(x1,n1,x2,n2):
    p1=x1/n1
    p2=x2/n2
    se=p1*(1-p1)/n1+p2*(1-p2)/n2
    return np.sqrt(se)

se=compute_SE_two_sample(w_x1,w_n1,b_x1,b_n1)
```


```python
def z_conf_int_two_samples(x1,n1,x2,n2,confidence=0.95):
    p1=x1/n1
    p2=x2/n2
    se=compute_SE_two_sample(x1,n1,x2,n2)
    z_critical=stats.norm.ppf((1+confidence)/2)
    return p1-p2-z_critical*se,p1-p2+z_critical*se

low,up=z_conf_int_two_samples(w_x1,w_n1,b_x1,b_n1,confidence=0.95)
print(low,up)    
```

    0.0167777281812 0.0472879802377
    


```python
margin_error=se*z
print("z value is "+str(z))
print("p value is "+str(p))
print("confidence interval is "+ str(low)+' '+str(up))
print("margin of error is "+str(margin_error))
```

    z value is 4.10841215243
    p value is 3.98388683758e-05
    confidence interval is 0.0167777281812 0.0472879802377
    margin of error is 0.0319772943052
    

<div class="span5 alert alert-success">
<p> A4:After two samples z test we found that the difference between the fraction of employers favoring Whites and the fraction of employers favoring African-Americans is statistically ver sigificant p is close to 0.
A5: This analysis does not mean the race/name is the most important factor in callback success because there are more other factors will affect employers' decision for example resume quality, applicants' address or different types of jobs.  </p>
</div>
