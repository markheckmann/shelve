

# extract string til end of prefix path
str_including_prefix <- function(x) {
  stringr::str_extract(x, paste0(".+", .opt_prefix()))
}

# extract string after prefix path
str_after_prefix <- function(x) {
  stringr::str_extract(x, paste0("(?<=", .opt_prefix(), "/).*"))
}
