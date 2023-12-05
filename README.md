# PwnedSearch
The popular website https://haveibeenpwned.com allows you to check email addresses to see if they have been included in any major security breach. They also offer a way to check passwords directly at https://haveibeenpwned.com/Passwords 

The problem with using their website to check a password is that you have to trust your browser, internet connection and haveibeenpwned.com with your privacy. While haveibeenpwned.com has come up with a great way to deal with security and privacy, I still prefer an offline search and fortunately they allow you to download the list of hashed password they use. Information on downloading the hashed password list can be found here: https://haveibeenpwned.com/Passwords

The next problem is that the list is very large (21GB uncompressed) and can't be easily searched. This tool, written in AutoIT will allow you do a very quick search using a binary search technique. A traditional linear search could take hours but a binary search on even a file 100x this size will take under a second.

Check the release section to download the latest binary file or you can install AutoIT and run the source script PwnedSearch.au3.
