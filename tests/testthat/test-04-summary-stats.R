context("Time Series Summary Statistics")



test_that("uni_ts_summary works", {
    ts <- sunspot.year
    ts[c(1, 5, 10:14)] <- NA
    expect_message(uni_ts_summary(ts), "`time` is `NULL`, assuming evenly spaced data")
    expect_message(uni_ts_summary(ts), "`effort` is `NULL`, assuming all effort = 1")
    expect_error(output <- uni_ts_summary(ts), NA)
    expect_equal(length(output), 4)
    expect_true(all(c("observations", "times", "effort", "autocorrelation") %in% names(output)))
    expect_known_hash(output, "1775f77efd")
})

test_that("summarize_obs works", {
    ts <- sunspot.year
    ts[c(1, 5, 10:14)] <- NA
    expect_error(output <- summarize_obs(ts), NA)
    expect_equal(length(output), 6)
    expect_true(all(c("min", "max", "median", "mean", "sd", "n") %in% names(output)))
    expect_false(any(is.na(output)))
    expect_known_hash(output, "411990ec5b")
})

test_that("summarize_times works", {
    ts <- sunspot.year
    ts[c(1, 5, 10:14)] <- NA
    expect_error(output <- summarize_times(ts, time(ts)), NA)
    expect_equal(length(output), 6)
    expect_true(all(c("min", "max", "median", "mean", "sd", "n") %in% names(output)))
    expect_false(any(is.na(output)))
    expect_known_hash(output, "e4c2870ac1")
})

test_that("summarize_effort works", {
    ts <- sunspot.year
    ts[c(1, 5, 10:14)] <- NA
    expect_error(output <- summarize_effort(ts, rep(1, NROW(ts))), NA)
    expect_equal(length(output), 6)
    expect_true(all(c("min", "max", "median", "mean", "sd", "n") %in% names(output)))
    expect_false(any(is.na(output)))
    expect_known_hash(output, "9904b7b022")
})

test_that("temp_autocor works", {
    ts <- sunspot.year
    ts[c(1, 5, 10:14)] <- NA
    expect_error(output <- temp_autocor(ts, time(sunspot.year)), NA)
    expect_equal(length(output), 25)
    expect_false(any(is.na(output)))
    expect_known_hash(output, "5842a3ef0f")
})

test_that("interpolate_obs works", {
    ts <- sunspot.year
    ts[c(1, 5, 10:14)] <- NA
    expect_error(output <- interpolate_obs(ts, time(sunspot.year)), NA)
    expect_identical(length(output), length(ts))
    expect_false(any(is.na(output)))
    expect_known_hash(output, "0bd2cccc8e")
})

test_that("check_obs works", {
    expect_error(check_obs(NULL))
    expect_error(check_obs(mtcars))
    expect_error(check_obs(matrix(rnorm(16), nrow = 4)))
    expect_error(check_obs(matrix(rnorm(16), nrow = 4), single_dim_obs = FALSE), NA)
    expect_error(check_obs(c(NA, rnorm(16))), NA)
})

test_that("check_times works", {
    expect_error(check_times(NULL))
    expect_error(check_times(mtcars))
    expect_error(check_times(time(sunspot.year)), NA)
    expect_error(check_times(c(NA, time(sunspot.year))), NA)
    expect_error(check_times(rnorm(16)), NA)
    expect_error(check_times(c(NA, rnorm(16))), NA)
})

test_that("check_obs_and_times works", {
    expect_error(check_obs_and_times(rnorm(16), rnorm(15)))
    expect_error(check_obs_and_times(sunspot.year, time(sunspot.year)), NA)
})