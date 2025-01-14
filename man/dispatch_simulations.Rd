% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/dispatch-simulations.R
\name{dispatch_simulations}
\alias{dispatch_simulations}
\title{Execute simulations defined in a optic_simulation object}
\usage{
dispatch_simulations(object, seed = NULL, use_future = FALSE, verbose = 0, ...)
}
\arguments{
\item{object}{Simulation scenarios object created using optic_simulation}

\item{seed}{Specified as either NULL or a numeric. Sets a seed, which is becomes an index in results, for
each indepdendent set of simulations in optic_simulation.}

\item{use_future}{Runs simulation scenarios in parallel. Default FALSE, set to TRUE if you have already setup a future
plan (e.g., multiprocess, cluster, etc) and would like for the iterations to
be run in parallel.}

\item{verbose}{Default TRUE. IF TRUE, provides details on what's currently running.}

\item{...}{additional parameters to be passed to future_apply. User can pass future.globals and future.packages if your code relies on additrional packages}
}
\description{
Execute simulations defined in a optic_simulation object
}
