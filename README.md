# hwalkermerrill.github.io

Public Repository for School (BYU-I) and Private Use

## Author

Harrison Merrill

## Main Overview

The purpose of this website is to support a passion project. Specifically, this website is intended to contain
data about a local tabletop game run by the student - Harrison Merrill. This website will contain several pages,
each with a specific purpose - general overview of the game format, player character creation instructions,
details on discoveries made and items found by the players, player profiles, npc profiles, maps of location, a
journal of activities at each session, and a lengthy rules and reference segment. By containing all of this
information on an interactive site, it will reduce the overhead on book-keeping, have images to associate with
major character, items, and locations, and create a community notes/reference for the game table so that everyone
can more easily remember both what happened already and things their characters would already know. It also
provides a place for me (the person running the game) to embed notes on things I want to develop, have developed
that the players have not yet uncovered, and have developed for the players (so that I can remember what already
exists). Frankly, it takes a lot of work, running a game, and by placing everything on a website, it creates a
more interactive and easy to read set of notes as compared to a simple word document and excel files.

## PgAdmin 4 ERD Export

The ERD has been exported from pgAdmin in image form, and can be located in the directory public/images/core/pathfinder-erd.png

## User Roles

user - Default, a player or other user with basic access
gm_admin - The Game Master or site admin with full system access
moderator - Game Moderators with permissions to manage content and users

There are test accounts of each type using the usernames of "test4[rolename]" for demonstrative purposes.

## Known Limitations

Several files are still being migrated into the database from being hardcoded HTML data.
Several ejs files still contain hardcoded HTML data (as above) rather than dynamically generated data.
Several ejs files still need to be split into multiple partials/ dynamic files.
The actual differences between roles and their capabilities is not yet established.
There is not currently a way for any user to edit database content.
There is no multistage workflow system in place.

## Features to be Implemented

Migrate character creation from static ejs to dynamic multi-staged process, culminating in a user submission.
Change hero image settings to be dynamically settable from an interface.
Change spotlight settings to be dynamically settable from an interface.
Change PCs, NPCs, Factions, and Items to be dynamically displayed and filterable.
Change Travel Log to dynamically set data from db.
Change Surveys to dynamically set data from DB, allow main map to be dynamically settable from interface and changeable from users perspective.
Setup Dashboard displays.
Setup CSS to be served dynamically.
Allow Moderators and GMs to edit the characters of other players and descriptions of other objects.
Allow all players to submit session notes for approval, and allow moderators and GMs to approve session notes as session logs.
Allow moderators and GMs to edit titles and achievements of players and npcs, and ownership of items and companions.
Allow GMs to edit user permissions, and add new objects of all types, as well as view and edit secret boxes.
Allow GMs to change statuses of PCs, items, npcs, and factions, delete content, add content, and change content flags (is_hidden, is_tall, reveal_hidden_details, ect.)

## Current Minor Bugs or Visual Errors

Database data for tribes does not match hardcoded home data exactly. Minor corrections in wording need to be addressed.
Images that do not have an attached file need to default to a placeholder image.
No working search bar.
500 error page does not fail gracefully when the database cannot be reached.
Sticky notes currently not interactive.
Remove development objects from production.
Increase top and bottom padding for entry boxes, as well as internal margin and spacing between form boxes.
Set logged in only tabs to different navigational bar.
