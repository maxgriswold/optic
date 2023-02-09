
<!-- README.md is generated from README.Rmd. Please edit that file -->

# optic <a href='https://optic-tools.github.io/optic/'><img src='man/figures/optic.png' align="right" height="139"  style="height:139px !important;" /></a>

**Simulation test-bed for Longitudinal Causal Inference models**

<!-- badges: start -->

[![R-CMD-check](https://github.com/optic-tools/optic/workflows/R-CMD-check/badge.svg)](https://github.com/optic-tools/optic/actions)
[![Test
Coverage](https://github.com/optic-tools/optic/workflows/test-coverage/badge.svg)](https://github.com/optic-tools/optic/actions)
[![codecov](https://codecov.io/gh/optic-tools/optic/branch/develop/graph/badge.svg?token=5XYDOFFJMH)](https://codecov.io/gh/optic-tools/optic)
[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
[![R-CMD-check](https://github.com/optic-tools/optic/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/optic-tools/optic/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

The `optic` package helps you scrutinize candidate causal inference
models using **your own** longitudinal data.

The recent Diff-in-Diff literature revealed issues with the traditional
Diff-in-Diff model, but we found it very difficult to evaluate the
relative performance of different causal inference methods using *our
own data*. Thus, we designed a series of simulations to study the
performance of various methods under different scenarios. Our
publications to date include:

1.  Using real-world data on opioid mortality rates, [we found notable
    limitations of commonly used statistical models for
    Difference-In-Differences (DID) designs, which are widely used in
    state policy evaluations. In contrast, the optimal model we
    identified–the autoregressive model (AR) model- showed a lot of
    promise.](https://bmcmedresmethodol.biomedcentral.com/articles/10.1186/s12874-021-01471-y),
    but don’t just take our word for it - try it our with your own data
    and see how various approaches do relative to each other.

2.  [It is also critical to be able to control for effects of
    co-occurring policies, and understand the potential bias that might
    arise from not controlling for those
    policies.](https://link.springer.com/article/10.1007/s10742-022-00284-w)
    Our package can also help you assess the impact of co-occurring
    policies on the performance of commonly-used statistical models in
    state policy evaluations.

You can now use our `optic` R package to simulate policy effects and
compare causal inference models using your own data.

The package supports the traditional two-way fixed effects DID model and
the AR model as well as other leading methods like augment synthetic
control and the Callaway-Santa’Anna approach to DID.

### Why `optic`?

`optic` is named after the **Opioid Policy Tools and Information Center
(OPTIC)** project which provide funding for this effort.

## Installation

You can install `optic` like so:

``` r
# install optic from cran (in the future)
install.packages("optic")

# install from github:
remotes::install_github("optic-tools/optic")
```

## Usage

`optic` provides two main workhorse functions: `optic_model` and
`optic_simulation`. Use `optic_model` to define model specifications for
each causal model to be tested in the simulation experiment. Then, pass
your models, your data, and parameters to the `optic_simulation`
function, that specifies a set of simulations to be performed for each
`optic_model` specified.

``` r
library(optic)
## basic example code

# overdose example data provided with the package:
data(overdoses)
x <- overdoses

#testing a scenario with two co-occuring policies

model_1 <- optic_model(
         name="fixedeff_linear",
         type="reg",
         call="lm",
         formula=crude.rate ~ unemploymentrate + as.factor(year) + as.factor(state) + treatment1_level + treatment2_level,
         args=list(weights=as.name('population')),
         se_adjust=c("none", "cluster"))

model_2 <- optic_model(name="autoreg_linear",
              type="autoreg",
              call="lm",
              formula=deaths ~ unemploymentrate + as.factor(year) + treatment1_change + treatment2_change,
              args=list(weights=as.name('population')),
              se_adjust=c("none", "cluster"))


# we will define two scenarios for different effect magnitudes for
# the policies using 5, 10, and 15 percent changes in the outcome
linear5 <- 690 / ((sum(x$population) / length(unique(x$year))) / 100000)
linear10 <- 1380 / ((sum(x$population) / length(unique(x$year))) / 100000)
linear15 <- 2070 / ((sum(x$population) / length(unique(x$year))) / 100000)

scenario1 <- c(linear10, linear10)
scenario2 <- c(linear5, linear15)

optic_sim <- optic_simulation(
  x=overdoses,
  models=list(model_1, model_2),
  iters=10,
  # method_type = c("concurrent", "confounding", "standard?")
  # By choosing this method, all the parameters below would be set.
  method_sample=concurrent_sample,
  method_pre_model=concurrent_premodel,
  method_model=concurrent_model,
  method_post_model=concurrent_postmodel,
  method_results=concurrent_results,
  
  # Look into de-nest this and construct it back within the optic_simulation function.
  params=list(
    unit_var="state",
    time_var="year",
    effect_magnitude=list(scenario1, scenario2),
    n_units=c(30),
    effect_direction=c("null", "neg"),
    policy_speed=c("instant", "slow"),
    n_implementation_periods=c(3),
    rhos=c(0, 0.25, 0.5, 0.75, 0.9),
    years_apart=2,
    ordered=TRUE
  )
)
```

After those steps, run `simulate()` on your `optic_simulation` object.
Doing so will run your simulations in parallel.

``` r
results <- simulate(
  optic_sim,
  use_future=TRUE,
  seed=9782,
  verbose=2,
  future.globals=c("cluster_adjust_se"),
  future.packages=c("dplyr", "optic")
)
```

Max: Explain what the user can do with this result.

## Contact

Reach out to [Beth Ann
Griffin](https://www.rand.org/about/people/g/griffin_beth_ann.html) for
questions related to this repository.

# Automated Tests

This package contains `thestthat` tests in the tests package.

## License

Copyright (C) 2023 by The [RAND Corporation](https://www.rand.org). This
repository is released as open-source software under a GPL-3.0 license.
See the LICENSE file.
