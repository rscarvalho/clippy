import flash.display.MovieClip;
import flash.events.MouseEvent;
import flash.display.SimpleButton;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;
import haxe.Firebug;
import haxe.Stack;

class Clippy {
    static function log(what:Dynamic) {
        Firebug.trace(what);
    }

    static function exceptionHandler(msg: String, stack: Array<String>) {
        log("Exception from Flash: " + msg);
        log("Stack Trace: ");
        for (i in 0...stack.length) {
            log("... " + stack[i]);
        }
    }

    // Main
    static function main() {
        // flash.Lib.setErrorHandler(exceptionHandler);

        var copyText:String = "copy to clipboard";
        var fontFamily:String = "Arial";
        var fontSize:Int = 10;
        var copiedText:String = "copy to clipboard";
        var text:String = null;

        var _params = flash.Lib.current.loaderInfo.parameters;
        var attrs: Array<String> = Reflect.fields(_params);

        for (i in 0...attrs.length)
        {
            var name = attrs[i];
            var value = Reflect.field(_params, name);

            if (name == "text")
                text = value;
            else if (name == "copyText")
                copyText = value;
            else if (name == "copiedText")
                copiedText = value;
            else if (name == "fontFamily")
                fontFamily = value;
            else if (name == "fontSize") {
                var n:Int = Std.parseInt(value);
                if (!Math.isNaN(n))
                    fontSize = n;
            }
        }

        // label

        var label:TextField = new TextField();
        var format:TextFormat = new TextFormat(fontFamily, fontSize);

        label.text = copyText;
        label.setTextFormat(format);
        label.textColor = 0x888888;
        label.selectable = false;
        label.x = 15;
        label.visible = false;

        flash.Lib.current.addChild(label);

        // button
        log("Button is being loaded!");
        var button:SimpleButton = new SimpleButton();
        try {
            button.useHandCursor = true;
            button.upState = new ButtonUp();
            button.overState = new ButtonOver();

            button.downState = new ButtonDown();
            button.hitTestState = new ButtonDown();
            button.visible = true;

            button.addEventListener(MouseEvent.MOUSE_UP, function(e:MouseEvent) {
                flash.system.System.setClipboard(text);
                label.text = copiedText;
                label.setTextFormat(format);
            });

            button.addEventListener(MouseEvent.MOUSE_OVER, function(e:MouseEvent) {
                label.visible = true;
            });

            button.addEventListener(MouseEvent.MOUSE_OUT, function(e:MouseEvent) {
                label.visible = false;
                label.text = copyText;
                label.setTextFormat(format);
            });
        } catch(e:Dynamic) {
            log(e);
            log(Stack.exceptionStack());
        }

        log("Button Loaded!");

        flash.Lib.current.addChild(button);
    }
}