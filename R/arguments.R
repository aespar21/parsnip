#' Functions required for parsnip-adjacent packages
#'
#' These functions are helpful when creating new packages that will register
#' new model specifications.
#' @export
#' @keywords internal
#' @rdname add_on_exports
#' @importFrom rlang expr enquos enquo quos is_quosure call2 quo_get_expr ll
#' @importFrom rlang abort current_env get_expr is_missing is_null is_symbolic  missing_arg
null_value <- function(x) {
  if (is_quosure(x)) {
    res <- isTRUE(all.equal(rlang::get_expr(x), expr(NULL)))
  } else {
    res <- isTRUE(all.equal(x, NULL))
  }
  res
}

check_eng_args <- function(args, obj, core_args) {
  # Make sure that we are not trying to modify an argument that
  # is explicitly protected in the method metadata or arg_key
  protected_args <- unique(c(obj$protect, core_args))
  common_args <- intersect(protected_args, names(args))
  if (length(common_args) > 0) {
    args <- args[!(names(args) %in% common_args)]
    common_args <- paste0(common_args, collapse = ", ")
    rlang::warn(glue::glue("The following arguments cannot be manually modified",
                           "and were removed: {common_args}."))
  }
  args
}

#' Change elements of a model specification
#'
#' `set_args()` can be used to modify the arguments of a model specification while
#'  `set_mode()` is used to change the model's mode.
#'
#' @param object A model specification.
#' @param ... One or more named model arguments.
#' @param mode A character string for the model type (e.g. "classification" or
#'  "regression")
#' @return An updated model object.
#' @details `set_args()` will replace existing values of the arguments.
#'
#' @examples
#' rand_forest()
#'
#' rand_forest() %>%
#'   set_args(mtry = 3, importance = TRUE) %>%
#'   set_mode("regression")
#'
#' @export
set_args <- function(object, ...) {
  the_dots <- enquos(...)
  if (length(the_dots) == 0)
    rlang::abort("Please pass at least one named argument.")
  main_args <- names(object$args)
  new_args <- names(the_dots)
  for (i in new_args) {
    if (any(main_args == i)) {
      object$args[[i]] <- the_dots[[i]]
    } else {
      object$eng_args[[i]] <- the_dots[[i]]
    }
  }
  new_model_spec(
    cls = class(object)[1],
    args = object$args,
    eng_args = object$eng_args,
    mode = object$mode,
    method = NULL,
    engine = object$engine
  )
}

#' @rdname set_args
#' @export
set_mode <- function(object, mode) {
  if (is.null(mode))
    return(object)
  mode <- mode[1]
  if (!(any(all_modes == mode))) {
    rlang::abort(
      glue::glue(
        "`mode` should be one of ",
        glue::glue_collapse(glue::glue("'{all_modes}'"), sep = ", ")
      )
    )
  }
  object$mode <- mode
  object
}

# ------------------------------------------------------------------------------

#' @importFrom rlang eval_tidy
#' @importFrom purrr map
maybe_eval <- function(x) {
  # if descriptors are in `x`, eval fails
  y <- try(rlang::eval_tidy(x), silent = TRUE)
  if (inherits(y, "try-error"))
    y <- x
  y
}

#' Evaluate parsnip model arguments
#' @export
#' @keywords internal
#' @param spec A model specification
#' @param ... Not used.
eval_args <- function(spec, ...) {
  spec$args   <- purrr::map(spec$args,   maybe_eval)
  spec$eng_args <- purrr::map(spec$eng_args, maybe_eval)
  spec
}
