
run_jekyll <- function() {
  servr::jekyll(dir = '/Users/edwinthoen/Documents/Site',
                input = '_source',
                output = '_posts',
                # serve = TRUE,
                command = 'bundle exec jekyll build')
}

run_jekyll()
