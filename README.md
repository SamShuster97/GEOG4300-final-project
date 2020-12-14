---
title: "Geog4/6300: Final project"
output: github_document
---

```{r message=FALSE, warning=FALSE}
library(tidyverse)
library(sf)
```

## Introduction

For this final project, you will analyze data on dollar stores in Chicago to analyze the relationship between demographic variables and proximity to a dollar store location. This project is fairly similar to your final lab, and it asks you to make use of the skills you've developed in this course.

## The dataset

The dataset for your final provides multiple variables for tracts in the Chicago metropolitan area. These include the following:

* totpop: Total population
* areakm: Area in square kilometers
* popdens: People per 100 sq. km.
* white_pct: % of people classified White, non-Hispanic
* afam_pct: % of people classified African-American, non-Hispanic
* asian_pct: % of people classified Asian-American, non-Hispanic
* hisp_pct: % of people classified Hispanic/Latino
* pov_pct: % of people with household incomes below poverty level
* medinc: Median household income
* spmkt_dist: Distance to the nearest SNAP-authorized supermarket
* allstore_dist: Distance to the closest dollar store (any chain) in m
* dg_dist: Distance to the closest Dollar General in m
* dt_dist: Distance to the closest Dollar Tree in m
* fd_dist: Distance to the closest Family Dollar in m

You can load the data from your repo using the following command:

```{r message=FALSE}
chi_data<-st_read("data/geog4300_dollarstoredata.gpkg", quiet=TRUE) %>%
  rename(geometry=geom)
```

## Your assignment
For this assignment, you will need to select four variables: *one* measure of proximity to dollar stores (allstore_dist through fd_dist) and *three* additional variables you believe might be associated with that dependent variable (population density, for example). Just as in your last lab, you should use descriptive statistics to understand the characteristics of each variable and then use regression to assess their association. You'll need to explain your decisions throughout this process. Specific questions can be found on the assignment response template, which is what you'll use to complete the assignment.

## Grading

* Variables and research question (5 points): 4 Your analysis can't answer this research question--we have no data on why DT opens stores in an area. We can ask if these stores are associated with certain demographics, though. Might also want to consider if % Af-Am and % White might be correlated or related.
* Descriptive statistics (10 points): 8 Not sure why you're including the linear models here. There's already a lot, and this makes it harder to read. It's also not clear why you say there's no connection to race based on these data.
* Inferential statistics (10 points): 8 No discussion of results here. Also missing map of residuals.
* Discussion (5 points): 5. I'd agree that there's not a strong model using these variables. Tells you something but low R2 is important.

Total (out of 30 points): 25
