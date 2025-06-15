// a
import SpriteOutline;
import funkin.editors.charter.Charter;

import openfl.filters.BitmapFilter;
import openfl.filters.GlowFilter;
import flixel.graphics.frames.FlxFilterFrames;

var croudGuys:FunkinSprite;
var krisHeart:FlxSprite;

var clickSfx = FlxG.sound.load(Paths.sound('clickSfx'));
clickSfx.volume = 0;
clickSfx.play();
clickSfx.onComplete = () -> { clickSfx.volume = 0.7; clickSfx.onComplete = null; };

introLength = 0;
function create() {
	stageBg.antialiasing = false;
}

var bfOutline:SpriteOutline;
function postCreate() {
	 
	insert(members.indexOf(boyfriend), bfOutline = new SpriteOutline(boyfriend));
	bfOutline.alpha = 0;

	krisHeart = new FlxSprite().loadGraphic(Paths.image('stages/lightners/heart'));
	krisHeart.antialiasing = false;
	krisHeart.alpha = 0;
	add(krisHeart);

	dad.addAnim("idle", "idle", (93 / (60 / Conductor.bpm))/4, true);
	dad.playAnim("idle", true);

	for (obj in [healthBar, healthBarBG]) obj.visible = false;
	for (icon in iconArray) icon.visible = false;

	croudGuys = new FunkinSprite();
	croudGuys.antialiasing = false;
	croudGuys.loadSprite(Paths.image('stages/lightners/crowd'));
	croudGuys.setGraphicSize(croudGuys.width * 2);
	croudGuys.updateHitbox();
	croudGuys.addAnim("idle", "idle", 8, true);
	croudGuys.playAnim("idle", true);
	croudGuys.setPosition(stageBg.x + (stageBg.width - croudGuys.width) * 0.5, (stageBg.y + stageBg.height * 0.5) - 15);
	croudGuys.onDraw = (spr) -> {
		var prevPos = {x: spr.x, y: spr.y};
		spr.draw();

		spr.x += spr.width - 25;
		spr.draw();

		spr.x = prevPos.x;

		spr.x -= spr.width + 25;
		spr.draw();
		spr.x = prevPos.x;
	}
	croudGuys.y += 250;
	add(croudGuys);

	
	if (!Charter.startHere) {
		var _members = members.copy();
		var tweenTime = (Conductor.crochet * 0.001)*16;
		for (obj in _members) {
			if (obj == null || obj.camera != camGame) continue;
			if (obj.colorTransform == null) continue;
			obj.colorTransform.redMultiplier = obj.colorTransform.greenMultiplier = obj.colorTransform.blueMultiplier = 0.001;
			FlxTween.tween(obj.colorTransform, {redMultiplier: 1, greenMultiplier: 1, blueMultiplier: 1}, tweenTime);
		}
		
		for (strum in player) strum.y = -200;
	}

}

function createFilterFrames(sprite:FlxSprite, filter:BitmapFilter) {
	var filterFrames = FlxFilterFrames.fromFrames(sprite.frames, SIZE_INCREASE, SIZE_INCREASE, [filter]);
	updateFilter(sprite, filterFrames);
	return filterFrames;
}

var coolTween:FlxTween;
function beatHit(curBeat) {
	switch (curBeat) {
		case 16:
			stageBg.animation.play('lightsOn');
			clickSfx.play(true);
			
			if (!Charter.startHere) for (strum in player) FlxTween.tween(strum, {y: 50}, (Conductor.crochet * 0.001)*4, {ease: FlxEase.quadOut});
		case 20:
			stageBg.animation.play('spotlight-lightsOn');
			clickSfx.play(true);
		case 22: FlxTween.tween(croudGuys, {y: croudGuys.y - 250}, 2, {ease: FlxEase.quintOut});
	}

	if (curBeat >= 32) {
		croudGuys.setPosition(stageBg.x + (stageBg.width - croudGuys.width) * 0.5, (stageBg.y + stageBg.height * 0.5) - 15);
		FlxTween.cancelTweensOf(croudGuys);
		FlxTween.tween(croudGuys, {y: croudGuys.y + 10}, Conductor.crochet * 0.001, {ease: FlxEase.quadOut});
	}

	bfOutline.offset = 2.5;
	coolTween?.cancel();
	coolTween = FlxTween.tween(bfOutline, {offset: 2}, Conductor.crochet * 0.001, {ease: FlxEase.quadOut});

	krisHeart.scale.set(1.15, 1.15);
}

function krisSolo() {
	var time = (Conductor.crochet * 0.001) * 14;

	FlxTween.tween(krisHeart, {alpha: 1}, time*0.8);
	FlxTween.tween(bfOutline, {alpha: 1}, time);

	theDarkening([krisHeart], (obj) -> {(return (obj == boyfriend) ? 0.5 : 0.2);}, time);
}

function weirdSfx() {
	var _members = members.copy();
	_members.remove(krisHeart);
	_members.remove(boyfriend);
	for (obj in _members) {
		if (obj == null || obj.camera != camGame) continue;
		if (obj.colorTransform == null) continue;
	
		obj.colorTransform.redMultiplier += 0.6;
		obj.colorTransform.greenMultiplier += 0.6;
		obj.colorTransform.blueMultiplier += 0.6;
	}
	
	var time = (Conductor.crochet * 0.001) * 3;
	theDarkening([krisHeart, boyfriend], null, time, true);
}

function theDarkening(remove:Array<Dynamic>, valueFunc:Void->Float, time:Float, ?forceCancelTweens:Bool = false) {
	valueFunc ??= (obj) -> return 0.2;
	forceCancelTweens ??= false;

	var _members = members.copy();
	for (item in remove) _members.remove(item);

	for (obj in _members) {
		if (obj == null || obj.camera != camGame) continue;
		if (obj.colorTransform == null) continue;
		
		var coolerValue = valueFunc(obj);

		if (forceCancelTweens) FlxTween.cancelTweensOf(obj);
		FlxTween.tween(obj.colorTransform, {redMultiplier: coolerValue, greenMultiplier: coolerValue, blueMultiplier: coolerValue}, time*0.9);
	}
}

function onPlayerHit(e) {
	var _amt = 2.5;
	switch(e.direction) {
		case 0: krisHeart.x -= _amt;
		case 1: krisHeart.y += _amt;
		case 2: krisHeart.y -= _amt;
		case 3: krisHeart.x += _amt;
	}
}

function update(elapsed) {
	krisHeart.scale.x = lerp(krisHeart.scale.x, 1, 0.15);
	krisHeart.scale.y = lerp(krisHeart.scale.y, 1, 0.15);

	krisHeart.x = lerp(krisHeart.x, (boyfriend.x + (boyfriend.width - krisHeart.width) * 0.5) + 6, 0.15);
	krisHeart.y = lerp(krisHeart.y, (boyfriend.y + (boyfriend.height - krisHeart.height) * 0.5) + 8, 0.15);
}