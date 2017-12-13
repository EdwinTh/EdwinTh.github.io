---
layout: post
categories: blog
title: "Color palettes derived from the Dutch masters"
base-url: https://EdwinTh.github.io
date: "2017-12-13 18:33:00"
output: html_document
tags: [R, ggplot2, color palette, Dutch masters]
---

Among tulip fields, canals and sampling cheese and Eastern European prostitutes, 
the museums of the Netherlands are one of its biggest tourist attractions. And 
for very good reasons! During the seventeenth century, known as the Dutch Golden 
Age, there was an abundance of talented painters. If you ever have
the chance to visit the Rijksmuseum you will be in awe by the landscapes,
households and portraits, painted with incredible detail and beautiful colors.

## The `dutchmasters` color palette

Rembrandt van Rijn and Johannes Vermeer are the most famous of the seventeenth
century Dutch masters. Both are renowned for their use of light and color,
making encounters with their subjects feel as being in the room with them.
Recently, during the OzUnconference, the beautiful [`ochRe` package](https://github.com/ropenscilabs/ochRe/) was 
developed. This package contains color palettes of the wonderful Australian 
landscape (which my wife got to witness during our honeymoon last 
year). Drawing colors from both works of art and photographs of Australia. 
I shamelessly stole both the idea and package structure of `ochRe` to create [`dutchmasters`](
https://github.com/EdwinTh/dutchmasters). This package contains six color 
palettes derived from my six favourites by Van Rijn and Vermeer.

Vermeer's paintings are renowned for their vivid and light colors. The package
offers palettes from Vermeer's [*The Milkmaid*](https://en.wikipedia.org/wiki/The_Milkmaid_(Vermeer)),
[*Girl with a Pearl Earring*](https://en.wikipedia.org/wiki/Girl_with_a_Pearl_Earring),
[*View of Delft*](https://en.wikipedia.org/wiki/View_of_Delft), and
[*The Little Street*](https://en.wikipedia.org/wiki/The_Little_Street).
Rembrandt's paintings on the other hand are more atmospheric, with a lot of dark
colors and subjects that stare you right into the soul. From him you find 
palettes derived from the [*The Anatomy Lesson of Dr. Nicolaes Tulp*](https://en.wikipedia.org/wiki/The_Anatomy_Lesson_of_Dr._Nicolaes_Tulp) 
and  [*The "Staalmeesters"*](https://en.wikipedia.org/wiki/Syndics_of_the_Drapers%27_Guild).

Like `ochRe`, the package comprises a list with the color palettes. I have added
names to each of the color codes, reflecting the color it represents and moreover
where on the painting the color was taken from. As mentioned, I shamelessly 
converted the functions from `ochRe` into `dutchmasters` functions. Why invent 
something that smarter people already figured out?

## Using the package

Grab the package from github with `devtools::install_github("EdwinTh/dutchmasters")`.
Make sure to install `ochRe` right away for the handy `viz_palette` function,
with `devtools::install_github("ropenscilabs/ochRe/")`.

This is what the palette "milkmaid" looks like.


```r
library(dutchmasters)
ochRe::viz_palette(dutchmasters[["milkmaid"]])
```

![plot of chunk unnamed-chunk-1](/figure/source/2017-12-13-dutch-masters/unnamed-chunk-1-1.png)

Now to put those beautiful Vermeer shades into action on a ggplot.


```r
library(ggplot2)
ggplot(diamonds, aes(color, fill = clarity)) +
  geom_bar() +
  scale_fill_dutchmasters(palette = "milkmaid")
```

![plot of chunk unnamed-chunk-2](/figure/source/2017-12-13-dutch-masters/unnamed-chunk-2-1.png)

Or maybe the dark "staalmeesters" colors?


```r
ggplot(diamonds, aes(color, fill = clarity)) +
  geom_bar() +
  scale_fill_dutchmasters(palette = "staalmeesters")
```

![plot of chunk unnamed-chunk-3](/figure/source/2017-12-13-dutch-masters/unnamed-chunk-3-1.png)

I leave the other four palettes for you to explore. In the future I will 
certainly add more paintings, as the well of the Dutch masters seems bottomless.

A big thanks to the `ochRe` team, for inspiration and groundwork. I hope that 
this package motivates you to further explore the wonderful art of the Dutch
Golden Age.
