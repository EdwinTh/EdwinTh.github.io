

filenamise <- function (x, sep_char = "_", ext = "")
{
  paste0(gsub(paste0(sep_char, "$|^", sep_char), "", gsub(paste0(sep_char,

                                                                 "+"), sep_char, gsub("[[:space:]]|[[:punct:]]", sep_char,
                                                                                      tolower(x)))), ext)}
# kudos to Brendan Rocks who built this function
# https://github.com/brendan-r/brocks/blob/master/R/blog_stuff.R
# copied it to adjust it to my own taste

new_post <- function (title = "new post",
          serve = TRUE,
          dir = "_source",
          subdir = TRUE,
          skeleton_file = ".skeleton_post")
  library(brocks)
{
  if (!dir.exists(dir)) {
    stop("The directory '", dir, "' doesn't exist. Are you running R in\n         the right directory?")
  }
  fname <- filenamise(title, sep_char = "-")
  if (subdir) {
    fpath <- file.path(dir, fname)
    dir.create(fpath)
  }
  else {
    fpath <- dir
  }

  rmd_name <- file.path(fpath,
                        paste0(Sys.Date(), "-", fname, ".Rmd"))

  if (!file.exists(skeleton_file)) {
    message("File .skeleton_post does not exist. Using package default")
    skeleton_file <- system.file("skeleton_post.Rmd", package = "brocks")
  }

  post <- c(
    "---",
    "layout: post",
    "categories: blog",
    paste('title:', title),
    "date: \"`r Sys.time()`\"",
    "---"
  )

  writeLines(post, rmd_name)
  sys_open(rmd_name)
  if (serve)
    blog_serve()
}

run_jekyll <- function() {
  servr::jekyll(dir = "/Users/edwinthoen/Documents/Site",
                input   =  c(".", list.dirs("_source")),
                output  =  c(".", rep("_posts/blog", length(list.dirs("_source")))),
                command = 'bundle exec jekyll build')
}

new_post("tmp")

