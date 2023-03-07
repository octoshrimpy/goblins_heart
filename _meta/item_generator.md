quality
  item
    stinky
    shiny
    dirty
    muddy
    old
    soft
    clean
    pristine
    sturdy
    ancient
    thick
    heavy
    sparkly
    smooth
    textured
    small
    large

  food
    stinky
    yummy
    bland
    salty
    sweet
    savory
    rotten
    cold
    warm
    filling
    spicy
    healthy

color
  red
  blue
  green
  yellow
  teal
  maroon
  purple
  violet
  orange
  pink
  white
  grey
  black
  brown

material
  gem
    ruby
    diamond
    opal
    sapphire
    topaz
    amber
    peridot
    obsidian
    garnet
    quartz

  ore
    metal
      silver
      copper
      iron
      aluminum
      gold
      titanium

    nonmetal
      magnesium
      sulfur
      phosphor
      potassium

food
  fruit
    tree
      apple
      plum
      orange
      fig
      avocado
      mango
      kiwi

    bush
      blueberry
      gooseberry
      strawberry
      raspberry
      blackberry
      mullberry
      cloudberry

  meat
    tofu
    chicken
    pork
    beef
    sausage
    hamburger
    veal
    lamb
    turkey
    duck
    rabbit
    goat
    boar
    pheasant
    venison

  helpers
    cheese
    broth
    milk
    cilantro
    egg

  spices
    pepper
    salt
    cinnamon
    cumin
    ginger
    paprika
    bay leaf
    basil
    mustard
    cayenne
    horseradish
    lavender
    sage
    rosemary
    vanilla
    mint

  grain
    oat
    rice
    corn
    quinoa
    wheat
    barley

  veggie
    pumpkin
    peas
    corn
    asparagus
    spinach
    tomato
    bell pepper
    potato
    carrot
    turnip
    onion
    garlic
    leek
    lentil

  mushroom
    splash trumpet
    fly fingers
    pixie shroom
    truffle
    dyeball
    club coral
    brown coccora
    wrinkly conk
    tinder jack
    coal jelly
    winter horn
    goblin's pride

forage_depth
  canopy
  bushes
  surface
  sub_surface
  underground
  deep_underground

biomes
  jungle
  desert
  mesa
  forest
  swamp
  prairie

grouping
  plurals
    handful
    clump
    stash
    blob
    pile
    jar
  singular
    bit
    piece

container
  kettle
  bucket
  mug
  jar
  tea cup

forage
  nature
    stick
    goop
    leaf
    bug wing
    empty nail shell
    dirt
    fabric
    bark
    rotting log
    moss
    grass
    bone
    rock
    flower
    spider silk
    root

  adventure
    coin
    ring
    note
    purse
    knife
    bookmark
    paperweight  
    thingamabob
    dookickey
    dingus
    doodad
    whatsit
    door handle
    garden gnome
    ornament
    necklace
    earring
    glasses
    key
    painting
    wood carving
    sculpture
    glass bottle
    arrowtip
    brooch
    buckle
    pointy hat
    fork
    spoon

---

soup
  [very specific weighted] and [mushroom] soup

very specific weighted
  [meat]
  [veggie]
  [veggie]
  [veggie]

---

soup
  [meat||veggie%3] and [mushroom] soup

---

you find one bowl of [meat^0.25", "][veggie^0.25", "][mushroom^0.25] soup

you find one bowl of [mushroom^0.25||meat^0.25][" and "veggie^0.25] soup