# sig_and_plot_function
significant levels and ggplot2 plot function (R)


### Background
some available function such as `stat_compare_means {ggpubr}` can help to add P-value and significant levels on plots. However, it has to specify the comparisons pairs if you prefer to remain the significant pairs on plots.

`sig_and_plot_function.R` can help to filter significant pairs and their P-values. The significant pairs can be plot with `stat_signif {ggsignif}.` 

### Brief introduction 
`sig_and_plot_function.R` contains 2 functions: 

**`which_pair_to_use`**:
`which_pair_to_use (data, variable, group, cutoff = 0.1, p.adjust_method = "fdr", format_ = "sig_level")`

**input**:

> data: dataframe, with group variable (multiple classification)
> 
> variable: the variable you want to test group difference, colname in data, remember to add ""
>
> group: the group(colname) in data, remember to add ""
>
> cutoff: cutoff value for P value, result will remain if p < cutoff
>
> p.adjust_method: choose from c("holm", "hochberg", "hommel", "bonferroni", "BH", "BY", "fdr", "none")
>
> format_: p value using round(5) or \*\*\*, \*\*,\*  (<= 0.001: \*\*\*,0.001 ~ 0.01: \*\*,0.01 ~ 0.05:\*) , format_="sig_level" means formated with '*' and anything else is float format P value 
> 

**output**: 
 
> list(), list()[[1]]: pairs which p < cutoff , list()[[2]]: pairs(names) and its p-value


**`fun_to_routine_box`**:
`fun_to_routine_box(data,group,value, color = brewer.pal(7,"Set3"), add_sig = TRUE,format_='sig_level',
                      xtitle = 'xtitle',ytitle ='ytitle',legendtitle = 'legend')`

**input**: 

> data: dataframe, with group variable (multiple classification)
> 
> group: the group(colname) in data, remember to add ""
>
> value: the variable you want to test group difference and plot, colname in data, remember to add ""
>
> color: color vector
>
> add_sig: add_sig=TURE will add significant levels using which_pair_to_use result
>
> xtitle,ytitle,legendtitle: add it yourself
>

**output**:
> ggplot2 plot



### output demostration
plot with \*
![](https://upload-images.jianshu.io/upload_images/5638276-a1e39fed06ccf68d.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)



plot with P-value
![](https://upload-images.jianshu.io/upload_images/5638276-3b522162beb85374.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)



### required packages
```R
library(mlbench) # data(Glass) for demostration 
# Glass Identification Data Set infromation: https://archive.ics.uci.edu/ml/datasets/Glass+Identification
library(ggsignif)
library(ggplot2)
```
