. ./EberronCharacter.ps1

class Session {
    
    Session ($Number) {
        $this.GenerateContent()
        switch ($number) {
            1 {$this.CreateIntroSession}
            2 {$this.CreateMiddleSession}
            3 {$this.CreateFinalSession}
            Default {throw 'Not a valid session number, must be 1,2, or 3.'}
        }
    }

    [Void] GetCommonContent () {
        # Ally 2
        # Side Quest 2
        # Eberron Level Quest Lore 3
        # External Org Lore 3
        # Nuetral
        # Villian
        # Treasure d100 list
        # Monster Groups 5
        # NPC Groups 5
        # One of Each Vendor (large size)
        # Giant's Bag d20
        # 5 Emergency Plot Ideas
        # 20 Quick NPCs
        # 3 Weathers
        # 20 Traps
        # 2 Legendary Weapon
        # Ancient Tome
        # Random Inn Generator
        # 6 Pickpocket Loot Generator
        # Castle
    }

    [Void] CreateIntroSession () {
        # Introduction Scene
        # Introduce Eberron Charter Character Ally 1
        # Level Quest Intro - Introduce the Villian (Level Boss)
        # Side Quest 1
        # Talk some mid dungeon Eberron lore
        # Epic 'Dungeon' (side quest) (Memorable Dungeon Descriptions and Layout, Projector Choosen Map)
        # 2 monster groups (2 x treasure)
        # Talk about rumors of other organizations of trouble
        # 1 npc groups (Giant treasure)
        # Something Main Quest Happens
        # Turn in- Banter/Shop
    }

    [Void] CreateMiddleSession () {
        # Introduction Scene
        # Eberron Charter Character Ally 1
        # Talk about rumors of other organizations of trouble
        # Side Quest 2
        # 1 npc group (treasure)
        # Random 'Dungeon' (side quest)
        # Talk Eberron Lore
        # Level Quest - Plot twist the villian, or make him/her directly affect the party
        # 1 npc group (treasure)
        # 1 monster group (Giant treasure)
        # Mini- Hoard (2x treasure)
        # Something Epic Main Quest Happens
        # Introduce Nuetral Character Somehow (consequence)
        # Turn in- Banter/Shop
    }
    
    [Void] CreateFinalSession () {
        # Introduction Scene
        # Eberron Charter Character Ally 2 Intro - Dialog with Boss Build Up
        # Gear Up!
        # Something Epic Happens with Level Quest
        # Talk Eberron Lore
        # Simple 'Dungeon' (5 room dungeon, puzzles, magic, traps)
        # Impeded or assisted by Nuetral Character's reaction to Party (consequence)
        # 1 NPC group (Giant treasure)
        # 1 Monster group (treasure)
        # Talk about rumors of other organizations of trouble
        # Epic Boss Battle with 1 NPC Group 1 Monster Group 1 Villian
        # Hoard (4x treasure)
        # Turn in- Banter/Shop
        # Eberron Charter Characters 1 and 2 each reward with a 'house' award (IE, Legendary Item (given to level roleplaying mvp as voted by table) or Intangable and GM Catered)
        # Introduce Main Quest Reward and Lead
        # Decide on next Main Quest action
    }
}