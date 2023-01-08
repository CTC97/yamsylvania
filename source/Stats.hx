package;

import flixel.util.FlxSave;

class Stats
{
    private static var _gameSave:FlxSave;

    public static function readStats() {
        _gameSave = new FlxSave(); // initialize
        _gameSave.bind("highscoresave"); // bind to the named save slot
        if(_gameSave.data.delivered == null) {
            trace("null, creating");
            _gameSave.data.delivered = 0;
            _gameSave.data.killed = 0;
        }
    }

    public static function writeStats(delivered:Int, killed:Int) {
        _gameSave.data.delivered = _gameSave.data.delivered + delivered;
        _gameSave.data.killed = _gameSave.data.killed + killed;
        _gameSave.flush();
    }

    public static function reset() {
        _gameSave.data.delivered = 0;
         _gameSave.data.killed = 0;
    }

    public static function getSave():FlxSave {
        return _gameSave;
    }
}
