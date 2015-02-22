cacheSolve <- function(x,...) {
  invMat <- x$getinv()
  if(!is.null(invMat)) {
    message("getting cached data")
    return(invMat)
  }
  data <- x$get()
  invMat <- solve(data, ...)
  x$setinv(invMat)
  invMat
}