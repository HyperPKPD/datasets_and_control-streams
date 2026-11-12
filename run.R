# =============================================================================
# run.R
#
# Purpose : Generate the population PK benchmark projects listed in
#           projects.md. The script reads the 100 `nlmx generate` commands
#           from projects.md and runs them one by one, in order, from the
#           simplest project to the most complex. Each project is written to
#           its own folder under projects/. A project whose folder already
#           exists is skipped, so the script can be stopped and started
#           again. The console output of every command is kept in logs/,
#           and a summary of all runs is written to run_summary.csv.
#
# Author  : Obinna Obianom
# Date    : 2026-11-11
#
# Requires: R (base R only, no packages) and the nlmx executable, either on
#           the PATH or given with the NLMX environment variable, e.g.
#             Windows : set NLMX=C:\path\to\nlmx.exe
#             macOS/Linux : export NLMX=/path/to/nlmx
#
# Usage   : from the benchmarks folder
#             Rscript run.R              # all 100 projects
#             Rscript run.R 1 5 12       # only projects 001, 005 and 012
#             Rscript run.R 90:100       # a range of projects
#           or open run.R in RStudio and click Source.
# =============================================================================


# ---- Settings ---------------------------------------------------------------

projects_file <- "projects.md"   # where the commands are listed
skip_existing <- TRUE            # skip a project whose folder already exists
stop_on_error <- FALSE           # TRUE: stop at the first command that fails
show_output   <- FALSE           # TRUE: print nlmx's own progress as it runs
log_dir       <- "logs"          # one log file per project
summary_file  <- "run_summary.csv"


# ---- Work in the folder of this script --------------------------------------

script_dir <- function() {
  file_arg <- grep("^--file=", commandArgs(trailingOnly = FALSE), value = TRUE)
  if (length(file_arg) == 1) {                       # Rscript run.R
    path <- gsub("~+~", " ", sub("^--file=", "", file_arg), fixed = TRUE)  # Rscript writes spaces as ~+~
    return(dirname(normalizePath(path)))
  }
  for (i in rev(seq_len(sys.nframe()))) {            # source("run.R")
    ofile <- sys.frame(i)$ofile
    if (!is.null(ofile)) return(dirname(normalizePath(ofile)))
  }
  getwd()                                            # pasted into the console
}
setwd(script_dir())
if (!file.exists(projects_file)) {
  stop("Cannot find ", projects_file, " in ", getwd(),
       ". Run this script from the benchmarks folder.", call. = FALSE)
}


# ---- Find the nlmx executable -----------------------------------------------

find_nlmx <- function() {
  candidates <- c(
    Sys.getenv("NLMX", ""),
    Sys.which("nlmx"),
    file.path("..", "target", "release",
              if (.Platform$OS.type == "windows") "nlmx.exe" else "nlmx")
  )
  for (path in candidates) {
    if (nzchar(path) && file.exists(path)) return(normalizePath(path))
  }
  stop("nlmx was not found. Put it on the PATH, or set the NLMX environment ",
       "variable to the full path of the executable.", call. = FALSE)
}
nlmx <- find_nlmx()


# ---- Read the commands from projects.md -------------------------------------

lines    <- readLines(projects_file, encoding = "UTF-8", warn = FALSE)
commands <- grep("^nlmx generate ", lines, value = TRUE)
outputs  <- sub("^.*--output (\\S+).*$", "\\1", commands)
projects <- basename(outputs)
numbers  <- as.integer(substr(projects, 1, 3))

if (length(commands) == 0) {
  stop("No `nlmx generate` command was found in ", projects_file, call. = FALSE)
}
if (anyDuplicated(outputs)) {
  stop("Two commands in ", projects_file, " share an output folder.", call. = FALSE)
}


# ---- Which projects to run --------------------------------------------------

# Optional arguments: project numbers, e.g. `Rscript run.R 1 5 12` or `90:100`.
args <- commandArgs(trailingOnly = TRUE)
if (length(args) > 0) {
  wanted <- unlist(lapply(args, function(a) eval(parse(text = a))))
  unknown <- setdiff(wanted, numbers)
  if (length(unknown) > 0) {
    stop("No project with number ", paste(unknown, collapse = ", "),
         " in ", projects_file, call. = FALSE)
  }
  selected <- which(numbers %in% wanted)
} else {
  selected <- seq_along(commands)
}


# ---- Run the commands one by one --------------------------------------------

dir.create("projects", showWarnings = FALSE)
dir.create(log_dir, showWarnings = FALSE)

cat("nlmx      :", nlmx, "\n")
cat("projects  :", length(selected), "of", length(commands), "in", projects_file, "\n")
cat("started   :", format(Sys.time(), "%Y-%m-%d %H:%M:%S"), "\n\n")

results <- data.frame(project = projects[selected], status = NA_character_,
                      exit_code = NA_integer_, seconds = NA_real_,
                      stringsAsFactors = FALSE)
started_all <- Sys.time()

for (k in seq_along(selected)) {
  i        <- selected[k]
  label    <- sprintf("[%3d/%d] %s", k, length(selected), projects[i])
  log_file <- file.path(log_dir, paste0(projects[i], ".log"))

  if (skip_existing && dir.exists(outputs[i])) {
    cat(label, "... skipped (folder exists)\n")
    results$status[k] <- "skipped"
    next
  }

  cat(label, "... ")
  flush.console()
  arguments <- sub("^nlmx ", "", commands[i])     # everything after `nlmx`
  started   <- Sys.time()
  exit_code <- if (show_output) {
    system2(nlmx, args = arguments)
  } else {
    system2(nlmx, args = arguments, stdout = log_file, stderr = log_file)
  }
  seconds <- round(as.numeric(difftime(Sys.time(), started, units = "secs")), 1)

  ok <- identical(as.integer(exit_code), 0L)
  results$status[k]    <- if (ok) "ok" else "FAILED"
  results$exit_code[k] <- as.integer(exit_code)
  results$seconds[k]   <- seconds
  cat(if (ok) "ok" else sprintf("FAILED (exit code %d)", as.integer(exit_code)),
      sprintf("in %.1f s\n", seconds))

  if (!ok && stop_on_error) {
    cat("\nStopped at the first failure. The command was:\n", commands[i], "\n")
    break
  }
}


# ---- Summary ----------------------------------------------------------------

write.csv(results, summary_file, row.names = FALSE)
minutes <- as.numeric(difftime(Sys.time(), started_all, units = "mins"))
counts  <- table(factor(results$status, levels = c("ok", "skipped", "FAILED")))

cat("\nfinished  :", format(Sys.time(), "%Y-%m-%d %H:%M:%S"),
    sprintf("(%.1f min)\n", minutes))
cat("generated :", counts[["ok"]], "  skipped:", counts[["skipped"]],
    "  failed:", counts[["FAILED"]], "\n")
cat("summary   :", file.path(getwd(), summary_file), "\n")

failed <- results$project[results$status %in% "FAILED"]
if (length(failed) > 0) {
  cat("\nFailed projects (see their log in ", log_dir, "/):\n  ",
      paste(failed, collapse = "\n  "), "\n", sep = "")
  if (!interactive()) quit(status = 1)
}
