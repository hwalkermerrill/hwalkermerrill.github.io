# hwalkermerrill.github.io

Full‑Stack TTRPG Campaign Manager & Seven‑Year GM Archive  
Version 3.0 Development
Public Repository for School (BYU-I) and Private Use

## Author

Student / Developer / GM: Harrison Merrill
Location: Okinawa, Japan
Years Active: 2019–Present

## License

MIT License
ORG License
ORC License
(See License file for full details)

## Main Overview

This repository is the home of my long‑running tabletop RPG campaign manager — a passion project I’ve been building, refining, and expanding for over seven years.
It began as a static GitHub Pages site and has evolved into a full‑stack, database‑driven application that supports:

- Player and NPC character profiles
- Session journals
- Secret notes for players and the GM
- Session planning notes and tools
- Item and loot tracking
- Map references
- Rules, house rules, and table guidelines
- Campaign‑specific modules

Version 3.0 marks the next major evolution of this project:
A unified, modernized, full‑stack application with OAuth authentication, MongoDB persistence, MVC architecture, and a fully redesigned CSS system using tokens and layers.
This project also serves as a living archive of my growth as a developer and GM, preserving past campaigns while powering new ones.

## PgAdmin 4 ERD Export

The ERD has been exported from pgAdmin in image form, and can be located in the directory public/images/core/pathfinder-erd.png

## User Roles

user - Default, a player or other user with basic access
gm_admin - The Game Master or site admin with full system access
moderator - Game Moderators with permissions to manage content and users

## Relevant File Structure

hwalkermerrill.github.io
├── archived/
│ ├── azlant/
│ ├── councilofthieves/
│ ├── war4crown/
│ └── .../
├── public/
│ ├── css/
│ ├── images/
│ ├── js/
│ └── resources/
├── src/
│ ├── controllers/
│ ├── middleware/
│ ├── models/
│ ├── utils/
│ └── views/
├── LICENSE
├── package.json
├── README.md
├── restore.js
└── server.js

## CSS Layers

public/css/
├── base/
├── components/
├── layout/
├── tokens/
├── utilities/
├── vendors/
└── main.css

## Tech Stack

Node.js / Express — Backend
MongoDB Atlas — Database
Render — Deployment
EJS — Templating + partials
pnpm — Package management
OAuth — Authentication
CSS Layers + Tokens + lightningcss — Styling
MVC Architecture — Architecture

## Known Limitations

Several files are still being migrated into the database from being hardcoded HTML data.
Several ejs files still contain hardcoded HTML data (as above) rather than dynamically generated data.
Several ejs files still need to be split into multiple partials/ dynamic files.
The actual differences between user and moderator roles and their capabilities is not yet established.
A great deal of content needs to be created for this newest campaign.

## Features to be Implemented

Migrate character creation from static ejs to dynamic multi-staged process, culminating in a user submission.
Change hero image settings to be dynamically settable from an interface.
Change spotlight settings to be dynamically settable from an interface.
Change PCs, NPCs, Factions, and Items to be dynamically displayed and filterable.
Change Surveys to dynamically set data from DB, allow main map to be dynamically settable from interface and changeable from users perspective.
Create detail page for characters or objects, embed editing there.
Setup Dashboard displays.
Setup CSS to be served dynamically.
Add quests to Travel Log
Add calculator to home model for knowledge checks
Refactor python crit generator and implement
Allow Moderators and GMs to edit the characters of other players and descriptions of other objects.
Allow all players to submit session notes for approval, and allow moderators and GMs to approve session notes as session logs.
Allow moderators and GMs to edit titles and achievements of players and npcs, and ownership of items and companions.
Allow GMs to add new objects of all types, as well as view and edit secret boxes.
Allow GMs to change statuses of PCs, items, npcs, and factions, delete content, add content, and change content flags (is_hidden, is_tall, reveal_hidden_details, ect.)
Some sort of relationship meter that players can see to see how close they are to advancing/falling in a relationship [aka progress bar].
Make \_card partial for assets to unify styling.
Add subtitle logic

## Current Minor Bugs or Visual Errors

Database data for tribes does not match hardcoded home data exactly. Minor corrections in wording need to be addressed.
Remove development objects from production.
Increase top and bottom padding for form entry boxes, as well as internal margin and spacing between form boxes.
Optimize performance of db queries

## Roadmap Checklist (Version 3.0)

Backend & Database
[ ] Create new MongoDB Atlas database
[ ] Implement user model with roles
[ ] Integrate OAuth authentication
[ ] Build GM‑only middleware
[ ] Create CRUD routes for characters
[ ] Create CRUD routes for NPCs
[ ] Create CRUD routes for items/loot
[ ] Create CRUD routes for notes & journals
[ ] Implement campaign metadata model

Frontend & Views
[ ] Convert all views to partial‑driven EJS
[ ] Build reusable card components
[ ] Build player dashboard
[ ] Build GM dashboard
[ ] Build character creation workflow
[ ] Build NPC gallery
[ ] Build item/asset gallery
[ ] Build session journal pages
[ ] Build map pages
[ ] Build rules pages

CSS Modernization
[ ] Create tokens layer
[ ] Create base layer
[ ] Create layout layer
[ ] Create components layer
[ ] Create utilities layer
[ ] Integrate lightningcss or similar build step
[ ] Archive legacy CSS

Campaign: Wrath of the Righteous
[ ] Create campaign folder
[ ] Build campaign home page
[ ] Add initial NPCs
[ ] Add initial PCs
[ ] Add initial loot tables
[ ] Add session 0 notes
[ ] Add maps
[ ] Add rules & house rules

Cleanup & Migration
[ ] Remove Serpent’s Skull backend data
[ ] Preserve static archive
[ ] Consolidate web services code
[ ] Consolidate CSS repo content
[ ] Prune unused pnpm packages

Deployment
[ ] Connect Render to main repo
[ ] Configure environment variables
[ ] Test OAuth login
[ ] Test database operations
[ ] Invite players to test character creation
