module StaticData
  Cuisines              = IO.read(File.join(Rails.root,'db','lists','cuisines.txt')).lines.to_a.map(&:strip).sort
  InventoryTags         = IO.read(File.join(Rails.root,'db','lists','inventory_tags.txt')).lines.to_a.map(&:strip).sort
  DietaryRestrictions   = IO.read(File.join(Rails.root,'db','lists','dietary_restrictions.txt')).lines.to_a.map(&:strip).sort
end