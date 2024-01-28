globalVariables(".h")

.onLoad <- function(lib, pkg) {
  options(
    shelve.path_prefix = "R/shelve",
    shelve.default_shelf = get_default_shelf_name(),
    shelve.silent = FALSE
  )

  # init default shelf
  h <- get_hoard()
  h$cache_path_set(.opt_default(), prefix = .opt_prefix())
  h$mkdir()
  set_current_shelf(.opt_default())
}

# convenience wrapper to get prefix path
.opt_prefix <- function() {
  options()$shelve.path_prefix
}

# convenience wrapper to get default shelf name
.opt_default <- function() {
  options()$shelve.default_shelf
}

.opt_silent <- function() {
  options()$shelve.silent
}


# we use hoardr to manage the locations of shelved objects
# each shelf has a its base folder in 'R/shelve' or in a temp dir
# the current shelf id matches the name of the folder in the base folder,
# e.g. R/shelve/shelf_001
.shelve_env <- rlang::env(
  hoard = hoardr::hoard()
)

# there is only one hoard object to manage all shelves
get_hoard <- function() {
  .shelve_env$hoard
}

# default shelf is 'username'. If not found it is 'default'
get_default_shelf_name <- function() {
  tryCatch(
    {
      Sys.info()[["user"]]
    },
    error = function(e) {
      "default"
    }
  )
}

get_current_shelf <- function() {
  .h <- get_hoard()
  .h$path
}

# track current shelf and set in set path in hoard object
set_current_shelf <- function(name, create = TRUE) {
  .h <- get_hoard()
  path <- .h$cache_path_set(name, prefix = .opt_prefix())
  if (create) {
    .h$mkdir()
  }
}


# get dir with all shelf folders from shelf path
get_top_level_dir <- function() {
  str_including_prefix(shelf_path())
}

