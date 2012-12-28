# What is it?

Peasant is a tiny repository dependency manager. Basically you just declare what repositories (and revisions) your project depends on, and Peasant uses Hg or Git to fetch the right revision for you.

Supported version control software:

* Hg
* Git

It works with Windows, Linux and probably Mac also. Basically anywhere where Ruby runs and "git" and "hg" can be ran from command line.

# How does it work

It works by you writing a Peasantfile in the root of your repository. The Peasantfile is JSON-encoded.

Peasant basically just transforms the repositories mentioned in Peasantfile into "hg ..." or "git ..." commands, and lets shell execute the commands for you.

## The algorithm goes like this

1. If the directory mentioned in "path" does not exist, Peasant creates it for you. (supports subdirectories)
2. terve

## Example Peasantfile

    {
        "repositories": [
            {
                "path": "chef_cookbooks/apache2",
                "url": "git://github.com/opscode-cookbooks/apache2.git",
                "revision": "e340cefcd4265a81c7c3b09d762fad166cff318e",
                "type": "git"
            }
        ]
    }

More examples are found in examples/ directory.

# Platform support

## Linux & Mac

Currently untested. Should work by running:

$ ruby peasant.rb

And if the output seems decent, run:

$ ruby peasant.rb | sh

## Windows

### Compiling the .exe

Currently tested on Windows. To compile it for Windows, see windows/ocra.md

### Compiling the installer (peasant-setup.exe)

To create the installer, install NSIS ( http://nsis.sourceforge.net/Main_Page )

You can compile the installer by right clicking on windows/setup.nsi and selecting "Compile NSIS script".

The installer will be created in bin/peasant-setup.exe