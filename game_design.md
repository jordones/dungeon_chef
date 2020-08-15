# Game Design

This document serves as the guiding design document for **Dungeon Chef**.

## Premise

**Dungeon Chef** is a **grid based** game where the goal is to choose and occasionally combine items in order to deliver them to the guests, satisfying their requests.
Requests are based on the guest's needs: they could be low on health or mana or both. The goal is to ensure heroes are healthy and ready for adventure!

## Components

### Floors

The game will transition levels by going up/down a set of stairs that become available upon completing a level.
Each floor is a level, where the player will have a certain amount of time to fulfill all of their orders in order to proceed.
