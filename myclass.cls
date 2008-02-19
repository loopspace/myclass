\ProvidesClass{myclass}


%
% Holds the ``real'' class
%

\def\my@real@class{article}
\def\my@real@options{}

%
% Also set up some ``ifs'' to tell us later which class we've used
%

\newif\ifLMS
\newif\ifAMS
\newif\ifarxiv
\newif\ifhopf

%
% If we're in draft mode
%

\newif\ifdraft

%
% What fonts are we using?  Hopf archive doesn't like non-cms fonts.
% Default is to use pxfonts
%

\newif\ifpxfonts
\pxfontstrue

%
% Useful to have a list of ``default'' packages that I almost always
% load.  Load these last to allow for pxfonts and amsthm to be
% selected according to the class.
%

\newif\ifmydef@ults

%
% Do we want graphics capabilities?
%

\newif\ifmyfig@res

%
% Load in the ifpdf.sty package to allow 'ifpdf'
% TODO: Perhaps check for existence and otherwise add in manually?
%

\RequirePackage{ifpdf}

%
% Set the real class according to options
%

\DeclareOption{lms}{
  \def\my@real@class{lms}
  \LMStrue
}

\DeclareOption{arxiv}{
  \arxivtrue
}

\DeclareOption{amsart}{
  \def\my@real@class{amsart}
  \AMStrue
}

\DeclareOption{hopf}{
  \pxfontsfalse
}

\DeclareOption{nopxfonts}{
  \pxfontsfalse
}

\DeclareOption{draft}{
  % Need to make sure that this isn't done until we're sure of what
  % \my@real@class is
  \let\my@orig@options\my@real@options
  \edef\my@real@options{
    \noexpand\PassOptionsToClass{draft}{\noexpand\my@real@class}
    \my@orig@options
  }
  \drafttrue
}

\DeclareOption{fig}{
  \myfig@restrue
}

\DeclareOption{figdraft}{
  \myfig@restrue
  \PassOptionsToPackage{draft}{graphicx}
}

\DeclareOption{fignodraft}{
  \myfig@restrue
  \PassOptionsToPackage{final}{graphicx}
}

\DeclareOption{defaults}{
  \mydef@ultstrue
}

\DeclareOption*{
  % Need to make sure that this isn't done until we're sure of what
  % \my@real@class is
  \let\my@orig@options\my@real@options
  \edef\my@real@options{
    \noexpand\PassOptionsToClass{\CurrentOption}{\noexpand\my@real@class}
    \my@orig@options
    }
}
\ProcessOptions
% Add any additional options to the class
\my@real@options
\LoadClass{\my@real@class}

% Load default packages

\ifmydef@ults
  \usepackage{amsmath}

  \ifLMS
  \else
    \usepackage{amsthm}
  \fi

  \ifpxfonts
    \usepackage{pxfonts}
  \else
    \usepackage{amssymb}
    \newcommand{\coloneqq}{\colon=}
  \fi

  \usepackage{hyphenat}
\fi

% Load graphics packages

\ifmyfig@res
  \ifpdf
    \usepackage[pdftex]{graphicx}
    \usepackage[pdftex,dvipsnames]{color}
  \else
    \usepackage[dvips]{graphicx}
    \usepackage[dvips]{color}
  \fi
  \PassOptionsToPackage{fig}{mymacros}
\fi