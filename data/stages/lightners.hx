// a
import SpriteOutline;

var croudGuys:FunkinSprite;
var krisHeart:FlxSprite;

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
}

var coolTween:FlxTween;
function beatHit(curBeat) {
	switch (curBeat) {
		case 16: stageBg.animation.play('lightsOn');
		case 20: stageBg.animation.play('spotlight-lightsOn');
		case 22: FlxTween.tween(croudGuys, {y: croudGuys.y - 250}, 2, {ease: FlxEase.quintOut});
		case 32:
			FlxTween.cancelTweensOf(croudGuys);
			croudGuys.setPosition(stageBg.x + (stageBg.width - croudGuys.width) * 0.5, (stageBg.y + stageBg.height * 0.5) - 15);
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

function stepHit(curStep) {
	switch (curStep) {
		case 67: stageBg.animation.play('lightsOff');
		case 68: stageBg.animation.play('lightsOn');
	}
}

function krisSolo() {
	var val = 0.35;
	var time = (Conductor.crochet * 0.001) * 14;

	FlxTween.tween(krisHeart, {alpha: 1}, time*0.8, {ease: FlxEase.linear});
	FlxTween.tween(bfOutline, {alpha: 1}, time, {ease: FlxEase.linear});

	var _members = members.copy();
	_members.remove(krisHeart);
	for (obj in _members) {
		if (obj == null || obj.camera != camGame) continue;
		if (obj.colorTransform == null) continue;

		FlxTween.tween(obj.colorTransform, {redMultiplier: 0.2, greenMultiplier: 0.2, blueMultiplier: 0.2}, time*0.9, {ease: FlxEase.linear});
	}
}

function onPlayerHit(e) {
	var _amt = 2;
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