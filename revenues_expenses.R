---
title: "Current Revenues & Expenses"
output: 
  flexdashboard::flex_dashboard:
    orientation: rows
    theme: yeti
    social: ["facebook", "linkedin", "twitter"]
    source_code: "https://github.com/covanalytics/CovData-Dashboards.git"
    self_contained: false
    favicon: favicon.SEAL.ico
    includes:
      in_header: GA_Script.html
---

<style>                     
.navbar {
  background-color:#46b5d2;
  border-color:black;
}
.navbar-brand {
font-weight: bold;
}

</style> 

```{r eval=TRUE, message=FALSE, warning=FALSE, cache = TRUE}

library(flexdashboard)
library(plyr)
library(tidyverse)
library(lubridate)
library(ggpubr)
library(plotly)
theme_set(theme_pubr())


#Load Audited Revenues and Expenses from ACFRs
rev_exp <- read.csv("total_rev_exp.csv")

rev_exp_longer <- rev_exp %>%
  pivot_longer(!FY, names_to = "Type", values_to = "Amount")%>%
  mutate(Amount_ = formatC(Amount, format = "d", big.mark = ","),
         `Fiscal Year` = substr(FY, start = 3, stop = 4))


```

Dashboard {data-icon="fa-signal"}
===================================

Row
----------------------------------------------------------------------


### **Fiscal Year Total**

```{r  eval = TRUE, echo = FALSE, message = FALSE, warning=FALSE, cache=FALSE}

#Building Permit Counts
acfr_plot <- rev_exp_longer %>%
  
ggplot(aes(x=`Fiscal Year`, y = Amount, fill = Type, label = Amount_))+
  geom_bar(stat = 'identity', position = "dodge")+
  
  theme_bw()+
  scale_discrete_manual("fill", values = c('#52BE80', '#EC7063'), breaks=c("Revenue", "Expense"))+
  #scale_fill_manual(values=c('#A946D2','#D26346'), name = "")+
  #scale_x_continuous(breaks=rev_exp$FY)+
  scale_y_continuous(label=scales::label_number_si(),
                     expand = expansion(mult = c(0, .1)))+
  
  
  theme(legend.position = "right",
        legend.title = element_blank(),
        axis.title = element_blank(),
        panel.grid.major = element_line(colour = "#D4D2D3"))


ggplotly(acfr_plot, tooltip = c("label", "x"))%>%
  config(displayModeBar = F)%>%
  layout(legend = list(orientation = 'h'),
         xaxis=list(fixedrange=TRUE), yaxis=list(fixedrange=TRUE))


```

> **Debt service and capital outlay are not included in expenses**

Description
===================================

Column
-------------------------------------------------------------------

### **Annual Comprehensive Financial Report (ACFR)** 


This ACFR is intended to provide informative and relevant financial data to the residents of the City, the City Commission, investors, creditors and any other interested reader. It includes all statements and disclosures necessary for the reader to obtain a thorough understanding of the City’s financial activities. 

State law requires that all general-purpose local governments publish within six months of the close of each FY a complete set of financial statements presented in conformity with generally accepted accounting principles (GAAP) in accordance with the implementation of Governmental Accounting Standards Board (GASB) Statement 34, and audited in accordance with generally accepted auditing standards by an independent firm of licensed certified public accountants.

**The dashboard displays current revenues and expenses from the Statement of Revenues, Expenditures and Changes in Fund Balances for all governmental funds. Debt service and capital outlay expenses are not included.**



