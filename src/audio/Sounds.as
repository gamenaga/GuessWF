package audio
{
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;

    public class Sounds
    {
        private static var sdc:SoundChannel;
        private static var sd:Sound;

        public static function play(mu:Class = null, times:int = 0, vol:Number = 0.6) : void
        {
            sd = new mu;
//			trace("sounds 15:"+sd);
            sdc = sd.play(0, times, new SoundTransform(vol));
        }// end function

    }
}
