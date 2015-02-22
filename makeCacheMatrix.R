makeCasheMatrix <- function(x = matrix()){
  invMat <- NULL
  set <- function(y) {
    x <<- y
    invMat <<- NULL
  }
  
  get <- function() x
  
  setinv <- function(inv) invMat <<- inv
  getinv <- function() invMat
  list(set = set, get = get, setinv = setinv, getinv = getinv)
}