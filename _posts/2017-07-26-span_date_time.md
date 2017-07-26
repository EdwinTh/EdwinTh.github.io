---
layout: post
categories: blog
title: "Span Dates and Times without Overhead"
base-url: https://EdwinTh.github.io
date: "2017-07-26 19:00:00"
output: html_document
tags: [padr, seq.Date, seq.POSIXt, date span, time span]
---

I am working on v.0.4.0 of the [padr package](https://cran.r-project.org/web/packages/padr/vignettes/padr.html) this summer. Two new features that will be added are wrappers around `seq.Date` and `seq.POSIXt`. Since it is going to take a while before the new release is on CRAN, I go ahead and do an early presentation of these functions. Date and datetime parsing in base R are powerful and comprehensive, but also tedious. They can slow you down in your programming or analysis. Luckily, good wrappers and alternatives exist, at least the `ymd{_h}{m}{s}` suite from [lubridate](https://cran.r-project.org/web/packages/lubridate/vignettes/lubridate.html) and Dirk Eddelbuettel's [anytime](https://cran.r-project.org/web/packages/anytime/README.html). These functions remove much of the overhead of date and datetime parsing, allowing for quick formatting of vectors in all kinds of formats. They also alleviate the pain of using `seq.Date()` and `seq.POSIXt` a little, because the `from` and the `to` arguments should be parsed dates or datetimes. Take the following example.


```r
seq(as.POSIXct("2017-07-25 00:00:00"), as.POSIXct("2017-07-25 03:00:00"), by = "hour")
```

```
## [1] "2017-07-25 00:00:00 CEST" "2017-07-25 01:00:00 CEST"
## [3] "2017-07-25 02:00:00 CEST" "2017-07-25 03:00:00 CEST"
```

```r
library(lubridate)
seq(ymd_h("20170725 00"), ymd_h("20170725 03"), by = "hour")
```

```
## [1] "2017-07-25 00:00:00 UTC" "2017-07-25 01:00:00 UTC"
## [3] "2017-07-25 02:00:00 UTC" "2017-07-25 03:00:00 UTC"
```

I think, however, that there is still some overhead in the second specification. By overhead I mean specifying things that feel redundant, things that could be set to some kind of default. Since the whole idea behind `padr` is automating away redundant and tedious actions in preparing datetime data, providing alternative functions that ask for as little as possible are a natural addition. This resulted in `span_date` and `span_time`. They remove overhead by:

* allowing for specification of `from` and `to` directly as integer or character in *lubridatish* format. 

* setting the unspecified datetime parts to a default of 1 for month and day, and 0 for hour, minute, and second.

* assuming the desired interval (the `by` statement in `seq.Date` and `seq.POSIXt`) as the lowest of the datetime parts specified in either `from` or `two`.

If this is a little abstract still, let me give some examples. The above becomes example becomes:

```r
devtools::install_github("EdwinTh/padr") # download the dev version
library(padr)
span_time("20170725 00", "20170725 03")
```

```
## [1] "2017-07-25 00:00:00 UTC" "2017-07-25 01:00:00 UTC"
## [3] "2017-07-25 02:00:00 UTC" "2017-07-25 03:00:00 UTC"
```
We can simplify this even further, specifying the 00 for the hour in `from` is not strictly necesarry. Since the hour is specified in `to` already the `interval` will remain hour if we omit it.


```r
span_time("20170725", "20170725 03")
```

```
## [1] "2017-07-25 00:00:00 UTC" "2017-07-25 01:00:00 UTC"
## [3] "2017-07-25 02:00:00 UTC" "2017-07-25 03:00:00 UTC"
```
We can even use an integer instead of a character for `from`. When there are no time parts involved, a character is not necesarry. Since we use it in `span_time` it will be parsed to `POSIXct`, not to `Date`.


```r
span_time(20170725, "20170725 03")
```

```
## [1] "2017-07-25 00:00:00 UTC" "2017-07-25 01:00:00 UTC"
## [3] "2017-07-25 02:00:00 UTC" "2017-07-25 03:00:00 UTC"
```

`to` does not have to be specified, we can use `len_out` instead. The `interval` is derived only from `from` then. To get Jan 1st, from 2010 to 2014 we can do both

```r
span_date(2010, 2014)
```

```
## [1] "2010-01-01" "2011-01-01" "2012-01-01" "2013-01-01" "2014-01-01"
```
and 

```r
span_date(2010, len_out = 5)
```

```
## [1] "2010-01-01" "2011-01-01" "2012-01-01" "2013-01-01" "2014-01-01"
```

If you want the `interval` to be different from the default, you can specify it.


```r
span_date(2016, 2017, interval = "month")
```

```
##  [1] "2016-01-01" "2016-02-01" "2016-03-01" "2016-04-01" "2016-05-01"
##  [6] "2016-06-01" "2016-07-01" "2016-08-01" "2016-09-01" "2016-10-01"
## [11] "2016-11-01" "2016-12-01" "2017-01-01"
```

Note however, that you can often also specify the `interval` by providing more information in `from` or `to`.

```r
span_date(201601, 2017)
```

```
##  [1] "2016-01-01" "2016-02-01" "2016-03-01" "2016-04-01" "2016-05-01"
##  [6] "2016-06-01" "2016-07-01" "2016-08-01" "2016-09-01" "2016-10-01"
## [11] "2016-11-01" "2016-12-01" "2017-01-01"
```

I hope you find these little wrappers around `seq.Date` and `seq.POSIXt` useful and that they will enable you to conquer dates and datetimes a little quicker. You can obtain the function by downloading the dev version of `padr` as I did above. If you can think of improvements of the functions before it hits CRAN please tell me. Issues filed, pull requests, emails, and tweets are much appreciated.
