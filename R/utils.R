
list1 <- function(x) {
  if (length(x) == 1) {
    list(x)
  } else {
    x
  }
}

drop_nulls <- function(x) {
  x[!vapply(x, is.null, FUN.VALUE = logical(1))]
}

