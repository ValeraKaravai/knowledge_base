Rpackage
========================================================
author: 
date: 
autosize: true

Naming your package
========================================================
<font size=5px>
> "There are only two hard things in Computer Science: cache invalidation and naming things." Phil Karlton

**Requirements for a name**
- letters
- numbers
- periods (i.e. ., ;)
- start with a letter
- cannot end with a period
- can’t use either hyphens or underscores (_ or -)
</font> 

Creating a package
========================================================
<font size=5px>
- RStudio

```
File -> New Project -> New Directory
```
- Within R 


```r
devtools::create("path/to/package/pkgname")
```


**Results:**
- An **R/** directory
- A basic **DESCRIPTION** file
- A basic **NAMESPACE** file
- pkgname.Rproj
</font> 

What is a package?
========================================================
<font size=5px>
**Five states a package:**
- source (just a directory with components like R/, description, namespace)
- bundled 
- binary
- installed
- in-memory
</font> 
Bundled packages
========================================================

<font size=5px>
- A bundled package is a package that’s been compressed into a single file `tar.gz.`


```r
devtools::build()
```

- Any files listed in `.Rbuildignore` are not included in the bundle.


```
^.*\.Rproj$         # Automatically added by RStudio,

^\.Rproj\.user$     # used for temporary files. 

^README\.Rmd$       # generate README.md

^NEWS\.md$          # A news file written in Markdown
```
</font> 
Binary packages
========================================================
<font size=5px>
Like a package bundle, a binary package is a single file. But:

- There are no .R files in the R/ directory (instead there are three files that store the parsed functions in an efficient file format)

- A Meta/ directory contains a number of Rds files (use `readRDS()`)

- An html/ directory contains files needed for HTML help

- If you had any code in the src/ directory there will now be a libs/ directory

- The contents of inst/ are moved to the top-level directory.


```r
devtools::build(binary = TRUE)
```

</font> 

Installed packages
========================================================
<font size=5px>

 In an ideal world, installing a package would involve: 
 ```
 source -> bundle, bundle -> binary, binary -> installed
 ```
[Diagram](figure/1.png)

- Tool `R CMD INSTALL` - it can install a source, bundle or a binary package.
- **devtools::install()** is effectively a wrapper for `R CMD INSTALL`
- **devtools::build()** is a wrapper for `R CMD build`
- **devtools::install_github()**: `build() -> R CMD INSTALL`.
- **install.packages()** used to download and install binary packages built by CRAN.
- For packages found elsewhere on the internet.

```r
devtools::install_url()

devtools::install_gitorious()

devtools::install_bitbucket()
```

</font> 


In memory packages
========================================================

<font size=5px>
Use **library()** (or **require()**)


```r
# Automatically loads devtools
devtools::install()
    
# Loads and _attaches_ devtools to the search path
library(devtools)
install()
```

The distinction between loading and attaching packages is not important when you’re writing scripts, but it’s very important when you’re writing packages


**Build and reload**

[Diagram](figure/2.png)

To skip install and load a source package directly into memory:

```r
devtools::load_all() 
```
</font> 


What is a library?
========================================================

<font size=5px>
A library is simply a directory containing installed packages

**.libPaths()**
```

##Installed packages
[1] "/Users/valeriiakaravaeva/Library/R/3.3/library"      

[2] "/usr/local/lib/R/3.3/site-library"

##Reccomended package
[3] "/usr/local/Cellar/r/3.3.2/R.framework/Versions/3.3/Resources/library"

```

**Library and require**

```r
library(blah)

## Error in library(blah): there is no package called 'blah'
```


```r
require(blah)

## Warning in library(package, lib.loc = lib.loc, character.only = TRUE,
## logical.return = TRUE, : there is no package called 'blah'
```


</font> 

R code workflow
========================================================

<font size=5px>
The first principle of using a package is that all R code goes in R/


```r
devtools::load_all()
```

- Edit an R file.

- Press Ctrl/Cmd + Shift + L (or `devtools::load_all()`)

- Explore the code in the console.

- Rinse and repeat.

</font> 

Organising your functions and code
========================================================
<font size=5px>
**Function**

```
# Good

fit_models.R
utility_functions.R

# Bad

foo.r
stuff.r
```

**Code**

R style guide <https://google.github.io/styleguide/Rguide.xml>

FormatR: https://yihui.name/formatr/

```r
install.packages("formatR")
formatR::tidy_dir("R")

##OR lintr

install.packages("lintr")
lintr::lint_package()
```

</font> 

The R landscape
========================================================
<font size=5px>
- Don’t use library() or require().
- Never use source() to load code from a file.
- Avoid modifying the working directory. If you do have to change it, make sure to change it back when you’re done


```r
old <- setwd(tempdir())
on.exit(setwd(old), add = TRUE)
```

</font> 

Package metadata
========================================================
<font size=5px>

**DESCRIPTION**  uses a simple file format called DCF,
```dcf
Package: mypackage
Title: What The Package Does (one line, title case required)
Version: 0.1
Authors@R: person("First", "Last", email = "first.last@example.com",
                  role = c("aut", "cre"))
Description: What the package does (one paragraph)
Depends: R (>= 3.1.0)
License: What license is it under?
LazyData: true
```

A three letter code specifying the role. There are four important roles:

- cre: the creator or maintainer, the person you should bother if you have problems.

- aut: authors, those who have made significant contributions to the package.

- ctb: contributors, those who have made smaller contributions, like patches.

- cph: copyright holder. This is used if the copyright is held by someone other than the author, typically a company (i.e. the author’s employer).

</font> 

Dependencies: What does your package need?
========================================================
<font size=5px>


```yaml
Imports:
    dplyr,
    readr
```


```yaml
Suggests:
    dplyr,
    readr
```





```r
devtools::use_package("dplyr") # Defaults to imports
#> Adding dplyr to Imports
#> Refer to functions with dplyr::fun()

devtools::use_package("dplyr", "Suggests")
#> Adding dplyr to Suggests
#> Use requireNamespace("dplyr", quietly = TRUE) to test if package is 
#>  installed, then use dplyr::fun() to refer to functions.
```

**Versioning**

```
Imports:
    dplyr (>= 0.3.0.1)
Suggests:
    MASS (>= 7.3.0)
```

```
Depends: R (>= 3.0.1)
```

</font> 


The documentation workflow
========================================================
<font size=5px>

```
? = help() => Rd files -> man/
```


1. Add roxygen comments to your .R files.

2. Run `devtools::document()` to convert roxygen comments to .Rd files. (`devtools::document()` calls `roxygen2::roxygenise()` to do the hard work.)

3. Preview documentation with ?.

4. Rinse and repeat until the documentation looks the way you want.


```r
#' Add together two numbers.
#' 
#' @param x A number.
#' @param y A number.
#' @return The sum of \code{x} and \code{y}.
#' @examples
#' add(1, 1)
#' add(10, 1)
add <- function(x, y) {
  x + y
}
```
[Output](figure/3.png)

</font> 

Documenting packages
========================================================
<font size=5px>

```r
#' foo: A package for computating the notorious bar statistic.
#'
#' The foo package provides three categories of important functions:
#' foo, bar and baz.
#' 
#' @section Foo functions:
#' The foo functions ...
#'
#' @docType package
#' @name foo
NULL
```
</font> 

Documenting datasets
========================================================
<font size=5px>

Never `@export` a data set.

```r
#' Prices of 50,000 round cut diamonds.
#'
#' A dataset containing the prices and other attributes of almost 54,000
#' diamonds.
#'
#' @format A data frame with 53940 rows and 10 variables:
#' \describe{
#'   \item{price}{price, in US dollars}
#'   \item{carat}{weight of the diamond, in carats}
#'   ...
#' }
#' @source \url{http://www.diamondse.info/}
"diamonds"
```

</font> 

Inheriting parameters from other functions
========================================================
<font size=5px>


```r
#' @param a This is the first argument
foo <- function(a) a + 10

#' @param b This is the second argument
#' @inheritParams foo
bar <- function(a, b) {
  foo(a) * 10
}
```

OR


```r
#' @param a This is the first argument
#' @param b This is the second argument
bar <- function(a, b) {
  foo(a) * 10
}
```

</font> 


Namespace
========================================================
<font size=5px>
Namespaces make your packages self-contained in two ways: **the imports** and **the exports**

**The imports** defines how a function in one package finds a function in another.

```r
##nrow
## function (x) 
## dim(x)[1L]
## <bytecode: 0x15a0110>
## <environment: namespace:base>

nrow(mtcars)
```

```
[1] 32
```

```r
dim <- function(x) c(1, 1)
dim(mtcars)
```

```
[1] 1 1
```

```r
nrow(mtcars)
```

```
[1] 32
```

**The exports** helps you avoid conflicts with other packages by specifying which functions are available outside of your package
</font> 

Search path
========================================================
<font size=5px>


```r
search()
```

```
 [1] ".GlobalEnv"        "package:knitr"     "package:stats"    
 [4] "package:graphics"  "package:grDevices" "package:utils"    
 [7] "package:datasets"  "package:methods"   "Autoloads"        
[10] "package:base"     
```

- **Loading** - Imports
- **Attaching** - Depends

[Load vs. Attach](figure/4.png)



</font> 

The NAMESPACE
========================================================
<font size=5px>

```r
# Generated by roxygen2: do not edit by hand
export(CastData)
exportClasses(MinimalReporter)
S3method(compare,character)
importFrom(lazyeval,interp)
```

**Exports:**

- export(): export functions (including S3 and S4 generics).
- exportPattern(): export all functions that match a pattern.
- exportClasses(), exportMethods(): export S4 classes and methods.
- S3method(): export S3 methods.

**Imports:**

- import(): import all functions from a package.
- importFrom(): import selected functions (including S4 generics).
- importClassesFrom(), importMethodsFrom(): import S4 classes and methods.
- useDynLib(): import a function from C. 

</font> 

External data
========================================================
<font size=5px>
- data/ (binary data and make it available to the user)
-  R/sysdata.rda (binary data but not make it available to the user,)
- inst/extdata (raw data)



```r
x <- sample(1000)
devtools::use_data(x)
```

If the DESCRIPTION contains LazyData: true, then datasets will be lazily loaded.


```r
pryr::mem_used()
```

```
25 MB
```

```r
library(nycflights13)
pryr::mem_used()
```

```
25.1 MB
```

```r
invisible(flights)
pryr::mem_used()
```

```
65.7 MB
```


```r
devtools::use_data_raw()
```
</font> 
Internal data
========================================================
<font size=5px>


```r
x <- sample(1000)
devtools::use_data(x, internal = TRUE)
```

</font> 

Cycle of work on the package
========================================================
<font size=5px>

* Load devtools

```r
library("devtools")
setwd("rnautils")
dev_mode()
```
* Edit an R file (or documents/description)
* Refresh documents and check:

```r
check()
```
* Installed locally and connected a new version of the package for more detailed testing

```r
install("../rnautils")
library("rnautils")
```


```r
dev_mode(FALSE)
```

Moved the changes from the `dev` branch to the `master` branch
</font> 
Download package
========================================================
<font size=5px>

Our package: `username/pkg = propellerads/rnautils`

```r
devtools::install_github("username/pkg")
##private repo and branch dev
devtools::install_github("username/pkg", ref = "dev", 
                         auth_token = 'your_token_github')
```

Personal access tokens: https://github.com/settings/tokens
</font> 
