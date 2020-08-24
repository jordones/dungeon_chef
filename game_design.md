# Game Design

This document serves as the guiding design document for **Dungeon Chef**.

## Premise

**Dungeon Chef** is a **grid based** game where the goal is to choose and occasionally combine items in order to deliver them to the guests, satisfying their requests.
Requests are based on the guest's needs: they could be low on health or mana or both. The goal is to ensure heroes are healthy and ready for adventure!

## Components

### Floors

The game will transition levels by going up/down a set of stairs that become available upon completing a level.
Each floor is a level, where the player will have a certain amount of time to fulfill all of their orders in order to proceed.

### Recipes

Recipes represent the different permutations that exist for cooking with the ingredients that can be found throughout the dungeon. A recipe has an outcome that effects health or mana. Outputs have a modifier that represent the net change in the health or mana stat.

### Customers
Customers are the heroes that visit the player on each floor. Each customer has a unique sprite and a randomized need of health or mana, with a random amount required to satisfy their request as well.

