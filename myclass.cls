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
\newif\ifbeamer

% Some 'ifs' for beamer presentations

\newif\ifbeamerdef
\newif\ifbe@merarticle

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

\DeclareOption{beamer}{
  \def\my@real@class{beamer}
  \beamertrue
}

\DeclareOption{beamerdefault}{
  \def\my@real@class{beamer}
  \beamertrue
  \beamerdeftrue
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

% Copied from the TeX FAQ entry 'comparing the ``jobname'''.

\def\be@mertypeis#1{FF\fi
  \def\my@predicate{#1}%
  \edef\my@predicate{\expandafter\strip@prefix\meaning\my@predicate}%
  \edef\my@job{\be@mertype}%
  \ifx\my@job\my@predicate
  }

\ifbeamer
 \def\be@mertwo#1.#2{#2}
 \def\be@merone#1.#2{#1}
 \edef\be@mertype{\expandafter\be@mertwo\jobname}
 \edef\be@merfile{\expandafter\be@merone\jobname}
 \edef\be@merdefopts{12pt,t,xcolor=dvipsname,ignorenonframetext}

 \if\be@mertypeis{article}
  \def\my@real@class{article}
  \be@merarticletrue
  \def\be@merdefopts{a4paper,10pt}
 \fi

 \if\be@mertypeis{handout}
  \PassOptionsToClass{handout}{beamer}
  \def\be@merdefopts{12pt,xcolor=dvipsname,ignorenonframetext}
 \fi

 \if\be@mertypeis{trans}
  \PassOptionsToClass{trans}{beamer}
  \def\be@merdefopts{12pt,xcolor=dvipsname,ignorenonframetext}
 \fi

 \ifbeamerdef
  \PassOptionsToClass{\be@merdefopts}{\my@real@class}
 \fi
\fi

% Add any additional options to the class
\my@real@options

\LoadClass{\my@real@class}

\ifbe@merarticle
  \RequirePackage[envcountsect]{beamerarticle}
  \setjobnamebeamerversion{\be@merfile.beamer}
\fi

% Load default packages

\ifmydef@ults
  \RequirePackage{amsmath}

  \ifLMS
  \else
    \RequirePackage{amsthm}
  \fi

  \ifpxfonts
    \RequirePackage{pxfonts}
  \else
    \RequirePackage{amssymb}
    \newcommand{\coloneqq}{\colon=}
  \fi

  \RequirePackage{hyphenat}
\fi

% Load graphics packages

\ifmyfig@res
  \ifpdf
    \PassOptionsToPackage{pdftex}{graphicx}
    \PassOptionsToPackage{pdftex,dvipsnames}{color}
  \else
    \PassOptionsToPackage{dvips}{graphicx}
    \PassOptionsToPackage{dvips,dvipsnames}{color}
  \fi
  \PassOptionsToPackage{fig}{mymacros}
  \RequirePackage{graphicx}
  \@ifpackageloaded{xcolor}{}{
   \RequirePackage{color}
  }
\fi