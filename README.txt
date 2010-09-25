=============================================================================
                                                                  ezElf
-----------------------------------------------------------------------------

Premiere Web3.0 music streaming software.


Requirements:

  - Apache 2.x with mod_xsendfile (http://tn123.ath.cx/mod_xsendfile/)
                  or
  - Lighttpd with allow-x-sendfile enabled
  - Ruby gems: rails, scrobbler, rbrainz
    

How to Install:

  1) create "config/database.yml"
     (see the example database.yml-{mysql,sqlite} files in the "config" dir)
  2) run "rake db:migrate"
  3) run "script/server"
  4) go to "http://localhost:3000/sources"
  5) add a source that points to your mp3 collection
  6) run "ruby update" to import all your songs (or check for
     modified or newly updated songs)
  7) go nuts!


Extra stuff:

  To nuke your database and re-import all the mp3's, run "ruby update -n".


