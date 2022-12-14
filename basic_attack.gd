extends "battle_action.gd"

var msg:String = "";
var max_damage:float = 0;
var inpresicion:float = 10;
var type:String = "regular_blunt";

const default_attack_message = "{actor} attacked {target}"

func _init(actor, target, damage:float, 
	dmg_type:String = "regular_blunt", 
	message:String = default_attack_message).(actor, target):
		max_damage = damage;
		self.type = dmg_type;
		msg = message.format({
			"actor": actor.name,
			"target": target.name,
		});

const BattleAction = preload("battle_action.gd");

func execute():
	actor.get_tree().current_scene.write_text(msg);
	yield(target.inflict_health(
		clamp(round(-rand_range(max_damage-inpresicion, max_damage)), -INF, 0),
		{
			"actor": actor,
			"type": type
		}
	), "completed");
	
	if target.shouldfaint() && !target.has_method("__wait_for_faint"):
		yield(target.faint(), "completed");



static func get_alignemnt():
	return BattleAction.TargetAlignment.Attack;
	
static func get_target_type():
	return BattleAction.TargetType.TargetActor;
