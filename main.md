---
title: "Risk ratio regression - simple concept and simple computation"
author: "Frank Popham (frank.popham@protonmail.com)"
date: "2023-02-17"
output:
  html_document:
    df_print: paged
    keep_md: yes
csl: ije.csl
bibliography: references.bib
---



Dear Editors,

A new IJE paper states in its title that "Risk ratio regression - simple concept yet complex computation" [@mittinty2022]. This is only true if one wants to read the risk ratio directly from the coefficients of your model. Given a binary outcome and binary exposure as in the aforementioned paper, a logistic regression is the "natural" choice. While its coefficients will be (log) odds ratios, it is simple to derive a number of other effect measures including the risk ratio. This can be done easily using modern software such as R ([see accompanying code](https://github.com/frankpopham/rr/blob/master/main.R)).

In the paper under discussion the risk of weight gain relative to quitting smoking or not was studied. Using standardization (g formula) [@hernan2020], I easily estimate a risk ratio. The three stage method is simple,

Stage 1) fit the model of outcome by exposure and confounders using a logistic regression model.

Stage 2) from this model predict for each person the probability of the outcome treating everyone as exposed (E) and then everyone as not exposed (NE) (everyone quit or no-one quit in our example).

Stage 3) Average these probabilities for each of the two scenarios. We can then compare these two average predictions to obtain an absolute difference (E-NE), the risk ratio (E/NE), or the odds ratio (E/(1-E)) / (NE/(1-NE)). See Table 1.

The first stage retains the advantages of a logistic model for a binary exposure in that the model usually converges and predicted probabilities will be in the range of 0 to 1. The second and third stage avoid non-collapsibility as we predict probabilities (collapsible) rather than odds (non-collapsible) before averaging across the strata from the stage 1 model.




```{=html}
<div id="ptrzilpxik" style="padding-left:0px;padding-right:0px;padding-top:10px;padding-bottom:10px;overflow-x:auto;overflow-y:auto;width:auto;height:auto;">
<style>html {
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, 'Helvetica Neue', 'Fira Sans', 'Droid Sans', Arial, sans-serif;
}

#ptrzilpxik .gt_table {
  display: table;
  border-collapse: collapse;
  margin-left: auto;
  margin-right: auto;
  color: #333333;
  font-size: 16px;
  font-weight: normal;
  font-style: normal;
  background-color: #FFFFFF;
  width: auto;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #A8A8A8;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #A8A8A8;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
}

#ptrzilpxik .gt_heading {
  background-color: #FFFFFF;
  text-align: center;
  border-bottom-color: #FFFFFF;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#ptrzilpxik .gt_caption {
  padding-top: 4px;
  padding-bottom: 4px;
}

#ptrzilpxik .gt_title {
  color: #333333;
  font-size: 125%;
  font-weight: initial;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-color: #FFFFFF;
  border-bottom-width: 0;
}

#ptrzilpxik .gt_subtitle {
  color: #333333;
  font-size: 85%;
  font-weight: initial;
  padding-top: 0;
  padding-bottom: 6px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-color: #FFFFFF;
  border-top-width: 0;
}

#ptrzilpxik .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#ptrzilpxik .gt_col_headings {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#ptrzilpxik .gt_col_heading {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 6px;
  padding-left: 5px;
  padding-right: 5px;
  overflow-x: hidden;
}

#ptrzilpxik .gt_column_spanner_outer {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  padding-top: 0;
  padding-bottom: 0;
  padding-left: 4px;
  padding-right: 4px;
}

#ptrzilpxik .gt_column_spanner_outer:first-child {
  padding-left: 0;
}

#ptrzilpxik .gt_column_spanner_outer:last-child {
  padding-right: 0;
}

#ptrzilpxik .gt_column_spanner {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 5px;
  overflow-x: hidden;
  display: inline-block;
  width: 100%;
}

#ptrzilpxik .gt_group_heading {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  text-align: left;
}

#ptrzilpxik .gt_empty_group_heading {
  padding: 0.5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: middle;
}

#ptrzilpxik .gt_from_md > :first-child {
  margin-top: 0;
}

#ptrzilpxik .gt_from_md > :last-child {
  margin-bottom: 0;
}

#ptrzilpxik .gt_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  margin: 10px;
  border-top-style: solid;
  border-top-width: 1px;
  border-top-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  overflow-x: hidden;
}

#ptrzilpxik .gt_stub {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
}

#ptrzilpxik .gt_stub_row_group {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
  vertical-align: top;
}

#ptrzilpxik .gt_row_group_first td {
  border-top-width: 2px;
}

#ptrzilpxik .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#ptrzilpxik .gt_first_summary_row {
  border-top-style: solid;
  border-top-color: #D3D3D3;
}

#ptrzilpxik .gt_first_summary_row.thick {
  border-top-width: 2px;
}

#ptrzilpxik .gt_last_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#ptrzilpxik .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#ptrzilpxik .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}

#ptrzilpxik .gt_striped {
  background-color: rgba(128, 128, 128, 0.05);
}

#ptrzilpxik .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#ptrzilpxik .gt_footnotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#ptrzilpxik .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding-left: 4px;
  padding-right: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#ptrzilpxik .gt_sourcenotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#ptrzilpxik .gt_sourcenote {
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}

#ptrzilpxik .gt_left {
  text-align: left;
}

#ptrzilpxik .gt_center {
  text-align: center;
}

#ptrzilpxik .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}

#ptrzilpxik .gt_font_normal {
  font-weight: normal;
}

#ptrzilpxik .gt_font_bold {
  font-weight: bold;
}

#ptrzilpxik .gt_font_italic {
  font-style: italic;
}

#ptrzilpxik .gt_super {
  font-size: 65%;
}

#ptrzilpxik .gt_footnote_marks {
  font-style: italic;
  font-weight: normal;
  font-size: 75%;
  vertical-align: 0.4em;
}

#ptrzilpxik .gt_asterisk {
  font-size: 100%;
  vertical-align: 0;
}

#ptrzilpxik .gt_indent_1 {
  text-indent: 5px;
}

#ptrzilpxik .gt_indent_2 {
  text-indent: 10px;
}

#ptrzilpxik .gt_indent_3 {
  text-indent: 15px;
}

#ptrzilpxik .gt_indent_4 {
  text-indent: 20px;
}

#ptrzilpxik .gt_indent_5 {
  text-indent: 25px;
}
</style>
<table class="gt_table">
  <thead class="gt_header">
    <tr>
      <td colspan="5" class="gt_heading gt_title gt_font_normal gt_bottom_border" style>Table 1  - Losing weight by quitting smoking</td>
    </tr>
    
  </thead>
  <thead class="gt_col_headings">
    <tr>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" scope="col" id=""></th>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="1" colspan="1" scope="col" id="Quit smoking">Quit smoking</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="Estimate">Estimate</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="95% CI - low">95% CI - low</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="95% CI - high">95% CI - high</th>
    </tr>
  </thead>
  <tbody class="gt_table_body">
    <tr><th id="stub_1_1" scope="row" class="gt_row gt_left gt_stub">Absolute</th>
<td headers="stub_1_1 qsmk" class="gt_row gt_left">No</td>
<td headers="stub_1_1 estimate" class="gt_row gt_right">46.4%</td>
<td headers="stub_1_1 conf.low" class="gt_row gt_right">43.5%</td>
<td headers="stub_1_1 conf.high" class="gt_row gt_right">49.2%</td></tr>
    <tr><th id="stub_1_2" scope="row" class="gt_row gt_left gt_stub">Absolute</th>
<td headers="stub_1_2 qsmk" class="gt_row gt_left">Yes</td>
<td headers="stub_1_2 estimate" class="gt_row gt_right">60.7%</td>
<td headers="stub_1_2 conf.low" class="gt_row gt_right">55.9%</td>
<td headers="stub_1_2 conf.high" class="gt_row gt_right">65.5%</td></tr>
    <tr><th id="stub_1_3" scope="row" class="gt_row gt_left gt_stub">Difference</th>
<td headers="stub_1_3 qsmk" class="gt_row gt_left">Yes-No</td>
<td headers="stub_1_3 estimate" class="gt_row gt_right">14.3%</td>
<td headers="stub_1_3 conf.low" class="gt_row gt_right">8.7%</td>
<td headers="stub_1_3 conf.high" class="gt_row gt_right">20.0%</td></tr>
    <tr><th id="stub_1_4" scope="row" class="gt_row gt_left gt_stub">Risk ratio</th>
<td headers="stub_1_4 qsmk" class="gt_row gt_left">Yes/No</td>
<td headers="stub_1_4 estimate" class="gt_row gt_right">1.31</td>
<td headers="stub_1_4 conf.low" class="gt_row gt_right">1.18</td>
<td headers="stub_1_4 conf.high" class="gt_row gt_right">1.45</td></tr>
    <tr><th id="stub_1_5" scope="row" class="gt_row gt_left gt_stub">Odds ratio</th>
<td headers="stub_1_5 qsmk" class="gt_row gt_left">(Yes/(100%-Yes)) / (No/(100%-No))</td>
<td headers="stub_1_5 estimate" class="gt_row gt_right">1.79</td>
<td headers="stub_1_5 conf.low" class="gt_row gt_right">1.42</td>
<td headers="stub_1_5 conf.high" class="gt_row gt_right">2.26</td></tr>
  </tbody>
  
  
</table>
</div>
```



It should be noted that the odds ratio from the stage 1 model (1.84) is not the same as in Table 1 as the former is a conditional odds ratio while the latter (and all effects in Table 1) are marginal. We can use standardization to obtain the odds ratio from the stage 1 model by predicting the log odds at stage 2 rather than the probability and modifying the calculations at stage 3 to work with log odds.

In conclusion a summary risk ratio is easily obtainable from a logistic regression. Being clear about whether we are reporting marginal and conditional estimates is another important consideration and authors should be explicit about the effect measure reported.

Best wishes,

Frank Popham

#### References
