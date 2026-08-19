class_name References

static var ITEMS : Dictionary[Enums.Items, Item] = {
	Enums.Items.SWORD : load("uid://d3ru8alwc0xq4"),
	Enums.Items.SHIELD : load("uid://2bigvwyq8532"),
	Enums.Items.HEALTH_POTION : load("uid://dxab75s7flvdm"),
	Enums.Items.FIREBALL_SPELLBOOK : load("uid://bishitcpv23v7"),
	Enums.Items.MANA_POTION : load("uid://yqmj5n8bqsw1"),
	Enums.Items.KINGS_SWORD : load("uid://ckooecd18v48w"),
	Enums.Items.DIAMOND_RING : load("uid://d024j5vnfrxwp"),
	Enums.Items.SCYTHE : load("uid://c663qq1cu06ex"),
	Enums.Items.LIGHTNING_SPELLBOOK : load("uid://c4xxr1vwy752c")
}

static var SHADERS : Dictionary[Enums.Shaders, ShaderMaterial] = {
	Enums.Shaders.HIT_FLASH : load("uid://71q2ybnathvi")
}

static var HIT_EFFECTS : Dictionary[Enums.HitEffects, HitEffect] = {
	Enums.HitEffects.SWORD_HIT : load("uid://bqldixtkqm6mc"),
	Enums.HitEffects.PARRY_HIT : load("uid://nibp8vnkg3a4"),
	Enums.HitEffects.FIREBALL_HIT : load("uid://c76mpr6qcesih"),
	Enums.HitEffects.LIGHTNING_HIT : load("uid://cliwp7asev28y")
}

static var PARTICLES : Dictionary[Enums.Particles, PackedScene] = {
	Enums.Particles.SWORD_HIT : load("uid://c7bwdxi6ra7ah"),
	Enums.Particles.FIREBALL_HIT : load("uid://d2i6fc0p8dsto"),
	Enums.Particles.LIGHTNING_HIT : load("uid://guv1dj52y2nd")
}

static var ENEMIES : Dictionary[Enums.Enemies, PackedScene] = {
	Enums.Enemies.KNIGHT : load("uid://cek561y3ub7kl"),
	Enums.Enemies.MAGE : load("uid://rqrdh44d37if")
}

static var PROJECTILES : Dictionary[Enums.Projectiles, PackedScene] = {
	Enums.Projectiles.FIREBALL : load("uid://duq2ati8kjp6d"),
	Enums.Projectiles.LIGHTNING : load("uid://c83m0qmia7fc5")
}
