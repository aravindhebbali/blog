# Report: Draft `olsrr` 0.7.1 Revival Blog Post

**Branch:** `task/olsrr-071-post`  
**Date drafted:** 2026-11-19  
**Status:** Draft only — awaiting Aravind's review and approval before publishing.

---

## 1. Files Added

| Path | Purpose | Rendered by Quarto? |
|---|---|---|
| `posts/olsrr-0-7-1/index.qmd` | Draft revival post for `olsrr` 0.7.1 (`execute: freeze: auto`) | Yes (`_site/posts/olsrr-0-7-1/index.html`) |
| `_freeze/posts/olsrr-0-7-1/index/execute-results/html.json` | Frozen execution cache for zero-R Netlify builds | Consumed by Quarto |
| `_freeze/posts/olsrr-0-7-1/index/figure-html/diag-grid-1.png` | 10-panel diagnostic grid figure (`864px` display width, `153,781` bytes) | Asset |
| `_freeze/posts/olsrr-0-7-1/index/figure-html/resid-hist-1.png` | Synchronized residual histogram + normal curve (`672px` display width, `17,699` bytes) | Asset |
| `_freeze/posts/olsrr-0-7-1/index/figure-html/cpr-plot-1.png` | Single-predictor component-plus-residual plot (`652px` display width, `18,856` bytes) | Asset |
| `REPORT-olsrr-post.md` | Verification report at repo root (excluded by `_quarto.yml` `render: ["*.qmd", "posts"]` and `index.qmd` `listing: contents: posts`) | No |

---

## 2. Provenance of Every Number in the Post

### Package Environments Used

- **After (`olsrr` 0.7.1 from CRAN, published 2026-11-18):**
  ```r
  .libPaths(c("C:/Users/DELL/AppData/Local/Temp/olsrr-cran-lib", .libPaths()))
  stopifnot(packageVersion("olsrr") == "0.7.1")
  library(olsrr)
  ```
- **Before (`olsrr` 0.7.0 from CRAN archive):**
  ```r
  lib070 <- "C:/Users/DELL/AppData/Local/Temp/olsrr-070-post-lib"
  remotes::install_version("olsrr", version = "0.7.0", lib = lib070,
                           repos = "https://cloud.r-project.org", upgrade = "never")
  .libPaths(c(lib070, .libPaths()))
  stopifnot(packageVersion("olsrr") == "0.7.0")
  library(olsrr)
  ```

---

### A. What's New Since 2019

1. **Stepwise Selection with Locked Predictors (`surgical` dataset)**
   - **Numbers in post & chunk output:**
     - Step 0 (`Base Model`, containing locked `age` + `alc_heavy`): `AIC = 795.956`, `SBC = 803.912`, `SBIC = 637.696`, `R2 = 0.17900`, `Adj. R2 = 0.14680`
     - Step 5 (`liver_test (-)` final step): `AIC = 732.339`, `SBC = 746.262`, `SBIC = 580.934`, `R2 = 0.77382`, `Adj. R2 = 0.75026`
     - Final model summary: `R = 0.880`, `R-Squared = 0.774`, `Adj. R-Squared = 0.750`, `Pred R-Squared = 0.688`, `MAE = 140.528`, `RMSE = 198.590`, `MSE = 39438.163`, `Coef. Var = 28.286`, `F = 32.844` (`DF = 5, 48`, `Sig. = 0.0000`)
     - Locked `age` parameter estimate in final model: `Beta = -1.787`, `Std. Error = 2.473`, `Std. Beta = -0.050`, `t = -0.723`, `Sig = 0.473` ($p = 0.473$)
   - **Code (run under `olsrr` 0.7.1):**
     ```r
     m_surg <- lm(
       y ~ bcs + pindex + enzyme_test + liver_test + age + gender + alc_mod + alc_heavy,
       data = surgical
     )
     ols_step_both_aic(m_surg, include = c("age", "alc_heavy"))
     ```

2. **Ten-Panel Diagnostic Grid (`mtcars`)**
   - **Numbers in post & figure (`diag-grid-1.png`):**
     - `10` panels returned by `ols_plot_diagnostics(model, print_plot = FALSE)` (arranged `5 × 2`; `ols_plot_diagnostics(model)` pages `2 × 2` via `marrangeGrob(..., nrow = 2, ncol = 2)`)
     - Plot annotations computed by `olsrr` 0.7.1: leverage threshold `0.312`, outlier threshold `2` (`abs(2)`), Cook's D threshold `0.125`
   - **Code (run under `olsrr` 0.7.1):**
     ```r
     model <- lm(mpg ~ disp + hp + wt + qsec, data = mtcars)
     panels <- ols_plot_diagnostics(model, print_plot = FALSE)
     length(panels) # 10
     gridExtra::grid.arrange(grobs = panels, ncol = 2, top = "Regression Diagnostics")
     ```

3. **Multi-Model Performance Comparison (`mtcars`)**
   - **Numbers in chunk output:**
     - `m1`: `r2 = 0.8267855`, `r2_adj = 0.8148396`, `r2_pred = 0.7810871`, `aic = 156.6523`, `sbc = 162.5153`, `sbic = 66.43956`, `rmse = 2.593412`, `sigma = 2.593412`
     - `m2`: `r2 = 0.8347678`, `r2_adj = 0.8170643`, `r2_pred = 0.7819955`, `aic = 157.1426`, `sbc = 164.4713`, `sbic = 67.43259`, `rmse = 2.577785`, `sigma = 2.577785`
     - `m3`: `r2 = 0.8351443`, `r2_adj = 0.8107212`, `r2_pred = 0.7710297`, `aic = 159.0696`, `sbc = 167.8640`, `sbic = 70.04081`, `rmse = 2.622095`, `sigma = 2.622095`
   - **Code (run under `olsrr` 0.7.1):**
     ```r
     m1 <- lm(mpg ~ wt + hp, data = mtcars)
     m2 <- lm(mpg ~ wt + hp + qsec, data = mtcars)
     m3 <- lm(mpg ~ wt + hp + qsec + disp, data = mtcars)
     ols_compare_model_performance(m1, m2, m3)
     ```

4. **Weighted Linear Regression (`ols_regress()`)**
   - **Numbers in chunk output:**
     - `R = 0.917`, `R-Squared = 0.841` (`0.8411941`), `Adj. R-Squared = 0.830` (`0.830242`), `Pred R-Squared = 0.786` (`0.7859224`), `MAE = 1.953`, `RMSE = 3.876` (`3.876405`, matching `summary(m_w1)$sigma`), `MSE = 15.027`, `Coef. Var = 19.295`, `AIC = 167.360`, `SBC = 173.223`, `F = 76.806` (`DF = 2, 29`, `Sig. = 0.0000`)
   - **Code (run under `olsrr` 0.7.1):**
     ```r
     d_wt <- mtcars
     d_wt$w <- seq_len(nrow(d_wt)) / 8
     m_w1 <- lm(mpg ~ wt + hp, data = d_wt, weights = w)
     ols_regress(m_w1)
     ```

---

### B. Fixes in 0.7.1 (Before = `0.7.0`, After = `0.7.1`)

1. **Fix 1 — Breusch-Pagan Test Holm Adjustment**
   - **Numbers in post & table:**
     - Chi-square statistics (`df = 1`): `x1 = 3.962893`, `x2 = 19.381555`, `x3 = 4.177610`; simultaneous `chi2 = 21.479644` (`df = 3`, `p = 8.369002e-05`)
     - Raw $p$-values (`p.adj = "none"`): `x1 = 0.0465` (`4.651371e-02`), `x2 = 1.07e-05` (`1.070359e-05`), `x3 = 0.0410` (`4.096142e-02`)
     - `olsrr` 0.7.0 Holm $p$-values: `x1 = 0.0465` (`4.651371e-02`), `x2 = 3.21e-05` (`3.211077e-05`), `x3 = 0.0819` (`8.192284e-02`)
     - `olsrr` 0.7.1 Holm $p$-values (and `stats::p.adjust(raw_p, "holm")`): `x1 = 0.0819` (`8.192284e-02`), `x2 = 3.21e-05` (`3.211077e-05`), `x3 = 0.0819` (`8.192284e-02`)
   - **Code (run in both `0.7.0` and `0.7.1`):**
     ```r
     set.seed(15)
     n <- 60
     z <- rnorm(n)
     d <- data.frame(x1 = z + rnorm(n), x2 = z + rnorm(n), x3 = z + rnorm(n))
     d$y <- rnorm(n) * exp(0.55 * z)
     m_bp <- lm(y ~ x1 + x2 + x3, data = d)

     ols_test_breusch_pagan(m_bp, rhs = TRUE, multiple = TRUE, p.adj = "none")
     ols_test_breusch_pagan(m_bp, rhs = TRUE, multiple = TRUE, p.adj = "holm")
     ```

2. **Fix 2 — Normality Test: Cramér–von Mises Reference Distribution**
   - **Numbers in post & table (`model <- lm(mpg ~ disp + hp + wt + qsec, data = mtcars)`):**
     - `olsrr` 0.7.0 Cramér–von Mises: `Statistic = 2.8122`, `pvalue = 0.0000`
     - `olsrr` 0.7.1 Cramér–von Mises: `Statistic = 0.0764` (`W = 0.076362`), `pvalue = 0.2230` (`0.223`)
     - Other rows in `ols_test_normality(model)`: Shapiro-Wilk `0.9366` (`p = 0.0600`), Kolmogorov-Smirnov `0.1152` (`p = 0.7464`), Anderson-Darling `0.5859` (`p = 0.1188`)
   - **Code (run in both `0.7.0` and `0.7.1`):**
     ```r
     model <- lm(mpg ~ disp + hp + wt + qsec, data = mtcars)
     ols_test_normality(model)
     nortest::cvm.test(residuals(model))
     ```

3. **Fix 3 — Weighted Predicted $R^2$ and Scale Invariance**
   - **Numbers in post & table:**
     - `olsrr` 0.7.0: `ols_press(m_w1) = 253.2827` (`253.282683`), `ols_press(m_w10) = 253.2827` (`253.282683`), `ols_pred_rsq(m_w1) = 0.9077` (`0.907697`), `ols_pred_rsq(m_w10) = 0.9908` (`0.990770`)
     - `olsrr` 0.7.1: `ols_press(m_w1) = 587.4367` (`587.436717`), `ols_press(m_w10) = 5874.3672` (`5874.367172`), `ols_pred_rsq(m_w1) = 0.7859` (`7.859224e-01`), `ols_pred_rsq(m_w10) = 0.7859` (`7.859224e-01`), `abs_diff = 2.220446e-16`
     - Base R leave-one-out weighted cross-validation reference: `wpress = 587.436717`, `1 - wpress / wtss = 0.785922`
   - **Code (run in both `0.7.0` and `0.7.1`):**
     ```r
     d_wt <- mtcars
     d_wt$w <- seq_len(nrow(d_wt)) / 8
     m_w1  <- lm(mpg ~ wt + hp, data = d_wt, weights = w)
     m_w10 <- lm(mpg ~ wt + hp, data = d_wt, weights = 10 * w)

     c(ols_press(m_w1), ols_press(m_w10), ols_pred_rsq(m_w1), ols_pred_rsq(m_w10))
     ```

4. **Fix 4 — Residual Histogram Normal Curve Scaling**
   - **Numbers in post, table, and alt text (`resid-hist-1.png`):**
     - `m_hwy <- lm(hwy ~ displ + cty + year, data = ggplot2::mpg)`:
       - `0.7.0`: drawn bar width `1.8459` (`1.845853`), max bar count `102`, normal curve peak `53.88` (`53.8787`), expected peak `99.45` (`99.4521`), height ratio `0.5418` (`0.541755`, i.e. `45.82%` / ~`46%` too low)
       - `0.7.1`: drawn bar width `2.0000` (breaks `-6` to `6`, bar counts `1, 29, 88, 91, 20, 5`), normal curve peak `107.7573` (~`108`), expected peak `107.7573`, height ratio `1.0000` (`1.000000`)
     - `m_mt3 <- lm(mpg ~ disp + hp + wt, data = mtcars)`:
       - `0.7.0`: bar width `1.950408`, curve peak `10.1776`, expected peak `9.9252`, height ratio `1.0254` (`1.025426`)
       - `0.7.1`: bar width `2.000000`, curve peak `10.1776`, expected peak `10.1776`, height ratio `1.0000` (`1.000000`)
   - **Code (run in both `0.7.0` and `0.7.1`):**
     ```r
     check_hist <- function(mod) {
       p <- ols_plot_resid_hist(mod, print_plot = FALSE)
       if (!inherits(p, "ggplot")) p <- p$plot
       b <- ggplot2::ggplot_build(p)
       bars <- b$data[[1]]
       curve_df <- b$data[[2]]
       w <- unique(round(bars$xmax - bars$xmin, 6))[1]
       r <- residuals(mod)
       exp_y <- dnorm(curve_df$x, mean(r), sd(r)) * length(r) * w
       c(bar_width = w, max_count = max(bars$count),
         max_curve = max(curve_df$y), exp_peak = max(exp_y),
         ratio = median(curve_df$y / exp_y))
     }
     check_hist(lm(hwy ~ displ + cty + year, data = ggplot2::mpg))
     check_hist(lm(mpg ~ disp + hp + wt, data = mtcars))
     ```

5. **Fix 5 — Component-Plus-Residual Plots on Single-Predictor and No-Intercept Models**
   - **Numbers in post, table, and alt text (`cpr-plot-1.png`):**
     - `lm(mpg ~ wt, data = mtcars)` (`wt` range `1.513` to `5.424`): `0.7.0` returned `1` plot with `1` row (`xlab = NA`); `0.7.1` returns `1` plot (`wt`) with `32` rows
     - `lm(mpg ~ 0 + wt + hp, data = mtcars)`: `0.7.0` returned `1` plot with `1` row (`hp` dropped); `0.7.1` returns `2` plots (`wt`, `hp`) with `32` rows each
   - **Code (run in both `0.7.0` and `0.7.1`):**
     ```r
     p_single <- ols_plot_comp_plus_resid(lm(mpg ~ wt, data = mtcars), print_plot = FALSE)
     c(n_plots = length(p_single), rows = vapply(p_single, function(g) nrow(g$data), integer(1)))

     p_noint <- ols_plot_comp_plus_resid(lm(mpg ~ 0 + wt + hp, data = mtcars), print_plot = FALSE)
     c(n_plots = length(p_noint), rows = vapply(p_noint, function(g) nrow(g$data), integer(1)))
     ```

6. **Fix 6 — Residual MSE/RMSE Denominator (`#221`) and Bonferroni Outlier Cap (`B7`)**
   - **Numbers in post & chunk output:**
     - `model <- lm(mpg ~ disp + hp + wt + qsec, data = mtcars)` ($n = 32$, $\text{df}_{\text{res}} = 27$):
       - `0.7.0`: `ols_regress(model)$mse = 5.8011` (`5.801104`), `ols_regress(model)$rmse = 2.4085` (`2.408548`)
       - `0.7.1`: `ols_regress(model)$mse = 6.8754` (`6.875382`), `ols_regress(model)$rmse = 2.6221` (`2.622095`, matching `summary(model)$sigma = 2.622095` and `deviance(model) / df.residual(model) = 6.875382`)
     - `d_sin <- data.frame(x = 1:50, y = sin(1:50))` (`ols_test_outlier(lm(y ~ x, data = d_sin))`):
       - Observation `11`: `studentized_residual = -1.531362`, `unadjusted_p_val = 0.1323839`
       - `0.7.0`: `bonferroni_p_val = 6.619194` (`50 * 0.1323839`)
       - `0.7.1`: `bonferroni_p_val = 1`
   - **Code (run in both `0.7.0` and `0.7.1`):**
     ```r
     model <- lm(mpg ~ disp + hp + wt + qsec, data = mtcars)
     r <- ols_regress(model)
     c(mse = r$mse, rmse = r$rmse, base_sigma = summary(model)$sigma)

     d_sin <- data.frame(x = 1:50, y = sin(1:50))
     ols_test_outlier(lm(y ~ x, data = d_sin))
     ```

---

### C. Known Issues

1. **`olsrr#254` — Kolmogorov-Smirnov $p$-value in `ols_test_normality()` not Lilliefors-corrected**
   - **Numbers in post & chunk output (`model <- lm(mpg ~ disp + hp + wt + qsec, data = mtcars)`):**
     - `D = 0.1152` (`0.11524`)
     - `ols_test_normality(model)$kolmogorv$p.value = 0.7464` (`0.7463768`, from `stats::ks.test(y, "pnorm", mean(y), sd(y))`)
     - `nortest::lillie.test(residuals(model))$p.value = 0.3446` (`0.3445667`)
   - **Code (run under `olsrr` 0.7.1):**
     ```r
     model <- lm(mpg ~ disp + hp + wt + qsec, data = mtcars)
     ols_test_normality(model)$kolmogorv$p.value
     nortest::lillie.test(residuals(model))
     ```

2. **`olsrr#253` — Duplicate title on two diagnostic panels**
   - **Verified panel titles in `0.7.1`:**
     - `panels$plot_7` (`ols_plot_fm()`, y-axis `"Fit - Mean"`): title `"Residual Fit Spread Plot"`
     - `panels$plot_8` (`ols_plot_resid_spread()`, y-axis `"Residual"`): title `"Residual Fit Spread Plot"`
   - **Code (run under `olsrr` 0.7.1):**
     ```r
     panels <- ols_plot_diagnostics(model, print_plot = FALSE)
     sapply(panels[c("plot_7", "plot_8")], function(p) ggplot2::get_labs(p)[c("title", "y")])
     ```

---

## 3. Render Result

- **Command executed:** `quarto render posts/olsrr-0-7-1/index.qmd` (single-post render only; full site was not rendered).
- **Exit code:** `0` (`31/31` blocks processed cleanly under R `4.6.1` with `olsrr_0.7.1`).
- **Spot-checks passed on `_site/posts/olsrr-0-7-1/index.html`:**
  - Zero R warnings, errors, or temporary library path strings (`olsrr-cran-lib`) in rendered HTML or `sessionInfo()`.
  - Cross-post link to the 2019 post resolves with forward slashes (`../../posts/introducing-olsrr/index.html`).
  - All three `<img>` tags include full descriptive `alt` text (`diag-grid-1.png`, `resid-hist-1.png`, `cpr-plot-1.png`).
  - `_freeze/posts/olsrr-0-7-1/index/execute-results/html.json` and figure PNGs generated and ready for commit.

---

## 4. Open Questions for Aravind

1. **Publication date (`date:` in YAML front matter):** Currently set to `2026-11-19` (one day after CRAN published `0.7.1` on `2026-11-18`). Update `date:` to the actual publication day when ready to merge.
2. **Categories (`categories: [packages, regression]`):** Matches both the 2019 `introducing-olsrr` post (`regression`) and `RELEASES.md` (`packages`). Prefer `[packages]` alone or keeping both?
3. **Number of fix subsections (6 vs 4):** Alongside the four fixes from the outline (Holm Breusch-Pagan, weighted predicted $R^2$, residual histogram scaling, and component-plus-residual plots), the draft includes the Cramér–von Mises reference distribution fix (which sets up `#254` naturally) and a brief MSE/RMSE + Bonferroni outlier cap item. Trim to the original four if you want a shorter read for R-Bloggers / R Weekly.
4. **Diagnostic grid presentation:** Calling `ols_plot_diagnostics(model)` directly emits three 2×2 pages (leaving the bottom-right half of page 3 empty), so the post uses `panels <- ols_plot_diagnostics(model, print_plot = FALSE)` with `gridExtra::grid.arrange(grobs = panels, ncol = 2)` to display all ten panels in one compact 5×2 figure while explaining both modes in the text. Let us know if you prefer showing the raw three-page `ols_plot_diagnostics(model)` call instead.
5. **Pre-publish cleanup:** Delete `REPORT-olsrr-post.md` before merging to `master` if you do not want internal review notes in the main branch history (it is already excluded from Quarto's site render).
