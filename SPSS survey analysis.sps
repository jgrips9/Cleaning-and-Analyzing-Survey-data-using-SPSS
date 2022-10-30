* Encoding: UTF-8.
show dir.
cd "Samples\English".
GET
  FILE='demo.sav'.
DATASET NAME DataSet1 WINDOW=FRONT.

*Point and click. Use menu. Paste option to send code to syntax. 

*comment. Begins with asterisk, end with period.
*remove missing values.
*Data -> Select Cases.
FILTER OFF.
USE ALL.
SELECT IF (MISSING(age) = 0).
EXECUTE.


SORT CASES BY age(A).
*identify duplicates. Data -> identify duplicates.
MATCH FILES
  /FILE=*
  /BY age
  /FIRST=PrimaryFirst
  /LAST=PrimaryLast.
DO IF (PrimaryFirst).
COMPUTE  MatchSequence=1-PrimaryLast.
ELSE.
COMPUTE  MatchSequence=MatchSequence+1.
END IF.
LEAVE  MatchSequence.
FORMATS  MatchSequence (f7).
COMPUTE  InDupGrp=MatchSequence>0.
SORT CASES InDupGrp(D).
MATCH FILES
  /FILE=*
  /DROP=PrimaryLast InDupGrp MatchSequence.
VARIABLE LABELS  PrimaryFirst 'Indicator of each first matching case as Primary'.
VALUE LABELS  PrimaryFirst 0 'Duplicate Case' 1 'Primary Case'.
VARIABLE LEVEL  PrimaryFirst (ORDINAL).
FREQUENCIES VARIABLES=PrimaryFirst.
EXECUTE.

*drop duplicates.
*Data -> Select Cases.
FILTER OFF.
USE ALL.
SELECT IF (PrimaryFirst = 1).
EXECUTE.

*Change datatype. Using mouse, variable view. This is also where you create variable and value labels. View -> value labels. 
*get back original dataset.
GET
  FILE='demo.sav'.
DATASET NAME DataSet2 WINDOW=FRONT.

DATASET ACTIVATE DataSet2.

*drop unwanted data. Example 

*only women.
*Data -> Select Cases.
DATASET ACTIVATE DataSet2.
FILTER OFF.
USE ALL.
SELECT IF (gender = 'f').
EXECUTE.

*only married women over 35.
FILTER OFF.
USE ALL.
SELECT IF (marital = 1  & age > 35).
EXECUTE.

*keep people who are somewhat satiesfied, or hightly satisfied with their jab.
FILTER OFF.
USE ALL.
SELECT IF (jobsat = 4  |  jobsat = 5).
EXECUTE.

*recode variable. Edit data. Transform -> recode into same variable.
*People who have college degrees, place in 1 category.
DATASET ACTIVATE DataSet6.
RECODE ed (5=4).
EXECUTE.



*Exercise.
*open sample dataset Different dataset. 
GET
  FILE='Employee Data.sav'.
DATASET NAME DataSet3 WINDOW=FRONT.

*remove rows that have 'missing' for previous experience(prevexp).
*Create new dataset that consists of female managers and all minorities.


*Reopen dataset. Start summary statistics. 
GET
  FILE='demo.sav'.
DATASET NAME DataSet4 WINDOW=FRONT.

*histogram. Graphs -> legacy Dialogs.
GRAPH
  /HISTOGRAM=income.

*analyze -> descriptive statistics -> frequencies.Frequency counts of variable.
FREQUENCIES VARIABLES=marital
  /BARCHART FREQ
  /ORDER=ANALYSIS.

*average income by income category.
DATASET ACTIVATE DataSet2.
MEANS TABLES=income BY inccat
  /CELLS=MEAN COUNT STDDEV.

*transform -> compute variable. New column.
COMPUTE income_tax=income * 92.
EXECUTE.


*Exercise.
*open employee data.
GET
  FILE='Employee Data.sav'.
DATASET NAME DataSet5 WINDOW=FRONT.

*create new variable. Difference in starting and current salary.
* Edit Salary data. if manager increase wage by 5%
*how many females in dataset?
* Show distribution of salary using histogram. 
* Show frequency counts of 'educ' variable using barplot. 


GET
  FILE='demo.sav'.
DATASET NAME DataSet6 WINDOW=FRONT.

*Analysis.
*crosstab income category by job satisfaction.
*analyze -> descriptive statitistics -> crosstabs. 
CROSSTABS
  /TABLES=inccat BY jobsat
  /FORMAT=AVALUE TABLES
  /STATISTICS=CHISQ 
  /CELLS=COUNT ROW COLUMN 
  /COUNT ROUND CELL.


CROSSTABS
  /TABLES=inccat BY jobsat BY gender
  /FORMAT=AVALUE TABLES
  /STATISTICS=CHISQ 
  /CELLS=COUNT ROW COLUMN 
  /COUNT ROUND CELL.

*Talk significance.
    
*hypothesis tests.
*compare income to retired and non retired members. 
*Analyze -> compare means -> means.
T-TEST GROUPS=retire(0 1)
  /MISSING=ANALYSIS
  /VARIABLES=income
  /ES DISPLAY(TRUE)
  /CRITERIA=CI(.95).


*Now Compare with multiple groups.Anova test.
*compare income by job satisfaction. 
*Analyze -> Comare Means -> One - Way ANOVA.
ONEWAY income BY jobsat
  /MISSING ANALYSIS
  /POSTHOC=TUKEY ALPHA(0.05).

