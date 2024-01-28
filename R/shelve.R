
# shelve ------------------------------------------------


#' Add to shelf
#' @param x Object to add to shelf.
#' @param name Name of obejcts to get from shelf.
#' @param shelf Name of shelf.
#' @export
shelve <- function(x, name, shelf = shelf_active()) {
  path <- file.path(shelf_path(), name)
  qs::qsave(x, path)
}


#' Get from shelf
#' @param name Name of obejcts to get from shelf.
#' @param shelf Name of shelf.
#' @export
unshelve <- function(name, shelf = shelf_active()) {
  path <- file.path(shelf_path(), name)
  qs::qread(path)
}


#' Delete objects from active shelf
#'
#' @param x List of object names
#' @param shelf Name of shelf
#' @param ignore_not_found Ignore objects which do not exist.
#' @export
#'
delete <- function(x, shelf = shelf_active(), ignore_not_found = TRUE) {
  if (!length(x)) {
    cli::cli_alert_warning("No object names provided. Nothing deleted.")
    return(invisible())
  }
  if (ignore_not_found) {
    not_found <- setdiff(x, shelf_files())
    cli::cli_alert_warning("Ignoring: {not_found}")
    x <- intersect(x, shelf_files())
  }
  name_not_found <- setdiff(x, shelf_files())
  if (length(name_not_found)) {
    cli::cli_abort("Some names were not found: {name_not_found}")
  }
  .h$delete(x)
}



# shelf ------------------------------------------------


#' Name of active shelf
#' @export
shelf_active <- function() {
  get_current_shelf()
}


#' Activate shelf
#'
#' Shelf is created if it does not exist
#' @param name Name of shelf. Creates one with the name if it does not exist.
#' @export
shelf_activate <- function(name) {
  set_current_shelf(name, create = TRUE)
}


#' List files in shelf
#'
#' @param shelf Name of shelf. If `NULL, the active shelf is used.
#' @param full_names (bool) Full file path?
#' @export
shelf_files <- function(shelf = NULL, full_names = FALSE) {
  if (is.null(shelf)) {
    shelf <- shelf_active()
  }
  .h <- get_hoard()
  paths <- .h$files() |> lapply("[[", "path") |> unlist()
  if (is.null(paths)) {
    return(NULL)
  }
  if (!full_names) {
    paths <- basename(paths)
  }
  paths
}


#' Details of files in active shelf
#' @param name Name of shelf.
shelf_details <- function(name = NULL) {
  if (is.null(name)) {
    name <- get_current_shelf()
  }
  .h <- get_hoard()
  .h$details()
}


#' List names of all shelves
#' @export
shelf_list <- function() {
  list.dirs(get_top_level_dir(), full.names = FALSE, recursive = FALSE)
}


#' Path to shelf folder
#' @export
shelf_path <- function() {
  .h <- get_hoard()
  .h$cache_path_get()
}


#' Remove complete shelf
#'
#' Removes shelf and all its files
#'
#' @param name Name of shelf.
#' @export
shelf_remove <- function(name) {
  if (!name %in% shelf_list()) {
    cli::cli_abort("Shelf '{name}' does not exist. See `shelf_list()`")
  }
  dir_path <- file.path(get_top_level_dir(), name)
  dir_exists <- fs::dir_exists(dir_path)
  delete_active <- shelf_active() == name

  if (!dir_exists) {
    cli::cli_alert_danger("shelf '{name}' does not exist. Nothing is deleted")
    return(invisible(FALSE))
  }
  fs::dir_delete(dir_path)
  cli::cli_alert_success("shelf '{name}' was deleted.")
  if (delete_active) {
    shelf_activate(get_default_shelf_name())
    cli::cli_alert_info("Deleted the active shelf. Active shelf is now '{shelf_active()}'")
  }
  invisible(TRUE)
}


#' Delete all objects in shelf
#'
#' Deleta all shelf objects but keep shelf itself.
#' @param name Name of shelf.
#' @export
shelf_clear <- function(name = shelf_active()) {
  if (!name %in% shelf_list()) {
    cli::cli_abort("Shelf '{name}' does not exist. See `shelf_list()`")
  }
  dir_path <- file.path(get_top_level_dir(), name)
  dir_exists <- fs::dir_exists(dir_path)
  if (!dir_exists) {
    cli::cli_alert_danger("shelf '{name}' does not exist. Nothing is deleted")
    return(invisible(FALSE))
  }
  paths <- fs::dir_ls(dir_path)
  fs::file_delete(paths)
  cli::cli_alert_success("shelf '{name}' was cleared.")
  invisible(TRUE)
}
