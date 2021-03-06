% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/mars.R
\name{mars}
\alias{mars}
\alias{update.mars}
\title{General Interface for MARS}
\usage{
mars(
  mode = "unknown",
  num_terms = NULL,
  prod_degree = NULL,
  prune_method = NULL
)

\method{update}{mars}(
  object,
  parameters = NULL,
  num_terms = NULL,
  prod_degree = NULL,
  prune_method = NULL,
  fresh = FALSE,
  ...
)
}
\arguments{
\item{mode}{A single character string for the type of model.
Possible values for this model are "unknown", "regression", or
"classification".}

\item{num_terms}{The number of features that will be retained in the
final model, including the intercept.}

\item{prod_degree}{The highest possible interaction degree.}

\item{prune_method}{The pruning method.}

\item{object}{A MARS model specification.}

\item{parameters}{A 1-row tibble or named list with \emph{main}
parameters to update. If the individual arguments are used,
these will supersede the values in \code{parameters}. Also, using
engine arguments in this object will result in an error.}

\item{fresh}{A logical for whether the arguments should be
modified in-place of or replaced wholesale.}

\item{...}{Not used for \code{update()}.}
}
\description{
\code{mars()} is a way to generate a \emph{specification} of a model before
fitting and allows the model to be created using R. The main
arguments for the
model are:
\itemize{
\item \code{num_terms}: The number of features that will be retained in the
final model.
\item \code{prod_degree}: The highest possible degree of interaction between
features. A value of 1 indicates and additive model while a value of 2
allows, but does not guarantee, two-way interactions between features.
\item \code{prune_method}: The type of pruning. Possible values are listed
in \code{?earth}.
}
These arguments are converted to their specific names at the
time that the model is fit. Other options and argument can be
set using \code{set_engine()}. If left to their defaults
here (\code{NULL}), the values are taken from the underlying model
functions. If parameters need to be modified, \code{update()} can be used
in lieu of recreating the object from scratch.
}
\details{
The model can be created using the \code{fit()} function using the
following \emph{engines}:
\itemize{
\item \pkg{R}:  \code{"earth"}  (the default)
}
}
\section{Engine Details}{


The standardized parameter names in parsnip can be mapped to their original
names in each engine:\tabular{ll}{
   \strong{parsnip} \tab \strong{earth} \cr
   num_terms \tab nprune \cr
   prod_degree \tab degree \cr
   prune_method \tab pmethod \cr
}


Engines may have pre-set default arguments when executing the
model fit call.  For this type of
model, the template of the fit calls are:

\pkg{earth} classification

\Sexpr[results=rd]{parsnip:::show_fit(parsnip:::mars(mode = "classification"), "earth")}

\pkg{earth} regression

\Sexpr[results=rd]{parsnip:::show_fit(parsnip:::mars(mode = "regression"), "earth")}

Note that, when the model is fit, the \pkg{earth} package only has its
namespace loaded. However, if \code{multi_predict} is used, the package is
attached.
}

\examples{
mars(mode = "regression", num_terms = 5)
model <- mars(num_terms = 10, prune_method = "none")
model
update(model, num_terms = 1)
update(model, num_terms = 1, fresh = TRUE)
}
\seealso{
\code{\link[=fit]{fit()}}
}
