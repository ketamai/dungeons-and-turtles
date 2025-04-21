# Dungeons & Turtles

## Overview
Dungeons & Turtles is a World of Warcraft addon for version 1.12.1, specifically designed for the Turtle WoW server. It provides Dungeon Masters (DMs) with tools to run D&D-style campaigns within the game.

## Technical Specifications

### Core Requirements
- WoW Version: 1.12.1
- Server: Turtle WoW
- Language: Lua
- API: WoW 1.12.1 Addon API

### File Structure
```
Dungeons_and_Turtles/
├── Core/
├── Libs/
├── Modules/
├── UI/
├── Dungeons_and_Turtles.lua
├── Dungeons_and_Turtles.toc
└── README.md
```

### Dependencies
- Required: AceLibrary and Ace2 Suite
- Optional: Total RP 3 (for character profile integration)

### SavedVariables
- Primary DB: `DMsToolkitDB`

## Features

### 1. Campaign Management
- Create, save, and load campaign states
- Track story progress and player statuses
- Intuitive UI for campaign creation and management
- Persistent storage using WoW's saved variables

### 2. Player Tracking
- Monitor D&D character attributes:
  - Core stats (strength, dexterity, etc.)
  - Character levels
  - Inventory tracking
- Optional Total RP 3 integration
- UI for viewing and editing player data

### 3. Event Triggering
- Send custom messages/alerts to players
- Simulate game events
- Integration with WoW's chat system
- [DM] prefix for official communications

### 4. Map Integration
- Mark campaign-relevant locations
- Custom waypoints and markers
- Utilizes WoW's map API
- UI for location management

### 5. Custom Chat Channel
- Dedicated communication channels:
  - In-character communication
  - DM narration
- Implementation through PARTY chat with [DM] prefix
- `/dm` command for DM messages

### 6. Narrative Tools
- Journal/log system for:
  - Story arcs
  - Quest tracking
  - Player choices
- NPC management system
- Text-based narrative elements

## Technical Constraints

### Addon Limitations
- Cannot modify game world
- Cannot spawn NPCs
- Limited to UI, chat, and data management
- Must work within WoW API restrictions

### Performance Requirements
- Minimal impact on gameplay
- Efficient resource usage
- Compatible with other essential addons

## UI/UX Guidelines

### Interface Design
- Clean, intuitive main panel
- Easy access to all features
- Consistent with WoW's UI style
- Responsive and user-friendly

### Chat Integration
- Clear distinction for DM messages
- Non-intrusive notifications
- Easy-to-use command system

## Development Guidelines

### Code Style
- Clean, documented Lua code
- Meaningful variable names
- Modular structure
- Namespace: `DT` or `DungeonsAndTurtles`

### Best Practices
- Error handling
- Performance optimization
- Regular testing
- Community feedback integration

## Community Integration

### Support
- Documentation
- User guides
- Community forums participation

### Feedback
- Regular updates based on user feedback
- Bug tracking and resolution
- Feature request system

## Testing Requirements
- Functionality testing
- Performance testing
- Compatibility testing
- User acceptance testing