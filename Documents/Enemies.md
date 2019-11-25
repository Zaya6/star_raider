<!-- TOC -->

- [1. The Enemies of Eterna](#1-the-enemies-of-eterna)
  - [1.1. The Western Plains](#11-the-western-plains)
    - [1.1.1. Slime](#111-slime)
    - [1.1.2. Ferret Man](#112-ferret-man)
  - [1.2. The Eastern Plains](#12-the-eastern-plains)
  - [1.3. The Northern Plains](#13-the-northern-plains)
  - [1.4. The Shadow Crags](#14-the-shadow-crags)
  - [1.5. The Splintered Woods](#15-the-splintered-woods)
  - [1.6. The Forge](#16-the-forge)
  - [1.7. The Crystal Springs](#17-the-crystal-springs)
  - [1.8. Leveling](#18-leveling)

<!-- /TOC -->

# 1. The Enemies of Eterna

Enemies are broken up into two types for simplicity. Regular and Giants. Giants have very special moves and more HP, which makes them kind of like mini-bosses.

Enemies are separated between the many regions of Eterna. Though for ease of development reusing enemies in different regions is encouraged.

## 1.1. The Western Plains

### 1.1.1. Slime
A basic enemy and example for other creatures

| Stats | Value |
| :---- | ----: |
| HP    |     1 |
| MP    |     0 |

| Special Ability | Use                   |
| :-------------- | :-------------------- |
| Split           | Spawns a second slime |

| Sprite | Use                 | Level of Completion |
| :----- | :------------------ | :-----------------: |
| Base   | idle                |         ---         |
| Move   | movement            |         ---         |
| Attack | Attacking           |         ---         |
| Split  | Using split ability |         ---         |

- [ ] Implemented in code
- [ ] Tested

### 1.1.2. Ferret Man
A basic enemy humanoid that can use items. Randomly spawns with 1 item to use (either: basic status item or basic scroll).

| Stats | Value |
| :---- | ----: |
| HP    |     1 |
| MP    |     0 |

| Special Ability | Use                             |
| :-------------- | :------------------------------ |
| Use Item        | Uses an item in their inventory |

| Sprite | Use        | Level of Completion |
| :----- | :--------- | :-----------------: |
| Base   | idle       |         ---         |
| Move   | movement   |         ---         |
| Attack | Attacking  |         ---         |
| Action | Using item |         ---         |

- [ ] Implemented in code
- [ ] Tested

## 1.2. The Eastern Plains

## 1.3. The Northern Plains

## 1.4. The Shadow Crags

## 1.5. The Splintered Woods

## 1.6. The Forge

## 1.7. The Crystal Springs

## 1.8. Leveling

/*idea is that the player should be able to progress as they want with higher risk or lower risk debating on the enemy they are fighting. If the enemy is a higher level than the player (and the player defeats it) then the player should earn more experience. However, If the player faces a lower leveled enemy than they are, then they might not gain much exp (if any in some cases)*/

    Int baseEXP = 50;
    Int playerLVL, enemyLVL, LVLCounter, extraEXP, deductedEXP, EXP;

    /////////////////checking to see if they are the same lvl or not///////////////////
    Check if the playerLVL == enemyLVL, if so than they earn the baseEXP

    ////////////////figuring out EXP if they are not the same lvl//////////////////////
    Else the following applies:
    Take player level and enemy level and do the following equation: playerLVL – enemyLVL = LVLCounter

    If LVLCounter is positive then do the following:
    extraEXP = LVLCounter*25;
    EXP = baseEXP + extraEXP; //how much the player earned in EXP

    If LVLCounter is negative then do the following:
    deductedEXP = LVLCounter * -1; //makes it a positive number
    deductedEXP *= 10;
    baseEXP – deductedEXP = EXP;
    if (EXP < 0){
    EXP = 0;
    }
