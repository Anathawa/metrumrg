\name{as.keyed}
\alias{[.keyed}
\alias{aggregate.keyed}
\alias{as.keyed.data.frame}
\alias{as.data.frame.keyed}
\alias{as.keyed}
\alias{dupKeys}
\alias{dupKeys.default}
\alias{key}
\alias{key<-}
\alias{merge.keyed}
\alias{naKeys}
\alias{naKeys.default}
\alias{print.keyed.summary}
\alias{sort.keyed}
\alias{unsorted}
\alias{unsorted.keyed}
\alias{summary.keyed}
\alias{transform.keyed}
\alias{uniKey.keyed}
\alias{uniKey}
\alias{print.uniKey}
\alias{c.uniKey}
\alias{as.vector.uniKey}
\alias{[.uniKey}
\alias{[[.uniKey}
\alias{rep.uniKey}
\alias{format.uniKey}
\alias{print.uniKey}
\alias{unique.uniKey}
\alias{xtfrm.uniKey}
\alias{as.character.uniKey}
\title{Create and Manipulate Keyed Data Frames}
\description{The class \dfn{keyed} is a subclass of data.frame with a \dfn{key} attribute.
The key is a vector of column names which, taken together, should provide enough
information to uniquely distinguish each row.  Specific functions and methods
take advantage of this information.
}
\usage{
\method{[}{keyed}( x, i, j, drop)
\method{aggregate}{keyed}(x, by=x[,setdiff(key(x),across),drop=FALSE], FUN, across=character(0), ...)
\method{as.keyed}{data.frame}(x, key=character(0), ...)
dupKeys(x, ...)
key(x, ...)
key(x) <- value
\method{merge}{keyed}(x, y, ...)
naKeys(x, ...)
unsorted(x, ...)
\method{print}{keyed.summary}(x, ...)
\method{sort}{keyed}(x, decreasing = FALSE, ...)
\method{summary}{keyed}(object, ...)
\method{transform}{keyed}(`_data`, ...)
\method{uniKey}{keyed}(x,key=NULL,...)
}
\arguments{
  \item{x}{a (keyed) data.frame}
  \item{i}{first index}
  \item{j}{second index}
  \item{drop}{whether to drop unused dimensions}
  \item{by}{a list of indices as long as \code{nrow(x)}, whose interaction gives the aggregates (groups)}
  \item{FUN}{an aggregating function}
  \item{across}{column names in \code{key(x)} across which to aggregate; see details}
  \item{\dots}{extra arguments, usually ignored, but passed to FUN in \code{aggregate}}
  \item{key}{a character vector of column names in \code{x} that should uniquely distinguish each row}
  \item{value}{a key (character vector of column names)}
  \item{y}{the right argument in the merge}
  \item{decreasing}{(coercible to) logical; length 1}
  \item{object}{a keyed data.frame}
  \item{_data}{a keyed data.frame}
}
\details{

The generic \code{as.keyed} is the usual way of creating a keyed object.  The method
\code{as.keyed.data.frame} calls \code{key<-}. The function \code{key} allows checking an 
object's key. A data.frame can be re-keyed by a subsequent call.  Generally, a 
data.frame should be keyed on columns that actually exist, but this is not
enforced. \code{as.data.frame.keyed} removes the key and reverts the class.

In \code{aggregate.keyed}, the default behavior is to aggregate by the key columns, i.e.,
to eliminate duplicate keys by aggregation.  \code{by} can be specified arbitrarily, but 
must be a named list (e.g., a data.frame) with each element as long as \code{nrow(x)}.  
Each element in \code{by} will displace any like-named element in \code{x}, and 
\code{names(by)} will  serve as the key of the result.  If \code{by} has length zero,
(as it does by default when \code{across} is \code{key(x)}) the entire data set is aggregated
into a one row data.frame.

\code{across} is a convenience argument to \code{aggregate.keyed}.  If specified, it must be
a subset of (or all of) \code{key(x)}.  Columns indicated by \code{across} are dropped 
from \code{x} and from the default \code{by} value, and aggregation proceeds irrespective
of those columns.

The function \code{naKeys} detects rows for which one or more key fields is \code{NA}.

The function \code{dupKeys} detects all rows for which there is another row 
(earlier or later) with identical key. That means it can never identify a single
row, as \code{duplicated} can: it identifies the duplicates as well as those rows of 
which they are duplicates. It is recommended to test for \code{NA}s before testing 
for duplicates.

The \code{keyed} method for \code{unsorted} detects rows that would move on sort.

%\code{order} treats \code{decreasing} as an all-or-nothing argument, whereas \code{sort.keyed} 
%allows independent specification for each column.

Methods for \code{merge} and \code{transform} are key-friendly. The method for \code{summary}
is key-centric.  

\code{uniKey} creates a character vector (class \code{uniKey}) by pasting the key columns with \code{\\r}. 
(Keys containing \code{\\r} are unsupported.) The \code{as.character} method substitutes a space character for \code{\\r}.  
}
\value{
Most functions and methods documented here return objects with class 
\code{c('keyed','data.frame')}.

\code{key<-} and methods for \code{summary} and \code{print} are used for side effects.

\code{uniKey.keyed} returns a character vector as long as \code{nrow(x)}, class \code{uniKey}.

\code{naKeys}, \code{dupKeys}, and \code{unsorted} return logical vectors as long as \code{nrow(x)}.

}
\note{Values in key columns should not contain \code{\\r}, which is used as a delimiter in
\code{dupKeys} and \code{uniKey}.}
\references{\url{http://metrumrg.googlecode.com}}
\author{Tim Bergsma}
\seealso{
	\itemize{
		\item \code{\link{Ops.keyed}}
    \item \code{\link{melt.keyed}}
    \item \code{\link{cast,keyed-method}}
	}
}
\examples{
a <- sort(as.keyed(Theoph,key=c('Subject','Time')))
summary(a)
aggregate(a, across='Time',FUN=mean)
}
\keyword{manip}

