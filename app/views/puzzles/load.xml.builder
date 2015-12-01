xml.instruct!
xml.save {
  xml.header {
    xml.time("firstSave" => @puzzle_save.first_save, "lastSave" => @puzzle_save.last_save, "total" => @puzzle_save.total)
    xml.flags("solved" => @puzzle_save.solved)
    xml.code("familyRef" => @puzzle_save.family_ref, "variantRef" => @puzzle_save.variant_ref, "memberRef" => @puzzle_save.member_ref, "serial" => @puzzle_save.serial)
  }
  xml.data {
    xml << @puzzle_save.data
  }
}
