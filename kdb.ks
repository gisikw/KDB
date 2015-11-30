@LAZYGLOBAL off.

// Make a lex, so we can get the quote character
local l is lexicon().
set l["0"] to 0.
local quote is l:dump:split("")[24].

// +------------------------------------------------------------+
// | Type Inference                                             |
// +------------------------------------------------------------+

local complexTypes is list("LEXICON","QUEUE","STACK","LIST","SHIP","VECTOR","DIRECTION","GEOCOORDINATES","ORBIT","ORBITABLE","ORBITALVELOCITY","BODY","ATMOSPHERE","CONTROL","MANEUVERNODE","ENGINE","AGGREGATERESOURCE","DOCKINGPORT","STAGE","PART","PARTMODULE","SENSOR","VESSELSENSORS","LOADDISTANCE","CONFIG","FILEINFO","HIGHLIGHT","ITERATOR","KUNIVERSE","TERMINAL","CORE","PIDLOOP","STEERINGMANAGER").

function get_type {
  parameter input.

  // Putting the input in a lexicon lets us get a description of its type,
  // unless it's a string or number.
  local l is lexicon().
  set l[0] to input.
  local complexType is l:dump:split(" ")[6]:split("(")[0]. ")".

  if complexTypes:contains(complexType) return complexType.

  // Determine string or num: 5+0+""="5"; "5"+0+"" = "50"
  if (input+""):LENGTH = (input+0+""):LENGTH return "NUMBER".
  return "STRING".
}

// +------------------------------------------------------------+
// | Loggable String Generation                                 |
// +------------------------------------------------------------+

function make_loggable {
  parameter target.
  parameter item.

  // Easy cases
  if get_type(item) = "STRING" return "set "+target+" to "+quote+item+quote+". ".
  if get_type(item) = "NUMBER" return "set "+target+" to "+item+". ".

  // Lists
  if get_type(item) = "LIST" {

    // Initialize empty list
    local s is "set "+target+" to list(".
    for i in item { set s to s + "0,". }
    set s to s:substring(0,s:length-1) + "). ".

    // Set list fill instructions
    // (avoiding list(el, el) and list:add for nesting reasons)
    from { local i is 0. } until i > item:length-1 step { set i to i+1. } do {
      set s to s + make_loggable(target+"["+i+"]", item[i]).
    }

    return s.
  }

  // Lexicons
  if get_type(item) = "LEXICON" {

    // Initialize lexicon
    local s is "set "+target+" to lexicon(). ".

    for key in item:keys {
      if get_type(key) = "STRING" local index is quote+key+quote.
      else local index is key.
      set s to s + make_loggable(target+"["+index+"]", item[key]).
    }

    return s.
  }

  // Queues
  if get_type(item) = "QUEUE" {

    // Initialize queue
    local s is "set "+target+" to queue(). ".

    for el in item {
      set s to s + make_loggable("_log_tmp", el)+target+":push(_log_tmp). ".
    }

    return s.
  }

  // Stacks
  if get_type(item) = "STACK" {

    // Initialize stack
    local s is "".

    for el in item {
      set s to make_loggable("_log_tmp", el)+target+":push(_log_tmp). " + s.
    }

    return "set "+target+" to stack(). " + s.
  }

  // Fail for non-persistable structs
  return "".
}

// +------------------------------------------------------------+
// | KDB Save and Load Functions                                |
// +------------------------------------------------------------+

function kdb_save {
  parameter db.
  parameter item.

  log "" to db+".kdb".
  delete db+".kdb".

  log make_loggable("kdbData", item) to db+".kdb".
}

function kdb_load {
  parameter db.

  rename db+".kdb" to "kdb_load.ks".
  run kdb_load.ks.
  rename "kdb_load.ks" to db+".kdb".

  return kdbData.
}
