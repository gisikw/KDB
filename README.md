# KDB - The KOS Filestore Database!

A reboot persistent file storage system for all your Kerboscript needs!

The contents of this repository are scripts intended for use
with the [kOS (Kerbal Operating System) mod](https://github.com/KSP-KOS/KOS)
for Kerbal Space Program.

The scripts are written in the Kerboscript language, which is described
on the [main documenation page for kOS](http://ksp-kos.github.io/KOS_DOC/).

## Usage

Want to save some stuff to a file? No problem! Here's how:

```
run kdb.

kdb_save("myDatabase", "Super important data!").
```

After your craft reboots, you can recover this information like so:

```
run kdb.

set data to kdb_load("myDatabase").
print data. // "Super important data!"
```

Okay, okay, fair enough. But that's boring data. We can do even better!

```
run kdb.

set data to lexicon().
data:add("The Mission", list(
  "1. Find the grail.",
  "2. Be more awesome.",
  "3. ???",
  "4. Profit!"
)).

kdb_save("myDatabase", data).
```

When we load this back up, you'll have all the data you saved! KDB looks at the
various types that you've saved, and will generate a myDatabase.kdb file that
allows you to restore anything you might like! Strings, numbers, lists,
lexicons, stacks, and queues are all supported, and you can nest them however
deep you want! Want lexicons of lexicons? Sure! Lists of lists! Absolutely!
You'll be popping and pushing so many stacks and queues that you'll be
completely willing to gloss over how overhyped this README is!

## Installation

Provided you have KOS installed, all you need to do is drop the kdb.ks file
into your Ships/Script folder, and you should be good to go. Happy scripting!

## Copyright and Legal Stuffs

Copyright (c) 2015 by Kevin Gisi, released under the MIT License.
