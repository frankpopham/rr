## ----setup, include=FALSE--------------------------------------------------------------------------------------------------------
knitr::opts_chunk$set(echo = TRUE)

# Software versions
# Rstudio version 2023.03.0+386 "Cherry Blossom" Release (3c53477afb13ab959aeb5b34df1f10c237b256c3, 2023-03-09) for Ubuntu Jammy
# R version 4.3.0 (2023-04-21) -- "Already Tomorrow"

# Packages via cran

library(tidyverse) # version 2.0.0
library(marginaleffects) # version 0.11.1
library(gt) # version 0.9.0
library(naniar) # version 1.0.0
library(glue) # version 1.6.2


## ----dataset, include=FALSE------------------------------------------------------------------------------------------------------
# code source
# https://oup.silverchair-cdn.com/oup/backfile/Content_public/
# Journal/ije/PAP/10.1093_ije_dyac220/2/dyac220_supplementary_data.doc
# Note there was a small typo on line nd<subset that should be nd<-subset
# rewriiten in tidyverse here


Nd <- url("https://cdn1.sph.harvard.edu/wp-content/uploads/sites/1268/1268/20/nhefs.csv")
nd <- read.csv(Nd)

# binary income, marital status binary, weight binary
nd <- nd %>%
  mutate(
    incomeb = as.factor(if_else(income > 15, "High", "Low")),
    maritalb = as.factor(if_else(marital > 2, "Not married", "Married")),
    wtb = if_else(wt82_71 > median(wt82_71, na.rm = TRUE), 1, 0)
  )

# reduce number variables in nd
nd <- nd %>%
  select(qsmk, wtb, exercise, sex, age, race, incomeb, maritalb, school, asthma, bronch)

# sort out labels

nd <- nd %>%
  mutate(
    exercise = as.factor(case_when(
      exercise == 0 ~ "Much exercise",
      exercise == 1 ~ "Moderate exercise",
      exercise == 2 ~ "Little or no exercise"
    )),
    sex = as.factor(if_else(sex == 0, "Male", "Female")),
    race = as.factor(if_else(race == 0, "White", "Black or other")),
    asthma = as.factor(if_else(asthma == 1, "Ever", "Never")),
    bronch = as.factor(if_else(bronch == 1, "Ever", "Never"))
  )


## ----standardisation, echo=FALSE-------------------------------------------------------------------------------------------------
# complete cases as missing

nd_miss <- vis_miss(nd)

nd <- nd %>%
  filter(complete.cases(.))

# model
model1 <- glm(wtb ~ qsmk + exercise + sex + age + race + incomeb + maritalb + school + asthma + bronch,
  data = nd,
  family = binomial(link = "logit")
)

# counterfactual prediction

m_stand_abs <- avg_predictions(model1, type = "response", by = "qsmk", newdata = datagrid("qsmk" = 0:1, grid_type = "counterfactual"))

m_stand_dif <- avg_comparisons(model1, type = "response", variables = "qsmk", newdata = datagrid(qsmk = 0:1, grid_type = "counterfactual"))

m_stand_rr <- avg_comparisons(model1, type = "response", variables = "qsmk", newdata = datagrid(qsmk = 0:1, grid_type = "counterfactual"), transform_pre = "lnratioavg", transform_post = "exp")

m_stand_or <- avg_comparisons(model1, type = "response", variables = "qsmk", newdata = datagrid(qsmk = 0:1, grid_type = "counterfactual"), transform_pre = "lnoravg", transform_post = "exp")

table1 <- bind_rows(
  "Absolute" = m_stand_abs, "Difference" = m_stand_dif, "Risk ratio" = m_stand_rr,
  "Odds ratio" = m_stand_or, .id = "Effect"
) %>%
  select(Effect, qsmk, estimate, conf.low, conf.high) %>%
  mutate(qsmk = c("No", "Yes", "Yes-No", "Yes/No", "(Yes/(100%-Yes)) / (No/(100%-No))")) %>%
  mutate(across(starts_with("conf"), ~ ifelse(.x < 1, round(.x * 100, 1), round(.x, 2)))) %>%
  mutate(CI = glue("({conf.low} - {conf.high})")) %>%
  select(-conf.low, -conf.high)

gt(table1, rowname_col = "Effect") %>%
  cols_label(
    qsmk = "Quit smoking",
    estimate = "Estimate"
  ) %>%
  fmt_number(
    columns = 3:4,
    rows = 1:3,
    scale_by = 100,
    decimals = 1,
    pattern = "{x}%"
  ) %>%
  fmt_number(
    columns = 3:4,
    rows = 4:5,
    decimals = 2
  ) %>%
  tab_header(title = "Table 1  - Losing weight by quitting smoking") %>%
  tab_footnote(
    footnote = "CI, confidence interval.",
    locations = cells_column_labels(
      columns = CI
    )
  )


## ----conditional, include=FALSE--------------------------------------------------------------------------------------------------
# same OR (cis slightly different)
c_stand_or <- avg_comparisons(model1, type = "link", variables = "qsmk", newdata = datagrid(qsmk = 0:1, grid_type = "counterfactual"), transform_post = "exp")

