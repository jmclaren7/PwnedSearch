# PwnedSearch
The popular website haveibeenpwned.com allows you to check email addresses to see if they have been included in any major security breach. They also offer a way to check passwords directly at haveibeenpwned.com/Passwords 

The problem with using their website to check a password is that have to consider the password less secure compared to if you check it locally on your computer.  Fortunately they allow you to download the list of hashed password they use, the link is at the bottom of the page at haveibeenpwned.com/Passwords (ordered by hash)

The next problem is that the list is very large (21GB uncompressed) and can't be easily searched. This tool, written in AutoIT will allow you do a very quick search using a binary search technique. A traditional linear search could take hours but a binary search on even a file 100x this size will take under a second.

Check the release section to download the latest binary file or you can install AutoIT and run the source script PwnedSearch.au3.

More information and updates will be avaialble soo, this is just the initial commit to get things started.
