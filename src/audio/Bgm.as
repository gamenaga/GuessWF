package audio
{
	import flash.events.TimerEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.utils.Timer;
	
	import naga.system.EventManager;

    public class Bgm
    {
        public static var bgm:Sound = null;
        private static var bgm_class:Class;
        private static var re:Boolean = false;
        public static var bgmc:SoundChannel = new SoundChannel();
        private static var sound_tf:SoundTransform = new SoundTransform();
        public static var m_speed:SoundSpeed = new SoundSpeed();
        private static var sound_timer:Timer = new Timer(100);

        public static function play(mu:Class = null, vol:Number = 0.6) : void
        {
            if (bgm == null)
            {
                bgm = new mu;
                sound_tf.volume = vol;
                bgmc = bgm.play(0, int.MAX_VALUE, sound_tf);
            }
            else
            {
                bgm_class = mu;
                re = true;
                end();
            }
        }// end function

        public static function end() : void
        {
            if (bgm != null)
            {
//                sound_timer.addEventListener(TimerEvent.TIMER, out);
				EventManager.AddEventFn(sound_timer,TimerEvent.TIMER, out);
                sound_timer.start();
            }
        }// end function

        private static function out() : void
        {
            sound_tf.volume = sound_tf.volume - 0.1;
            bgmc.soundTransform = sound_tf;
            if (bgmc.soundTransform.volume <= 0)
            {
                sound_timer.stop();
//                sound_timer.removeEventListener(TimerEvent.TIMER, out);
				EventManager.delEventFn(sound_timer,TimerEvent.TIMER, out);
                bgmc.stop();
                bgm = null;
                if (re)
                {
                    bgm = new bgm_class();
                    bgmc = bgm.play();
                    sound_tf.volume = 1;
                    bgmc.soundTransform = sound_tf;
                    re = false;
                }
            }
        }// end function

    }
}
