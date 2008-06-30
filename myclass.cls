\ProvidesClass{myclass}

%
% Holds the ``real'' class, the options to be passed to it, and the
% default options to be passed.  The last is so that options to this
% class can specify options to be passed to the real class if the
% 'default' option is selected.
%

\def\my@real@class{article}
\let\my@real@options\@empty
\let\my@def@options\@empty

% Holds the desired bibliography style
\def\my@bib@style{alpha}

% Any post-loading stuff to be done is held in here.
\let\my@afterclass\@empty

%
% Expanded version of \g@addto@macro.  Adds the _expansion_ of the
% second argument to the first.
%

\long\def\ge@addto@macro#1#2{%
  \begingroup
  \toks@\expandafter\expandafter\expandafter{\expandafter#1#2}%
  \xdef#1{\the\toks@}%
  \endgroup}

%
% Test to query what the ``real'' class is.  \@ifclassloaded can only
% be used in the preamble so this tests \my@real@class instead.
%
% Might be better to implement this as a three-option command since
% otherwise it doesn't seem to be good at nesting.
%
% Done.


\def\ifClassIs#1{%
  \edef\my@test{#1}%
  \ifx\my@test\my@real@class
   \expandafter\@firstoftwo
  \else
   \expandafter\@secondoftwo
  \fi}

%
% Some options will want particular style files loaded after the main
% class is loaded.  Others will want to suppress certain style files.
% If the latter, then there is probably a conflict so it would be bad
% to load the style file.  If the former, then it is not a major
% problem if we forget to load the style file since we can always load
% it manually later.  Therefore, a request not to load overrides one
% to load.
%

% Holds a space-delimited list of packages that should be considered
% for loading.  Package names shouldn't have spaces in so we should be
% safe with this delimiter.
\let\my@packages@to@load\@empty

\newcommand{\my@request@package}[1]{%
  \edef\my@temp{#1}%
  \ge@addto@macro{\my@packages@to@load}{\my@temp}
  \g@addto@macro{\my@packages@to@load}{ }
}

% If we don't want to load a package, set the command
% 'my@packagename@dont@load'
\newcommand{\my@unrequest@package}[1]{%
  \expandafter\def\csname my@#1@dont@load\endcsname{t}
}

\newcommand{\my@load@packages}{%
  \message{^^J Considering requested packages: ^^J}

  \ifx\my@packages@to@load\@empty
   \def\my@test{t}
   \message{^^J None requested ^^J}
  \else
   \let\my@test\@empty
  \fi

  \def\my@strip##1 ##2.{##1}
  \def\my@pirts##1 ##2.{##2}
  \loop\ifx\my@test\@empty
   \edef\my@this@package{\expandafter\my@strip \my@packages@to@load.}
   \edef\my@packages@to@load{\expandafter\my@pirts \my@packages@to@load.}
   \@ifundefined{my@\my@this@package @dont@load}{
    \RequirePackage{\my@this@package}
    \message{ Package \my@this@package: loaded^^J}
  }{%
    \message{ Package \my@this@package: requested, but suppressed^^J}}
   \ifx\my@packages@to@load\@empty
    \def\my@test{t}
   \fi
  \repeat
}

% Phase out these ifs in favour of the above

\newif\ifbeamer
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
% Set the real class according to options.
%
% Set the titlepage handling according to the class (journal).
%
% Title pages generally require the following data:
%
% Title
% Short title
% Date
% Abstract
% Subject class (and MSC year)
% Keywords
% Dedicatory
%
% For each author, the information required is (a subset of):
%
% Full name
% Short name
% Address
% Email
% Url
% Current Address
% Thanks
%

% Often we can just leave these alone.  Can't use '\let' here since
% the definitions will probably be redefined by the class but we want
% to be able to override the default in the options bit which is done
% before the class is actually loaded.

% Not all of these are defined by default, however.  But we don't yet
% know which ones.

\newcommand{\@gobbletwoopt}[2][]{}

% Define separators for things like authors which can be easily
% redefined.  These need to be one expansion away from what you want
% to appear as the _actual_ separator.

\def\myand{\and}
\def\mylastand{\and}

\newcommand{\mytitle}{\title}
\newcommand{\myshorttitle}{\@ifundefined{shorttitle}{\@gobble}{\shorttitle}}
\newcommand{\mydate}{\date}
\newcommand{\myabstract}[1]{\gdef\my@abstract{#1}}
\newcommand{\mysubjclass}{\@ifundefined{subjclass}{\@gobbletwoopt}{\subjclass}}
\newcommand{\mykeywords}{\@ifundefined{keywords}{\@gobble}{\keywords}}
\newcommand{\mydedicatory}{\@ifundefined{dedicatory}{\@gobble}{\dedicatory}}
\newcommand{\mymaketitle}{%
  \maketitle

  \ifx\my@abstract\@empty
  \else
  \begin{abstract}
  \my@abstract
  \end{abstract}
  \fi
}

\newcommand{\mybibliographystyle}{\bibliographystyle{\my@bib@style}}

%
% Author treatment is a pain.  Some class files ask for the authors to
% be specified one by one (ams), others all at once (standard), still
% others ask for bits of the author details to be one by one and
% others all at once (lms).  It is easier to go from 'one by one' to
% 'all at once' so this class file goes for the 'one by one' approach.
%

\newcommand{\myauthor}[1]{%
  \my@process@author%
  \gdef\my@this@author{#1}}
\newcommand{\myshortauthor}[1]{%
  \gdef\my@this@shortauthor{#1}}
\newcommand{\myaddress}[1]{%
  \gdef\my@this@address{#1}}
\newcommand{\myemail}[1]{%
  \gdef\my@this@email{#1}}
\newcommand{\myurl}[1]{%
  \gdef\my@this@url{#1}}
\newcommand{\mycurraddr}[1]{%
  \gdef\my@this@curraddr{#1}}%
\newcommand{\mythanks}[1]{%
  \gdef\my@this@thanks{#1}}

\let\my@this@author\@empty
\let\my@this@shortauthor\@empty
\let\my@this@address\@empty
\let\my@this@email\@empty
\let\my@this@url\@empty
\let\my@this@curraddr\@empty
\let\my@this@thanks\@empty

\let\my@authors\@empty
\let\my@shortauthors\@empty
\let\my@thanks\@empty
\let\my@shorttitle\@empty
\let\my@abstract\@empty

\newcommand{\my@process@author}{%
  \ifx\my@this@author\@empty
  \else

   \ifx\my@authors\@empty
   \else
    \ge@addto@macro{\my@authors}{\myand}
   \fi
   \ge@addto@macro{\my@authors}{\my@this@author}
   \ifx\my@this@thanks\@empty
   \else
    \expandafter\g@addto@macro\expandafter{\expandafter\my@authors\expandafter}\expandafter{\expandafter\thanks\expandafter{\my@this@thanks}}
   \fi

   \let\my@this@author\@empty
   \let\my@this@shortauthor\@empty
   \let\my@this@address\@empty
   \let\my@this@email\@empty
   \let\my@this@url\@empty
   \let\my@this@curraddr\@empty
   \let\my@this@thanks\@empty
  \fi
}

\newcommand{\my@process@lastauthor}{%
  \let\myand\mylastand
  \my@process@author
    \expandafter\author\expandafter{\my@authors}}

\AtBeginDocument{\my@process@lastauthor}

\DeclareOption{lms}{
  \def\my@real@class{lms}
  \def\my@bib@style{lms}

%
% lms.cls claims to replace amsthm.
%
  \my@unrequest@package{amsthm}

  \renewcommand{\mydedicatory}{\dedication}
  \renewcommand{\mysubjclass}[2][]{\classno{#2}}

  \let\my@this@affiliation\@empty
  \def\my@affiliationtype{affiliationone}

  \let\my@endmatter\@empty
  \def\myand{, }
  \def\mylastand{, \and}

%
% The lms wants the authors themselves to be specified all together
% but the 'affiliation' (i.e. everything else) to be separate.
%

  \renewcommand{\my@process@author}{%
%%
%% Don't do anything unless we have an author.
%%
%
    \ifx\my@this@author\@empty
    \else
%
     \ifx\my@authors\@empty
     \else
      \ge@addto@macro{\my@authors}{\myand}
     \fi
     \ge@addto@macro{\my@authors}{\my@this@author}
%
     \ifx\my@shortauthors\@empty
     \else
      \ge@addto@macro{\my@shortauthors}{\myand}
     \fi
     \ifx\my@this@shortauthor\@empty
      \ge@addto@macro{\my@shortauthors}{\my@this@author}
     \else
      \ge@addto@macro{\my@shortauthors}{\my@this@shortauthor}
     \fi
%
     \ifx\my@this@thanks\@empty
     \else
      \ifx\my@thanks\@empty
      \else
       \g@addto@macro{\my@thanks}{.  }
      \fi
      \ge@addto@macro{\my@thanks}{\my@this@thanks}
     \fi

    \let\my@this@affiliation\my@this@author
    \ifx\my@this@address\@empty
    \else
     \g@addto@macro{\my@this@affiliation}{\par}
     \ge@addto@macro{\my@this@affiliation}{\my@this@address}
    \fi
    \ifx\my@this@email\@empty
    \else
     \g@addto@macro{\my@this@affiliation}{\par}
     \expandafter\def\expandafter\my@temp\expandafter{\expandafter\email\expandafter{\my@this@email}}
     \ge@addto@macro{\my@this@affiliation}{\my@temp}
    \fi
    \ifx\my@this@url\@empty
    \else
     \g@addto@macro{\my@this@affiliation}{\par}
     \expandafter\def\expandafter\my@temp\expandafter{\expandafter\email\expandafter{\my@this@url}}
     \ge@addto@macro{\my@this@affiliation}{\my@temp}
    \fi
    \ifx\my@this@curraddr\@empty
    \else
     \g@addto@macro{\my@this@affiliation}{\par\par Current address:\par}
     \ge@addto@macro{\my@this@affiliation}{\my@this@curraddr}
    \fi

    \expandafter\expandafter\expandafter\def\expandafter\expandafter\expandafter\my@temp\expandafter\expandafter\expandafter{\expandafter\expandafter\expandafter\csname\expandafter\my@affiliationtype\expandafter\endcsname\expandafter{\my@this@affiliation}}
    \ge@addto@macro{\my@endmatter}{\my@temp}

    \let\my@this@author\@empty
    \let\my@this@shortauthor\@empty
    \let\my@this@address\@empty
    \let\my@this@email\@empty
    \let\my@this@url\@empty
    \let\my@this@curraddr\@empty
    \let\my@this@thanks\@empty
    \let\my@this@affiliation\@empty
%
    \edef\my@test@affiliationtype{affiliationone}
    \ifx\my@affiliationtype\my@test@affiliationtype
     \edef\my@affiliationtype{affiliationtwo}
    \else
     \edef\my@test@affiliationtype{affiliationtwo}
     \ifx\my@affiliationtype\my@test@affiliationtype
      \edef\my@affiliationtype{affiliationthree}
     \else
      \edef\my@test@affiliationtype{affiliationthree}
      \ifx\my@affiliationtype\my@test@affiliationtype
       \edef\my@affiliationtype{affiliationfour}
      \else
       \edef\my@test@affiliationtype{affiliationfour}
       \ifx\my@affiliationtype\my@test@affiliationtype
        \edef\my@affiliationtype{affiliationthree}
       \fi
      \fi
     \fi
    \fi
   \fi
  }
%
%
  \renewcommand{\my@process@lastauthor}{%
    \let\myand\mylastand
    \my@process@author
%
    \ifx\my@authors\@empty
    \else
     \expandafter\author\expandafter{\my@authors}
    \fi
    \ifx\my@shortauthors\@empty
    \else
     \expandafter\shortauthor\expandafter{\my@shortauthors}
    \fi
    \ifx\my@thanks\@empty
    \else
     \expandafter\extraline\expandafter{\my@thanks}
    \fi
  }
%
  \AtEndDocument{\my@endmatter}
}

\DeclareOption{amsart}{
  \def\my@real@class{amsart}
  \renewcommand{\mymaketitle}{%
    \ifx\my@abstract\@empty
    \else
    \begin{abstract}
    \my@abstract
    \end{abstract}
    \fi

    \maketitle}
%
% The amsart.cls defines their _internal_ shorttitle macro as
% '\shorttitle' which is bad style (should have an @ symbol as it is
% internal).  Also their redefined '\title' command clobbers
% '\shortitle' if it isn't given a short title as an option.  To make
% this system as robust as possible, we leave the shorttitle undefined
% as long as possible.  If the amsart.cls file changes internally this
% might need tweaking.
%
  \renewcommand{\myshorttitle}[1]{%
    \AtBeginDocument{%
    \gdef\shorttitle{#1}}}

%
% If it weren't for the fact that the 'author' command has the same
% issue as the 'title' command, filling in the ams author section
% would be easy.
%

  \renewcommand{\my@process@author}{%
    \ifx\my@this@shortauthor\@empty
    \expandafter\author\expandafter{\my@this@author}%
    \else
    \expandafter\expandafter\expandafter\author\expandafter\expandafter\expandafter[\expandafter\my@this@shortauthor\expandafter]\expandafter{\my@this@author}%
    \fi
    \let\my@this@author\@empty
    \let\my@this@shortauthor\@empty
  }
  \renewcommand{\myaddress}{\address}
  \renewcommand{\myemail}{\email}
  \renewcommand{\myurl}{\urladdr}
  \renewcommand{\mycurraddr}{\curraddr}
  \renewcommand{\mythanks}{\thanks}
  \let\my@process@lastauthor\my@process@author
}

%
% Documenta Mathematica option.
% Their style file is horrendous.  It isn't even a proper style file
% as it is supposed to be clonked on top of the LaTeX source file.  So
% I modified it ever-so-slightly to be a style file (commenting out a
% few things).  However, that isn't the worst bit.  The worst bit is
% that it uses '\obeylines' in setting up the title page.  That makes
% it extremely tricky to write a macro to insert the values at the
% right points since juggling \obeylines is complicated.  Having found
% a solution, I then found that this doesn't work from within a
% '\DeclareOption' block - possibly the whole '\DeclareOption' would
% have to be surrounded by '\obeylines' which isn't a good idea.  So
% we define the title page macro outside the option block and select
% it within.
%

{\obeylines\gdef\my@docmath@maketitle{%
\Title \my@title
\ShortTitle \my@shorttitle
\SubTitle   
\Author \my@authors
\ShortAuthor \my@shortauthors
\EndTitle
\Abstract \my@abstract
\EndAbstract
\MSC \my@subjclass
\EndMSC
\KEY \my@keywords
\EndKEY
\Address \my@first@address
\Address \my@second@address
\Address \my@third@address
\Address \my@other@addresses
\EndAddress
}}

\DeclareOption{docmath}{
  \my@request@package{docmath}
  \PassOptionsToClass{10pt,twoside}{article}

  \let\my@first@address\@empty
  \let\my@second@address\@empty
  \let\my@third@address\@empty
  \let\my@other@addresses\@empty

  \renewcommand{\mytitle}[2][]{\gdef\my@title{#2}%
    \edef\my@temp{#1}%
    \ifx\my@temp\@empty
     \ifx\my@shorttitle\@empty
      \gdef\my@shorttitle{#2}
     \fi
    \else
     \gdef\my@shorttitle{#1}
    \fi}
  \renewcommand{\myshorttitle}[1]{\gdef\my@shorttitle{#1}}
  \renewcommand{\myabstract}[1]{\gdef\my@abstract{#1}}
  \renewcommand{\mysubjclass}[2][]{\gdef\my@subjclass{#2}}
  \renewcommand{\mykeywords}[1]{\gdef\my@keywords{#1}}
  \renewcommand{\mydedicatory}[1]{\gdef\my@dedicatory{#1}}

  \renewcommand{\my@process@author}{%
    \ifx\my@authors\@empty
    \else
    \g@addto@macro{\my@authors}{ and }
    \fi
    \expandafter\g@addto@macro\expandafter{\expandafter\my@authors\expandafter}\expandafter{\my@this@author}

    \ifx\my@shortauthors\@empty
    \else
     \g@addto@macro{\my@shortauthors}{ and }
    \fi
    \ifx\my@this@shortauthor\@empty
     \expandafter\g@addto@macro\expandafter{\expandafter\my@shortauthors\expandafter}\expandafter{\my@this@author}
    \else
     \expandafter\g@addto@macro\expandafter{\expandafter\my@shortauthors\expandafter}\expandafter{\my@this@shortauthor}
    \fi

%
% Figuring out how to add emails and urls to addresses
%

    \let\my@this@fulladdress\my@this@address
    \ifx\my@this@email\@empty
    \else
     \expandafter\g@addto@macro\expandafter{\expandafter\my@this@fulladdress\expandafter}\expandafter{\expandafter\par\expandafter\texttt\expandafter{\expandafter\small\my@this@email}}
    \fi
    \ifx\my@this@url\@empty
    \else
     \expandafter\g@addto@macro\expandafter{\expandafter\my@this@fulladdress\expandafter}\expandafter{\expandafter\par\expandafter\texttt\expandafter{\expandafter\small\my@this@url}}
    \fi

    \ifx\my@first@address\@empty
     \let\my@first@address\my@this@fulladdress
    \else
     \ifx\my@second@address\@empty
      \let\my@second@address\my@this@fulladdress
     \else
      \ifx\my@third@address\@empty
       \let\my@third@address\my@this@fulladdress
      \else
       \expandafter\g@addto@macro\expandafter{\expandafter\my@other@addresses\expandafter}\expandafter{\expandafter\par\my@this@fulladdress}
      \fi
     \fi
    \fi

    \let\my@this@author\@empty
    \let\my@this@shortauthor\@empty
    \let\my@this@address\@empty
    \let\my@this@email\@empty
    \let\my@this@url\@empty
    \let\my@this@curraddr\@empty
    \let\my@this@thanks\@empty
}


  \AtEndDocument{\Addresses}

  \let\mymaketitle\my@docmath@maketitle
}

% Just warn about the bibliography for now.

\DeclareOption{arxiv}{
  \g@addto@macro{\mybibliography}{\medskip {\large Warning: the arXiv does not like unprocessed BibTeX references}}
}

% Commentarii Mathematici Helvetici; wants article.cls with prescribed
% text width and height and address etc on title page.

\DeclareOption{cmh}{

  \g@addto@macro{\my@afterclass}{
  \setlength{\textwidth}{125mm}
  \setlength{\textheight}{185mm}

  \def\@maketitle{%
  \newpage
  \null
  \vskip 2em%
  \begin{center}%
  \let \footnote \thanks
    {\LARGE \@title \par}%
    \vskip 1.5em%
    {\small
      \lineskip .5em%
      \begin{tabular}[t]{c}%
        \@author
      \end{tabular}\par}%
    \vskip 1em%
    {\large \@date}%
  \end{center}%
  \par
  \vskip 1.5em}}

  \renewcommand{\my@process@author}{%
  \ifx\my@this@author\@empty
  \else

   \ifx\my@authors\@empty
   \else
    \ge@addto@macro{\my@authors}{\myand}
   \fi
   \g@addto@macro{\my@authors}{\large}
   \ge@addto@macro{\my@authors}{\my@this@author}
   \ifx\my@this@thanks\@empty
   \else
    \expandafter\g@addto@macro\expandafter{\expandafter\my@authors\expandafter}\expandafter{\expandafter\thanks\expandafter{\my@this@thanks}}
   \fi
   \ifx\my@this@addres\@empty
   \else
    \g@addto@macro{\my@authors}{\\}
    \expandafter\g@addto@macro\expandafter{\expandafter\my@authors\expandafter}\expandafter{\my@this@address}
   \fi
   \ifx\my@this@email\@empty
   \else
    \expandafter\g@addto@macro\expandafter{\expandafter\my@authors\expandafter}\expandafter{\expandafter\\\expandafter\texttt\expandafter{\my@this@email}}
   \fi


   \let\my@this@author\@empty
   \let\my@this@shortauthor\@empty
   \let\my@this@address\@empty
   \let\my@this@email\@empty
   \let\my@this@url\@empty
   \let\my@this@curraddr\@empty
   \let\my@this@thanks\@empty
  \fi
}
}

% This doesn't do anything as yet - it's more as a default.

\DeclareOption{article}{
}

\DeclareOption{hopf}{
  \my@unrequest@package{pxfonts}
}

\DeclareOption{beamer}{
  \def\my@real@class{beamer}

% Copied from the TeX FAQ entry 'comparing the ``jobname'''.

  \def\be@mertypeis#1{FF\fi
   \edef\my@predicate{#1}%
   \edef\my@predicate{\expandafter\strip@prefix\meaning\my@predicate}%
   \edef\my@job{\be@mertype}%
   \ifx\be@mertype\my@predicate
  }

  \def\be@mertwo#1.#2{#2}
  \def\be@merone#1.#2{#1}

  \edef\be@mertest{\expandafter\be@merone\jobname.j}
  \edef\my@jobname{\jobname}
  \ifx\be@mertest\my@jobname
   \def\be@mertype{beamer}
   \def\be@merfile{\jobname}
  \else
   \edef\be@mertype{\expandafter\be@mertwo\jobname}
   \edef\be@merfile{\expandafter\be@merone\jobname}
  \fi

  \edef\be@merdefopts{12pt,t,xcolor=dvipsname,ignorenonframetext}

  \if\be@mertypeis{article}
   \def\my@real@class{article}
   \my@request@package{beamerarticle}
   \PassOptionsToPackage{envcountsect}{beamerarticle}
   \def\be@merdefopts{a4paper,10pt}
   \g@addto@macro{\my@afterclass}{%
    \setjobnamebeamerversion{\be@merfile.beamer}
   }
  \fi

  \if\be@mertypeis{handout}
   \PassOptionsToClass{handout}{beamer}
   \def\be@merdefopts{12pt,xcolor=dvipsname,ignorenonframetext}
  \fi

  \if\be@mertypeis{trans}
   \PassOptionsToClass{trans}{beamer}
   \def\be@merdefopts{12pt,xcolor=dvipsname,ignorenonframetext}
  \fi

  \expandafter\g@addto@macro\expandafter{\expandafter\my@def@options\expandafter}\expandafter{\expandafter\PassOptionsToClass\expandafter{\expandafter\be@merdefopts\expandafter}\expandafter{\my@real@class}}
}

\DeclareOption{nopxfonts}{
   \my@unrequest@package{pxfonts}
}

\DeclareOption{pxfonts}{
   \my@request@package{pxfonts}
}

\DeclareOption{draft}{
  % Need to make sure that this isn't done until we're sure of what
  % \my@real@class is
  \g@addto@macro{\my@real@options}{\PassOptionsToClass{draft}{\my@real@class}}
  \drafttrue
}

\DeclareOption{fig}{
  \my@request@package{graphicx}
  \ifpdf
    \PassOptionsToPackage{pdftex}{graphicx}
    \PassOptionsToPackage{pdftex,dvipsnames}{color}
  \else
    \PassOptionsToPackage{dvips}{graphicx}
    \PassOptionsToPackage{dvips,dvipsnames}{color}
  \fi
  \PassOptionsToPackage{fig}{mymacros}

  \g@addto@macro{\my@afterclass}{
  \@ifpackageloaded{xcolor}{}{
   \RequirePackage{color}
  }}
}

\DeclareOption{figdraft}{
  \ExecuteOptions{fig}
  \PassOptionsToPackage{draft}{graphicx}
}

\DeclareOption{fignodraft}{
  \ExecuteOptions{fig}
  \PassOptionsToPackage{final}{graphicx}
}

\DeclareOption{defaults}{
  \my@request@package{amsmath}
  \my@request@package{amsthm}
  \my@request@package{pxfonts}
  \my@request@package{hyphenat}

  \g@addto@macro{\my@afterclass}{%
  \@ifpackageloaded{pxfonts}{}{
    \RequirePackage{amssymb}
    \providecommand{\coloneqq}{\colon=}
  }}
  \g@addto@macro{\my@real@options}{\my@def@options}
}

\DeclareOption*{
  % Need to make sure that this isn't done until we're sure of what
  % \my@real@class is
  \edef\my@temp{\noexpand\PassOptionsToClass{\CurrentOption}{\noexpand\my@real@class}}
  \ge@addto@macro{\my@real@options}{\my@temp}
}
\ProcessOptions

% Add any additional options to the class
\my@real@options

\LoadClass{\my@real@class}

\my@load@packages

% Some options will have set things that need to be done after the
% class is loaded.
\my@afterclass
