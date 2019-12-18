pico-8 cartridge // http://www.pico-8.com
version 18
__lua__

-- utils

function rep(s, n)
  return n > 0 and s .. rep(s, n-1) or ""
end

-- input

player = {
  class="",
  spell_slots = 6,
  spell_slots_used = 0
}
classes = { "paladin", "warlock", "rogue" }
spells = {
  { lvl=1, name="bless", prepared=false, casted=0, fav=false },
  { lvl=1, name="ceremony", prepared=false, casted=0, fav=false },
  { lvl=1, name="command", prepared=false, casted=0, fav=false },
  { lvl=1, name="compelled duel", prepared=false, casted=0, fav=false },
  { lvl=1, name="cure wounds", prepared=false, casted=0, fav=false },
  { lvl=2, name="aid", prepared=false, casted=0, fav=false }
}
spells_v2 = {
  { name="bane",
    school="enchantment",
    level="1st-level",
    casting_time="1 action",
    range="30 feet",
    components="v, s, m",
    duration="up to 1 minute",
    class="bard, cleric, paladin",
    description={"up to three creatures of","your choice that you can","see within range must make","charisma saving throws.","whenever a target that","fails this saving throw","makes an attack roll or a","saving throw before the","spell ends, the target must","roll a d4 and subtract the","number rolled from the","attack roll or saving throw."} },
  { name="branding smite", school="evocation", level="2nd-level", casting_time="1 bonus action", range="self", components="v", duration="up to 1 minute", class="paladin", description={"the next time you hit a","creature with a weapon","attack before this spell","ends, the weapon gleams","with astral radiance as you","strike. the attack deals an","extra 2d6 radiant damage to","the target, which becomes","visible if it's invisible,","and the target sheds dim","light in a 5-­‐‑foot radius","and can't become invisible","until the spell ends."} },
  { name="find steed", school="conjuration", level="2nd-level", casting_time="10 minutes", range="30 feet", components="v, s", duration="instantaneous", class="paladin", description={"you summon a spirit that","assumes the form of an","unusually intelligent,","strong, and loyal steed,","creating a long-lasting","bond with it. appearing in","an unoccupied space within","range, the steed takes on a","form that you choose, such","as a warhorse, a pony, a","camel, an elk, or a","mastiff. (your dm might","allow other animals to be","summoned as steeds.) the","steed has the statistics of","the chosen form, though it","is a celestial, fey, or","fiend (your choice) instead","of its normal type.","additionally, if your steed","has an intelligence of 5 or","less, its intelligence","becomes 6, and it gains the","ability to understand one","language of your choice","that you speak. your steed","serves you as a mount, both","in combat and out, and you","have an instinctive bond","with it that allows you to","fight as a seamless unit.","while mounted on your","steed, you can make any","spell you cast that targets","only you also target your","steed. when the steed drops","to 0 hit points, it","disappears, leaving behind","no physical form. you can","also dismiss your steed at","any time as an action,","causing it to disappear. in","either case, casting this","spell again summons the","same steed, restored to its","hit point maximum. while","your steed is within 1 mile","of you, you can communicate","with it telepathically. you","can't have more than one","steed bonded by this spell","at a time. as an action,","you can release the steed","from its bond at any time,","causing it to disappear."} },
  { name="hold person", school="enchantment", level="2nd-level", casting_time="1 action", range="60 feet", components="v, s, m", duration="up to 1 minute", class="bard, cleric, druid, paladin, sorcerer, warlock, wizard", description={"choose a humanoid that you","can see within range. the","target must succeed on a","wisdom saving throw or be","paralyzed for the duration.","at the end of each of its","turns, the target can make","another wisdom saving","throw. on a success, the","spell ends on the target."} },
  { name="hunter's mark", school="divination", level="", casting_time="1 bonus action", range="90 feet", components="v", duration="up to 1 hour", class="undefined", description={"you choose a creature you","can see within range and","mystically mark it as your","quarry. until the spell","ends, you deal an extra 1d6","damage to the target","whenever you hit it with a","weapon attack, and you have","advantage on any wisdom","(perception) or wisdom","(survival) check you make","to find it. if the target","drops to 0 hit points","before this spell ends, you","can use a bonus action on a","subsequent turn of yours to","mark a new creature."} },
  { name="misty step", school="conjuration", level="2nd-level", casting_time="1 bonus action", range="self", components="v", duration="instantaneous", class="druid, paladin, sorcerer, warlock, wizard", description={"briefly surrounded by","silvery mist, you teleport","up to 30 feet to an","unoccupied space that you","can see."} },
  { name="shield of faith", school="abjuration", level="1st-level", casting_time="1 bonus action", range="60 feet", components="v, s, m", duration="up to 10 minutes", class="cleric, paladin", description={"a shimmering field appears","and surrounds a creature of","your choice within range,","granting it a +2 bonus to","ac for the duration."} },
}

-- main screen module

function _paladin(x,y)
  spr( 0, x+0, y+0)
  spr( 1, x+8, y+0)
  spr(16, x+0, y+8)
  spr(17, x+8, y+8)
  spr(32, x+0, y+16)
  spr(33, x+8, y+16)
  spr(48, x+0, y+24)
  spr(49, x+8, y+24)

  spr( 0, x+24,  y+0, 1.0, 1.0, true)
  spr( 1, x+16,  y+0, 1.0, 1.0, true)
  spr(16, x+24,  y+8, 1.0, 1.0, true)
  spr(17, x+16,  y+8, 1.0, 1.0, true)
  spr(32, x+24, y+16, 1.0, 1.0, true)
  spr(33, x+16, y+16, 1.0, 1.0, true)
  spr(48, x+24, y+24, 1.0, 1.0, true)
  spr(49, x+16, y+24, 1.0, 1.0, true)
end

function _warlock(x,y)
  spr( 2, x+8, y+0)
  spr(18, x+8, y+8)
  spr(34, x+8, y+16)
  spr(50, x+8, y+24)

  spr(2,  x+15,  y+0, 1.0, 1.0, true)
  spr(18, x+15,  y+8, 1.0, 1.0, true)
  spr(34, x+15, y+16, 1.0, 1.0, true)
  spr(50, x+15, y+24, 1.0, 1.0, true)
end

function _rogue(x,y)
  spr( 3, x+0, y+0)
  spr( 4, x+8, y+0)
  spr(19, x+0, y+8)
  spr(20, x+8, y+8)
  spr(48, x+0, y+16)
  spr(36, x+8, y+16)
  spr(48, x+0, y+24)
  spr(50, x+8, y+24)

  spr( 3, x+24,  y+0, 1.0, 1.0, true)
  spr( 4, x+16,  y+0, 1.0, 1.0, true)
  spr(19, x+24,  y+8, 1.0, 1.0, true)
  spr(20, x+16,  y+8, 1.0, 1.0, true)
  spr(48, x+24, y+16, 1.0, 1.0, true)
  spr(36, x+16, y+16, 1.0, 1.0, true)
  spr(48, x+24, y+24, 1.0, 1.0, true)
  spr(50, x+16, y+24, 1.0, 1.0, true)
end

function main_screen_update()
  if (btnp(0)) main_screen.selected = main_screen.selected - 1
  if (btnp(1)) main_screen.selected = main_screen.selected + 1
  if (main_screen.selected > #classes) main_screen.selected = #classes
  if (main_screen.selected == 0) main_screen.selected = 1

  if (btnp(5)) then
    next_screen()
    player.class = classes[main_screen.selected]
  end
end

function main_screen_draw()
  _x = (128/2) - 16
  _y = (128/2) - 16
  if (classes[main_screen.selected] == 'paladin') then
    _paladin(_x,_y)
  end
  if (classes[main_screen.selected] == 'warlock') then
    _warlock(_x,_y)
  end
  if (classes[main_screen.selected] == 'rogue') then
    _rogue(_x,_y)
  end
  print(classes[main_screen.selected], 50, 82, 7 )
  print(main_screen.selected, 0, 0, 7 )
end

main_screen = {
  selected = 1,
  draw = main_screen_draw,
  update = main_screen_update
}

-- spells module

tooltip = false

function draw_sl()
  y=0
  tooltip_y = 0
  for key, spell in pairs(spells) do
    y = y+8
    col = 7
    if (spell.prepared) then
      col = 8
    end
    if (spell.fav) then
      print(spell.name .. rep("\143", spell.casted), 6 + 8, y + 2, 10)
    else
      print(spell.name .. rep("\143", spell.casted), 6 + 8, y + 2, 7)
    end
    print(spell.lvl, 8, y+2, col)
    if (spells[spells_list.selected] == spell) then
      print(">", 2, y + 2, 7)
      tooltip_y = y
    end
  end
  if (tooltip) then
    update_tooltip(spells[spells_list.selected])
    draw_tooltip(tooltip_y)
  end
end

function update_tooltip(spell)
  if (btnp(5)) then
    spell.fav = not spell.fav
  end
end

function draw_tooltip(y)
  rectfill(15,y+10,63,y+28,13)
  rectfill(14,y+9,62,y+27,6)

  rectfill(15,y+10,61,y+14,13)
  print("\146 favourite", 15, y+10, 0)
  print("\143 prepare", 15, y+16, 0)
  print("\152 details", 15, y+22, 0)
end

function update_sl()
  if (btnp(0)) then
    spells[spells_list.selected].casted = spells[spells_list.selected].casted - 1
    player.spell_slots = player.spell_slots_used - 1
  end
  
  if (btnp(1)) then
    spells[spells_list.selected].casted = spells[spells_list.selected].casted + 1
    player.spell_slots_used = player.spell_slots_used + 1
  end

  if (btnp(2)) spells_list.selected = spells_list.selected - 1
  if (btnp(3)) spells_list.selected = spells_list.selected + 1

  if (btnp(4)) then
    tooltip = false
  end
  if (btnp(5)) then
    --spells[spells_list.selected].prepared = not spells[spells_list.selected].prepared
    tooltip = true
  end
end

spells_list = {
  selected = 1,
  draw = draw_sl,
  update = update_sl
}

function draw_detail()
  cls(0)
end
function update_sd()

end

spell_detail = {
  draw = draw_detail,
  update = update_sd
}

-- main game loop module

screens = {
  selected = 1,
  main_screen,
  spells_list,
  spell_detail
}
function next_screen()
  screens.selected = screens.selected + 1
end

function _init()
  cls(0)
end

function _update()  
  screens[screens.selected].update()
end

function _draw()
  cls(0)
  screens[screens.selected].draw()
end

__gfx__
00000000000000000000000700000000000000050000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000600000000000000700000000000000560000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000007600000000000000700000000000000070000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000077600000000000000700005677775000070000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000777000000000000000705777777777600070000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00006770000000000000000706777777777777770000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00006770000000000000000700777777007777770000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00067770000000000070005700077777000777770000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00067770000000070077007700006777777777770000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00677770000000770000000000000006777777770000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00677777000007770005777700000000006775070000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00677777700077770077777700000000000000070000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00677777777777770777700700000000000000070000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00677777777777770005770700000000000000070000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00677777777777770000077700000000000000070000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00067777777777770000005700000000000006770000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00007777770777770075000000000000000007070000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00006777760777770750777700000000000005070000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000777760760677500707700000000000000070000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000006760770000005707700000000000000070000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000700777000007005700000000000000070000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000777700007005700000000000000070000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000777700000005700000000000000070000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000077777700000005700000000000000070000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000007777700000000700000000000000070000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000777700000000700000000000000070000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000077700000000700000000000000070000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000077700000000700000000000000070000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000007700000000500000000000000070000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000700000000500000000000000060000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000700000000500000000000000060000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000500000000000000060000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
