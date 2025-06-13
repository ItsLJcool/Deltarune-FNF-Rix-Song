// Original Code written by Ne_Eo, and modified by ItsLJcool to conform to a Class Structure

import funkin.game.Character;
import funkin.system.FunkinSprite;
import openfl.geom.ColorTransform;
import Math;
import Reflect;

import funkin.backend.FunkinShader;
import openfl.display.BitmapData;

import flixel.FlxBasic;
import flixel.FlxSprite;

class SpriteOutline extends FlxBasic {

    public var poses:Array<FlxPoint> = [];

    public var char:Character;

    public var offset:Float = 2;
    public var total:Int = 4;

    public var color:FlxColor = 0xff0000;

    public var alpha:Float = 1;
    public var visible:Bool = true;

    public function new(char:Character, ?color:FlxColor, ?offset:Float = 2, ?total:Int = 4) {
        this.char = char;
        char.exists = false;

        if (color != null) this.color = color;
        if (offset != null) this.offset = offset;
        if (total != null) this.total = total;

        regenOutline();
    }

    public function draw() {
        if (!this.visible) return char.draw();

        var char = this.char;

        var oldShader = char.shader;

        var oldColor = char.colorTransform;

        var outlineCT = new ColorTransform();
        outlineCT.color = this.color;
        outlineCT.alphaMultiplier = this.alpha;

        char.colorTransform = outlineCT;

        for (point in this.poses) {
            var x = point.x * this.offset;
            var y = point.y * this.offset;
            char.x += x; char.y += y;
            char.draw();
            char.x -= x; char.y -= y;
        }
        char.colorTransform = oldColor;
        char.draw();
    }

    public function regenOutline() {
        var angleOff = 360 / this.total;

        var TO_RAD = Math.PI / 180;

        for (point in this.poses) point.put();
        this.poses = [];
        for (i in 0...total) {
            var point = FlxPoint.get(0, 0);
            var angle = angleOff * i * TO_RAD;
            point.x = Math.sin(angle);
            point.y = Math.cos(angle);
            this.poses.push(point);
        }
    }

    public function update(elapsed) {
        var char = this.char;
        if (this.exists && !char.exists) char.update(elapsed);
    }

    public function destroy() {
        for (point in this.poses) point.put();
    }

}