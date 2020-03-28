#' @name tcltklibs
#' @docType package
#'
#' @title Tcl/Tk Libraries and Widgets for R
#'
#' @description
#' \pkg{tcltklibs} is a package that contains Tcl/Tk libraries and widgets for R.
#'
NULL

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
pkg_env <- new.env()
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# Functions
.onLoad <- function(libname, pkgname) {
  if (!interactive()) {
    return()
  }
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # FIXME: remove this code when pkg `tcltk2` updates the version of tablelist.
  old_tablelist <- system.file("tklibs/tablelist5.5", package = "tcltk2")
  if (dir.exists(old_tablelist)) {
    unlink(old_tablelist)
  }

  new_tablelist_from <- system.file("tklibs/tablelist6.8", package = "tcltklibs")
  new_tablelist_to   <- fs::path(system.file(package = "tcltk2"), "tklibs/tablelist6.8")
  if (!dir.exists(new_tablelist_to)) {
    fs::dir_copy(new_tablelist_from, new_tablelist_to)
  }

  # Tcl/Tk path --------------------------------------------------------------
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  libdir <- file.path(libname, pkgname, "tklibs")
  add_tcl_path(libdir)
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  # Add paths of Tcl/Tk packages
  bs_add_tcl_path("tklibs")

  # bs_add_tcl_path("etc/tcl-tk/wcb3.6")
  # bs_add_tcl_path("etc/tcl-tk/scrollutil1.3")
  # bs_add_tcl_path("etc/tcl-tk/tablelist6.8")
  # bs_add_tcl_path("etc/tcl-tk/mentry3.10")
  # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

}


# ============================================================================

## A modified version of tcltk2::addTclPath()
add_tcl_path <- function(path = ".") {
  if (.Platform$OS.type == "windows") {
    path <- gsub("\\\\", "/", path)
  }
  paths <- as.character(tcltk::tcl("set", "::auto_path"))
  if (!path %in% paths) {
    tcltk::tcl("lappend", "::auto_path", path)
  }
}

# Add Tcl path of directory of installed R package
bs_add_tcl_path <- function(path, package = "tcltklibs") {
  add_tcl_path(system.file(path, package = package))
}


# ============================================================================
state.tk2widget <- function(x, ...) {
  as.character(tcltk::tkcget(x, "-state", ...))
}

print.tk2widget <- function(x, ...) {

  if (tcltk2::disabled(x)) {txt <- " (disabled)"} else {txt <- ""}
  cat("A tk2widget of class '", class(x)[1], "'", txt, "\n", sep = "")
  cat("State: ", tcltk2::state(x), "\n", sep = "")
  cursize <- tcltk2::size(x)
  if (cursize > 0) {cat("Size: ", cursize, "\n", sep = "")}
  val <- tcltk2::value(x)
  if (!is.null(val)) {
    cat("Value:\n")
    print(tcltk2::value(x))
  }
  return(invisible(x))
}
# ============================================================================
