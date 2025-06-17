// Original Code written by Ne_Eo (Only crediting him for the help on the original script, most of the code is written directly by me)

// Class Structure written by ItsLJcool

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

    // This contains *normalized points to draw the outline around the character,
    public var poses:Array<FlxPoint> = [];

    // The character we are generating the outline for
    public var char:FlxSprite;

    // The offset / size of the outline
    public var offset:Float = 2;

    // This will be the number of sprites drawn behind the character. Higher = More Quality | Lower = Less Quality
    public var total:Int = 4;

    // YOUR    COLOR
    public var color:FlxColor = FlxColor.RED;

    // eh, I tried supporting alpha, but it currently sucks :sob:
    public var alpha:Float = 1;
    public var visible:Bool = true;

    public var indexCharLayer:Int = 0;

    public function new(char:FlxSprite, ?color:FlxColor, ?offset:Float = 2, ?total:Int = 4, ?aboveChar:Bool = false) {
        this.char = char;

        if (color != null) this.color = color;
        if (offset != null) this.offset = offset;
        if (total != null) this.total = total;
        if (aboveChar != null) this.indexCharLayer = aboveChar ? 0 : 1;

        regenOutline();
    }

    public function draw() {
        if (!this.visible) return char.draw();

        var char = this.char;

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
        // might as well lol
        if (FlxG.state == null) return;

        var charIndex = FlxG.state.members.indexOf(this.char);
        var objIndex = FlxG.state.members.indexOf(this);

        // Check if this object is below the character we are outlineing
        // We do this because of the way draw calls are handled, so if you want to make the outline above, use the variable to invert where it is overlayed
        if (objIndex < 0 || charIndex < 0) return;
        if (!(objIndex != (charIndex - 1) + this.indexCharLayer)) return;
        
        FlxG.state.members.remove(this, true);
        FlxG.state.members.insert(charIndex + this.indexCharLayer, this);
    }

    public function destroy() {
        for (point in this.poses) point.put();
    }

}