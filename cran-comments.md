## Background

This package is written entirely in R with no external dependencies/components other than the packages listed in the DESCRIPTION file.
This update has not made any significant changes to the structure of the package or dependencies.
Development approach is aligned with practices described in:
http://r-pkgs.had.co.nz/

## CRAN Resubmission

This is a resubmission.  The previous submission generated notes:  "Found the following (possibly) invalid file URIs:..."
This was because some extra vignettes were wrongly included in the submitted package.
.Rbuildignore has now been updated and these vignettes are now correctly excluded - so the "invalid URIs" problem is resolved.

## Test environments

* local OS (windows) install, R 4.0.0
* Ubuntu 16.04.6 LTS (on travis-ci), R 4.0.0.
* win-builder, R-devel
* R-hub, three tests:
  * Windows Server 2008 R2 SP1, R-devel 32/64 bit
  * Ubuntu Linux 16.04 LTS, R-release, GCC
  * Fedora Linux, R-devel, clang, gfortran

## R CMD check results

### Local R CMD check results

0 errors | 0 warnings | 0 notes

### Travis-CI R CMD check results

0 errors | 0 warnings | 0 notes

### win-builder check results

0 errors | 0 warnings | 0 notes

### R-hub check results

0 errors | 0 warnings | 0 notes

### Comments on check results

The sample data has been compressed into three rda files, total size 1 MB. Different compression options were explored and the option chosen that resulted in the smallest files.

## Downstream dependencies

None.
