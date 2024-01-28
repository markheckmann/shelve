# Function factory (decorator) to optionally silence function call
add_silent_option <- function(fun) {
  function(..., silent = NULL) {
    silent <- ifelse(is.null(silent), .opt_silent(), silent)
    if (!silent) {
      fun(...)
    }
    return(invisible(NULL))
  }
}

# replacement of cli functions with same name but can be muted
.cli_alert_info <- add_silent_option(cli::cli_alert_info)
.cli_alert_warning <- add_silent_option(cli::cli_alert_warning)
.cli_alert_danger <- add_silent_option(cli::cli_alert_danger)
.cli_alert_success <- add_silent_option(cli::cli_alert_success)
.cli_bullets <- add_silent_option(cli::cli_bullets)
