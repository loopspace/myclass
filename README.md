# My Class File

I use a single class file for all my LaTeX documents.
This class file sets up some options before calling a real class file, depending on which options it was passed.
This allows me to do the following:

1. Swap class files without rewriting vast swathes of my documents (necessary when submitting articles to journals).
2. Maintain different versions of the same document without changing the document (useful when doing beamer presentations).

It is extensively commented, but the comments really only pertain to how things were done so aren't useful for finding out how to use it.
On the other hand, it's hard to imagine anyone wanting to use this _as is_, but rather that someone might want to steal bits of it for their own use.
However, without knowing what it's for, it's hard to know which bits might be worth stealing.
So what follows is intended more as a treasure map than a guidebook.

### Swapping Classes ###

As said above, this class was designed to overcome the problem of maintaining similar versions of documents; either through swapping class files or options to a particular class file.

The main problems with swapping class files are:

1. Different ways of inputting the data required for a title page
2. Incompatibilities with other packages

The first is simply irritating.
The second is actually a bit beyond irritating; many journals provide - in their class file - a set of useful macros.
The problem is that I have my own set of useful macros and there are often conflicts.
Sometimes there are conflicts with other packages, but the journal class file may not provide a complete replacement for the other package, or may not provide quite the same commands.

In this class file, I deal with the title page and with package conflicts; I leave the issue of replacements for the package which holds all _my_ useful macros.
The method I use for solving the title page is to provide new commands for entering this data which give me a way to package it appropriately
to the class chosen.
Thus the start of one of my articles will look like this:

     \documentclass[%
      a4paper,%
      %draft,%
      arxiv,%
      defaults
     ]{myclass}

     \mybibliographystyle

     \mytitle{Comparative Smootheology}

     \myauthor{Andrew Stacey}

     \myabstract{%
      We compare various different definitions of ``the category of smooth  objects''.
      The definitions compared are due to Chen, Fr\"olicher, Sikorski, Smith, and Souriau.
      The method of comparison is to construct functors between the       categories that enable us to see how the categories relate to       each other.
      This produces a diagram of categories with the category of      Fr\"olicher spaces sitting at its centre.

      Our method of study involves finding a general context into which these categories can be placed.
      This involves considering categories wherein objects are considered in relation to a certain collection of standard test objects.
      This therefore applies beyond the question of categories of smooth spaces.
     }

     \begin{document}

     \mymaketitle

Depending on the option passed to the class, the article details, the author details, and the rest, get passed to the real class in the appropriate way.
Adding support for a new class file is reasonably straightforward, but obviously I only have done those class files that I've seriously thought about using.
Currently supported options are: lms, compositio, amsart, amsproc, docmath, cmh, jdg, hha, article, arxiv.

Each option can also suggest a list of packages to load or not to load.
After the main class is loaded, this list is looked at and if a package is requested and not suppressed, it is loaded.
Thus, for example, by default I load the `pxfonts` as I prefer them to Computer Modern.
But the _hopf_ electronic archive does not support these fonts so I have to suppress loading this package when compiling for that archive.
In a similar vein, when writing exams for my university, I have to write versions in two or three languages.
Admittedly I tend to keep the versions in separate files, but simply specifying the option `bokmal` saves me having to remember what the exact packages and options were for that language.

The `fig`, `figdraft`, and `fignodraft` options are similar.
Each requests that certain packages be loaded with certain options.

### Different Versions ###

My lectures are now done as beamer presentations.
To keep a uniform look, I have all the lectures in one document and use the `\lecture` command to separate them.
So to compile a lecture, I need to tell `beamer` which lecture to use.
Rather than modify the file each time, I create a family of symlinks with name in the format `lecture.beamer.2010-08-23.tex`.
This class file then checks the jobname to see what mode to use (`beamer` in this case) and which lecture to produce (`2010-08-23` in this case).
Thus producing a different format or a different lecture is as simple as latexing a different file.
This also works if the date is missing meaning that different formats of the same seminar can be done similarly.
