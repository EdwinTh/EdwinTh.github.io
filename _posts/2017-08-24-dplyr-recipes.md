---
layout: post
categories: blog
title: "Tidy evaluation, most common actions"
base-url: https://EdwinTh.github.io
date: "2017-08-25 20:30:00"
output: html_document
tags: [R, dplyr, tidy evaluation, programming]
---

Tidy evaluation is a bit challenging to get your head around. Even after reading [programming with dplyr](https://cran.r-project.org/web/packages/dplyr/vignettes/programming.html) several times, I still struggle when creating functions from time to time. I made a small summary of the most common actions I perform, so I don't have to dig in the vignettes and on stackoverflow over and over. Each is accompanied with a minimal example on how to implement it. I thought others might find this useful too, so here it is in a blog post. This list is meant to be a living thing so additions and improvements are most welcome. Please do a PR on [this file](https://github.com/EdwinTh/EdwinTh.github.io/tree/master/_source/2017-08-24-dplyr-recipes.Rmd) or send an email.


```r
library(tidyverse)
```
#### bare to quosure: `quo`

```r
bare_to_quo <- function(x, var){
  x %>% select(!!var) %>% head(1)
}
bare_to_quo(mtcars, quo(cyl))
```

```
##           cyl
## Mazda RX4   6
```

#### bare to quosure in function: `enquo`

```r
bare_to_quo_in_func <- function(x, var) {
  var_enq <- enquo(var)
  x %>% select(!!var_enq) %>% head(1)
}
bare_to_quo_in_func(mtcars, mpg)
```

```
##           mpg
## Mazda RX4  21
```

#### quosure to a name: `quo_name`

```r
bare_to_name <- function(x, nm) {
  nm_name <- quo_name(nm)
  x %>% mutate(!!nm_name := 42) %>% head(1) %>% 
    select(!!nm)
}
bare_to_name(mtcars, quo(this_is_42))
```

```
##   this_is_42
## 1         42
```

#### quosure to text: `quo_text`

```r
quo_to_text <- function(x, var) {
  var_enq <- enquo(var)
  glue::glue("The following column was selected: {rlang::quo_text(var_enq)}")
}
quo_to_text(mtcars, cyl)
```

```
## The following column was selected: cyl
```

#### character to name: `sym` (edited)


```r
char_to_quo <- function(x, var) {
  var_enq <- rlang::sym(var)
  x %>% select(!!var_enq) %>% head(1)
}
char_to_quo(mtcars, "vs")
```

```
##           vs
## Mazda RX4  0
```

#### multiple bares to quosure: `quos`

```r
bare_to_quo_mult <- function(x, ...) {
  grouping <- quos(...)
  x %>% group_by(!!!grouping) %>% summarise(nr = n())
}
bare_to_quo_mult(mtcars, vs, cyl)
```

```
## # A tibble: 5 x 3
## # Groups:   vs [?]
##      vs   cyl    nr
##   <dbl> <dbl> <int>
## 1     0     4     1
## 2     0     6     3
## 3     0     8    14
## 4     1     4    10
## 5     1     6     4
```

#### multiple characters to names: `syms` (edited)

```r
bare_to_quo_mult_chars <- function(x, ...) {
  grouping <- rlang::syms(...)
  x %>% group_by(!!!grouping) %>% summarise(nr = n())
}
bare_to_quo_mult_chars(mtcars, list("vs", "cyl"))
```

```
## # A tibble: 5 x 3
## # Groups:   vs [?]
##      vs   cyl    nr
##   <dbl> <dbl> <int>
## 1     0     4     1
## 2     0     6     3
## 3     0     8    14
## 4     1     4    10
## 5     1     6     4
```

#### quoting full expression

Although quoting column names is most often used, it is by no means the only option. We can use the above to quote full expressions.


```r
filter_func <- function(x, filter_exp) {
  filter_exp_enq <- enquo(filter_exp)
  x %>% filter(!!filter_exp_enq)
}
filter_func(mtcars, hp == 93)
```

```
##    mpg cyl disp hp drat   wt  qsec vs am gear carb
## 1 22.8   4  108 93 3.85 2.32 18.61  1  1    4    1
```

#### quoting full expression in a character: parse_expr


```r
filter_by_char <- function(x, char) {
  func_call <- rlang::parse_expr(char)
  x %>% filter(!!func_call)
}
filter_by_char(mtcars, "cyl == 6") %>% head(1)
```

```
##   mpg cyl disp  hp drat   wt  qsec vs am gear carb
## 1  21   6  160 110  3.9 2.62 16.46  0  1    4    4
```

#### Edit notes

1) I mistakingly thought that `rlang::sym(s)` created quosures. However, as pointed out to me by a reader, this creates a `name`, not a `quosure`. A `name` however can also be unquoted. See this [github discussion](https://github.com/tidyverse/rlang/issues/116).


```r
just_a_name <- rlang::sym("cyl")
class(just_a_name)
```

```
## [1] "name"
```

```r
mtcars %>% select(!!just_a_name) %>% head(1)
```

```
##           cyl
## Mazda RX4   6
```

2) Quoting expressions in a character was added roughly a year after the first apperance of this blog.

3) The `quo_text` example used to be with `ggplot2`. However, since v.3.0.0 it supports tidy evaluation. Therefore, the example was changed and now it uses `glue`.
