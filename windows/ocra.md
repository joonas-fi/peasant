# What

"OCRA (One-Click Ruby Application) builds Windows executables from Ruby source code. The executable is a
self-extracting, self-running executable that contains the Ruby interpreter, your source code and any
additionally needed ruby libraries or DLL."

- http://ocra.rubyforge.org/

# Installing ocra

$ gem install ocra

# Building

To build peasant-rb.exe, run this command from the root of the repository:

$ windows\ocra-build.bat

This command compiles bin\peasant-rb.exe, which is ran by peasant.bat

# What is it used for?

The NSIS installation process bundles peasant.bat and peasant-rb.exe as the installable application of Peasant.
The .bat file simply runs peasant-rb.exe and feeds its output to cmd.exe (Windows' command processor).
