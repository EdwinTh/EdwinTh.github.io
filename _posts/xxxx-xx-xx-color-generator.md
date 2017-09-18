---
layout: post
categories: blog
title: "Tidy evaluation, most common actions"
base-url: https://EdwinTh.github.io
date: ""
output: html_document
tags: [R, color function]
---

Creating graphics in the colors of your company of organization might get your work to be accepted more quickly, even when they are for internal use only. Often organizations have custom power point templates and standards for other documents. The more native your plots look, the easier they are embraced by business people. 

Here is the skeleton for a color producing function, that you can apply to create a vector of company colors. I have been using this function for a while now. When using it for the [rstatscoffeegeeks](https://github.com/RMHogervorst/coffeegeeks) too, I realised it could be easily portable to every other setting. All you have to do is replace the data frame with color name and hex codes, by your organization's specifics.


```r
my_cols <- function(...) {
    col_ints <- input_to_ints(...)
    get_cols_data_frame()$hex_code[col_ints]
}


input_to_ints <- function(...) {
    dots_list <- substitute(list(...))
    col_vec   <- sapply(dots_list[2:length(dots_list)], deparse)
    color_df  <- get_cols_data_frame()
    sapply(col_vec, char_to_int, color_df)
}

char_to_int <- function(col_vec_el, col_df) {
    lookup_list <- rep(seq_len(nrow(col_df)), 2)
    names(lookup_list) <- c(as.character(col_df$color_int), col_df$color_name)
    if (!col_vec_el %in% names(lookup_list)) {
        stop("Invalid color name or color number", call. = FALSE)
    }
    lookup_list[col_vec_el]
}

get_cols_data_frame <- function() {
    data.frame(
        color_name = c("red",
                       "blue"),
        hex_code   = 
```

```
## Error: <text>:28:0: unexpected end of input
## 26:                        "blue"),
## 27:         hex_code   = 
##    ^
```

