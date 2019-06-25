### which_pair_to_use: 
#### input: 
#### data: dataframe, with group variable (multiple classification)
#### variable: the variable you want to test group difference, colname in data, remember to add ""
#### group: the group(colname) in data, remember to add ""
#### cutoff: cutoff value for P value, result will remain if p < cutoff
#### p.adjust_method: choose from c("holm", "hochberg", "hommel", "bonferroni", "BH", "BY", "fdr", "none")
#### format_: p value using round(5) or * ,**, ***(<= 0.001 ***,0.001~0.01 **,0.01~0.05 *) format_="sig_level" is formated with '*' and anything else is float format P value 
#### output: 
#### list(), list()[[1]]: pairs which p < cutoff , list()[[2]]: pairs(names) and its p-value
which_pair_to_use <- function(data, variable, group, cutoff = 0.1, 
                              p.adjust_method = "fdr", format_ = "sig_level") {
  pair_p <- pairwise.wilcox.test(data[[variable]], data[[group]], p.adjust.method = p.adjust_method)
  ind <- which(pair_p$p.value < cutoff, arr.ind = TRUE)
  
  if (nrow(ind) > 0) {
    compairs <- list()
    p_adj_value <- c()
    group_idx <- c()
    for (i in 1:nrow(ind)){
      pair <- c(rownames(pair_p$p.value)[ind[i,"row"]], colnames(pair_p$p.value)[ind[i,"col"]])
      p_adj_value[i] <- round(pair_p$p.value[ind[i,"row"], ind[i,"col"]],5)
      group_idx[i] <- paste(rownames(pair_p$p.value)[ind[i,"row"]], colnames(pair_p$p.value)[ind[i,"col"]], sep = "_")
      names(p_adj_value) <- group_idx
      compairs[[i]] <- pair 
    }
    
    if (format_ == "sig_level") {
      p_adj_value = cut(p_adj_value, breaks = c(0, 0.001,0.01,0.05), include.lowest = T, labels = c("***", "**", "*"))
      names(p_adj_value) <- group_idx
    } else {p_adj_value[p_adj_value ==0] <- "<0.00001"}
    
    return(list(compairs, p_adj_value))
  } else {
    return(list(NA, NA))
  }
}

library(mlbench)  # use 'Glass' dataset 
data(Glass)
which_pair_to_use(data=Glass,variable = 'K',group = 'Type',cutoff = 0.0001,
                  p.adjust_method = 'fdr', format_ = 'no-sig')
# you will got this:
# [[1]]
# [[1]][[1]]
# [1] "6" "1"
# 
# [[1]][[2]]
# [1] "7" "1"
# 
# [[1]][[3]]
# [1] "6" "2"
# 
# [[1]][[4]]
# [1] "7" "2"
# 
# 
# [[2]]
# 6_1     7_1     6_2     7_2 
# "2e-05" "8e-05" "2e-05" "5e-05" 




#### input: 
#### data: dataframe, with group variable (multiple classification)
#### group: the group(colname) in data, remember to add ""
#### value: the variable you want to test group difference and plot, colname in data, remember to add ""
#### color: color vector
#### add_sig: add_sig=TURE will add significant levels using which_pair_to_use result
#### xtitle,ytitle,legendtitle: add it yourself
#### output:
#### ggplot2 plot
fun_to_routine_box <- function(data,group,value,
                               color = brewer.pal(7,"Set3"), add_sig = TRUE,format_='sig_level',
                               xtitle = 'xtitle',ytitle ='ytitle',legendtitle = 'legend') {
  p <- ggplot(data, aes_string(x=group, y = value, fill=group)) +
    geom_boxplot(position = position_dodge(0.8))+
    geom_point(position = position_jitterdodge())+
    scale_fill_manual(values = color) +
    labs(x=xtitle,y=ytitle) +
    theme(axis.text.x = element_blank(),
          axis.title.y = element_text(size = 15),
          axis.text.y = element_text(size = 15),
          axis.title.x = element_text(size = 15),
          legend.text=element_text(size = 22)) + 
    guides(fill = guide_legend(title = legendtitle, title.theme=element_text(size=22))) 
    
    if(add_sig==TRUE){
      p = p+ geom_signif(test = "wilcox.test", 
                         comparisons = which_pair_to_use(data,value, group, cutoff = 0.05, format_ = format_, p.adjust_method = 'fdr')[[1]],
                         vjust = 0,
                         textsize = 4,
                         size = .5,
                         step_increase = .08,
                         annotations = which_pair_to_use(data,value, group, cutoff = 0.05, format_ = format_, p.adjust_method = 'fdr')[[2]])
    } else {return(p)}
    return(p)
}


fun_to_routine_box(data = Glass, group = 'Type',value = 'K',xtitle = 'Type',ytitle = 'K', legendtitle = 'Type')

