# Building a Character

## Races
Races are intended to be purely aesthetic and creative, this is also how we can use any system.
We found in developing the game that having a race as an aesthetic element people would make more thoughtful choices on race.

For example people would not take a half-orc simply because they wanted +2 strength, they could take an elf with points distributed every level into Strength.
Now you have a far more creative super buff elf, rather then a half-orc for strength sake.

## Classless
There are none. Classes can cause odd identity riffs with players. 
We found in developing the game that having a classless system really focused our energy on defining oneself by ones' actions. We believe ones actions make who you are, not what you are told you are.

## Stats
Setting stats at level 1 is simple, STR/DEX/MIND start with the value 3.
Every level you get a point to spend and this is how you can really mold your character into something unique.

|Stat|Directly Effects|
|----:-:|----:-:|
|Strength|Melee Damage, Melee %, Melee CM, MD|
|Dexterity|Ranged Damage, Ranged %, Ranged CM, RD|
|Mind|Spell Damage, Spell %, Spell CM, SD|

## Upbringing
Upbringing is like races in most systems, all the information you need is on the following table.

|Upbringing|Effect|
|:----:-:|:-----:|:----:-:|
|Body Hardened|MD+2|
|Dodgy|RD+2|
|Spell Hardened|SD+2|
|Heroic|Heroism+2|
|Melee Trained|MeleeCM+2|
|Range Trained|RandedCM+2|
|Spell Trained|SpellCM+2|

```
```

## Talents
Talents are special abilities that have unique effects in game that are not achievable otherwise. Be carefully when choosing, you only get one. These could be modified for your system, these are made with a fantasy setting in mind, notice they are not directly modifying stats directly and have conditions.

|Talent|Description|
|:-|:-|
|Backstab|If sneak skill checks, double Melee CM|
|Alchemist|Create single use potions per heroism spent|
|Rage|1 HP increment cost gets +1 All CM and -1 All D for encounter|
|Artificer|Imbue Heroism onto gemstone at gem level (value / 20) charges|
|Turn Undead|Lower all undead defenses by 4 for 4 rounds per encounter|
|Inspire|Allies get one extra heroism roll per level|
|Telepathy|Willing two way mind link, Mind Score distance feet|
|Cleanse|Remove all rounds for one effect, from one target per combat (touch)|
|Magic Synergies|Add 2 points to a single spell per encounter|

## Health Points
Health (HP) is simply calculated statically at __6/level__


\page

## Melee, Ranged, and Spell damage
Damage is determined by your stats. We realized people would just take a Greatsword because it did the most damage, not because it fit the character they were building.

There are three classes of melee weapons, two-handed, single-handed, and side arm. Of them, a single primary and secondary weapon can be chosen. The secondary should be a side arm type @ str minus 4 (see below). The weapons, remember, are purely aesthetic and a creative element to your character.

Damage is determined by taking the correlated stat score, looking at the roll chart below and locating the amount of melee/ranged damage you can do.

Ex.
At level 7 with STR and DEX both at 5, you could get say:

|Slot|Weapon|Damage|Combat Modifier|
|:-:|:-:|:-:|:-:|
|Melee|Rapier|1d10|+5|
|SideArm|Dagger|1d4|+1|
|Ranged|Shortbow|1d10|+5|
|Spell|Elemental|2d4|+3

### Roll Chart for Damages

|Pts.|Roll|::|Pts.|Roll|::|Pts.|Roll|::|Pts.|Roll|::|Pts.|Roll|::|Pts.|Roll|
|:-----:|:-----:|:-----:|:-----:|:-----:|:-----:|:-----:|:-----:|:-----:|:-----:|:-----:|:-----:|:-----:|:-----:|:-----:|:-----:|:-----:|
|1|1d4|::|11|3d6|::|21|3d10|::|31|7d6|::|41|3d20|::|51|8d12|
|2|1d6|::|12|5d4|::|22|8d4|::|32|8d6|::|42|8d8|::|52|10d10|
|3|2d4|::|13|2d10|::|23|4d8|::|33|6d8|::|43|7d10|::|53|5d20|
|4|1d8|::|14|1d20|::|24|9d4|::|34|4d12|::|44|9d8|::|54|9d12|
|5|1d10|::|15|6d4|::|25|6d6|::|35|5d10|::|45|6d12|::|55|10d12|
|6|3d4|::|16|4d6|::|26|3d12|::|36|9d6|::|46|10d8|::|56|6d20|
|7|2d6|::|17|3d8|::|27|10d4|::|37|7d8|::|47|8d10|::|57|7d20|
|8|1d12|::|18|2d12|::|28|5d8|::|38|10d6|::|48|4d20|::|58|8d20|
|9|4d4|::|19|7d4|::|29|4d10|::|39|6d10|::|49|7d12|::|59|9d20|
|10|2d8|::|20|5d6|::|30|2d20|::|40|5d12|::|50|9d10|::|60|10d20|

## Combat Modifiers
You will notice combat modifier in the table above, this is added statically to your damage when you roll.
To calculate Combat Modifier (CM) you do:

|CM Slot|CM Calculation|
|:-:|:-:|
|Melee|STR|
|SideArm|STR - 4|
|Ranged|DEX|
|Spells|MIND|

There are items in the game that increase each individual statistic.

```
```

## Defenses
Similar to CM, this scales with stats as well

|Defense Slot|Defense Calculation|
|:-:|:-:|
|Melee Defense (MD)|STR + Armor|
|Ranged Defense (RD)|DEX + Armor|
|Spell Defense (SD)|MIND + Armor|

## Armor
Armor is what helps to raise your defenses.

Armor total is Armor + Shields
Armor can be bought, found or stolen. Whatever it may be it should have a range of 1-9 for balance sake. Shields also can give you armor bonus.

Splint Mail - 6 for example would give you 6 armor.
Small Shield - 2 would be 2 armor

Armor has a direct correlation with all failure percentages, meaning if you have a armor with 6 and a shield with 2, you will have 8% higher failure rate on melee, ranged and spells. This offers some level of balance for tank style characters. (more on failure rates later)

Armor affects all forms of defense, Melee, Ranged, and Spell Defenses (MD, RD, SD)

## Failure Rates
All failure rates are calculated with __[25 - Stat + Armor]__. Melee fail rate for someone with 4 armor and 5 strength would be __[25 - 5 + 4 = 24%]__
Ranged, like other area correlates to dexterity and spells similarly correlate to mind.

\page
## Skills
We have opted to drop the skills list entirely and make it more based on roleplay and how you use your character.

> Examples:
* A character who routinely messes with different mechanical things in game wants to pick a lock, the GM recognizes his tinkering and rewards the roleplaying with a better probability on a d20 roll to pick the lock, he calls out 10, if the player rolls over a 10 he succeeds. 
* A character who routinely is trying to find a library to read in and study wants to see if he knows anything about an animal they came across in the wild, the GM recognizes this library bookworm and rewards him with a better probability in checking the animal, he/she calls out "You must beat a 5" and the player rolls a d20.

All skills are based on roleplay and if in several games you have not been using your skills in roleplay, the GM may start to forget you have that trait and start to make your skill checks much more mundane like 17 or 18. This system streamlines the DM's job and makes the game more oriented to roll playing and less about meta-gaming.

A roll of 1 will always fail, and a 20 will always succeed, meaning even mundane people can do extraordinary things, it is just 5% probable.

The GM holds the right to flat out say no, it is his world and if a skill or spell you are trying to use while role playing would break the game, he might just say "No."

## Heroism
Heroism is the ability to do something heroic and creatively cool. If a player can come up with a very cool or inspiring visual to add to the game he/she can use his heroism to gain _Advantage_ on any roll type.

> This ability can be used only once per level, and do not roll over. Heroism must be voiced and described prior to making the roll.

## Advantage / Disadvantage
* Advantage is getting to roll twice and take the higher of the two rolls
* Disadvantage is rolling twice and taking the lower of the two rolls

## Master Rule
The GM has the right to change everything and anything in the world, the game, the mechanics or anything else related to the game. GM is god of his world and overrides all rules set in this document.

\page

# Combat Cadence

## Initiative
Everyone first rolls initiative, there is no modifiers, it is just a straight d20 roll, ties roll again until unique values are struck.

## Combat Turn
Each turn, you can do both a movement and an action.
Movement is limited by your speed in squares. (Usually 6 unless spell modified)
Actions generally will be damage or a spell but could also be a skill check.

You can forego your action for a second movement if you wish.

## Rolling Damage Melee/Ranged
Both Melee and Ranged are the same, aside from the distance. Anything further than directly adjacent to an enemy is Ranged. So a 10ft polearm or a whip would fall under a Ranged weapon.

> Every combat action follows this same cadence
* Roll your failure check using a d100
* Roll the damage dice listed on your character sheet (ex. 1d10)
* Add your CM (ex. +5) to the damage dice roll total
* The GM will take the corresponding defense of the opponent (melee, ranged or spell) and subtract it from you roll total, the difference is the amount of damage dealt, which is then subtracted from the HP of the combatant

\page 

<div class='wide'>
## Rolling Spell Damage

Spells are exactly the same, except your area and range must be taken from your spell points (spell points = mind score).

- Range is the shortest number of blank squares in between a target and yourself
- Area is the all of the contiguous squares you wish the spell to cover starting at the end of the range.
- Number of rounds = 2 points per round

Ex. I want to hit one target standing on a tile 3 squares away for 1 full round. My area is 1 (target square), my range is 2 (blank squares between) and my rounds is 1 (costs 2). This would require a spell points total (mind score) of 5 to cast.

### Spell Effects

Effects of a spell are choosen from the table listed below. Choose an element to give the spell a specific character and describe what the spell does in roleplay. The effect of the spell is limited to the choices in the table, but the description is free form.

|Element|Effect|Effect Type|
|:-|:-|:-:|
|Electricity|Damage (Concentration per round) @ Remainder Damage|Remainder|
|Fire|Add / Reduce Failure %|Half SCM|
|Water|Add or Reduce Single Defense|Half SCM|
|Ice|Dispel number of rounds effect|Half SCM|
|Earth|Change Speed (minimum 1)|Half SCM|
|Wind|Imbue Element on Weapon|Half SCM|
|Poison|Telekenisis (scm x 5 lbs at scm distance)|SCM x 5|
|Force|Healing|SCM|
|Acid|Teleportation (physically accessible, ally, move action)|SCM|
|Oil|Illusion\Sound\Distraction\Obstruction - Disadvantage/Advantage|Toggle|
|Spirit|Stun/Pin/Fall Prone/Knockdown - Lose action or movement|Toggle|
||Aura - All rolls vs spell target get - Advantage\Disadvantage|Toggle|

### Effect Types
- Remainder is the difference between the roll and combat modifier minus defense, this is just like melee and ranged
- Concentration means the spell will do the same remainder as previous rounds if you lose your next turn without getting hit
- Half SCM/SCM/SCM * 5 these are the total amount of the effect if the spell triggers (ie. the total rolls and modifiers is over the target defense) [round down]
    - Ex. A speed changing spell that rolls 1d20 and has a 3 SCM modifier. The caster rolls a 18 + 3 = 21 total, the target defense is 5. The spell triggers because it was over the spell defense, but the target only loses 1 movement speed because it is a half scm type spell. The scm of 3 was halved to 1.5 and rounded down to 1.
- Toggle is very similar to the above, the effect just happens, these spells do not have numerical value.

### Spell Effects Per Target
A target or player can have only one ally and one enemy effect at a time. The most recent effect applied to a target will take over the slot and the old spell will dissipate. An ally cannot directly cast against a enemy spell slot but could potentially directly counter a spell in the ally spot.

- Ex. If I have an enemy stun type spell on me disabling my movement for 3 more rounds, and an enemy casts a spell that increases my melee failure percentage, the enemy stun spell is removed and replaced by the more recent melee failure spell. In this case, if an ally were to make an Imbue Element on my weapon, it would continue to take effect even though the other enemy effect was replaced.

### Spell Effect Over Area
If your area covers multiple targets, the difference is derived from the highest target spell defense, the remainder in the case of damage is based on this highest target defense and can be split numerically through the number of targets.

- Ex. Three targets are assigned in my fireball area of effect. The target spell defenses are 7,5, and 6. My total roll + modifiers is 12. The total damage I can distribute is 12-7=5, and I choose to give 3 to target 1, 1 to target 2 and 1 to target 3.

This has the same effect on toggle spells and scm based spell effects. It only toggles when the spell beats the highest spell defense in the area. The SCM or Half-SCM or whatever is then distribute like the example above.

</div>
\page

## Combat Style Benefits
* Melee has the ability to try a sidearm if the melee fail % is triggered
* Ranged has the ability to do damage at great range
* Spells have the ability to distribute damage and versatile effects over an area

## Combat Strategy
* Seek the enemies that seem to have the lowest defense to your strong stat
* Use magic as a strategy tool
* Take out the Ranged characters too, they will eat you alive if you dont
* 
\page

<div class='wide'>

## Monsters and NPCs

