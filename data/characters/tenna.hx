//a
if (PlayState.instance == null || !(FlxG.state is PlayState)) return disableScript();

var scaleTween:FlxTween;

var _originalScale:Float;
var singScale = 1.125;
var nonSingScale = 0.9;
function postCreate() {
    _originalScale = FlxPoint.get(scale.x, scale.y);
}

function onPlaySingAnim(event) {
    squish(event.direction);
}

function squish(dir:Int) {
    scaleTween?.cancel();
    switch(dir % 4) {
        case 0, 3: scale.x *= singScale; scale.y *= nonSingScale;
        case 1, 2: scale.x *= nonSingScale; scale.y *= singScale;
    }
    scaleTween = FlxTween.tween(scale, {x: _originalScale.x, y: _originalScale.y}, (Conductor.crochet * 0.001)*0.9, {ease: FlxEase.expoOut});
}