package audio
{
    import flash.events.*;
    import flash.media.*;
    import flash.utils.*;

    public class SoundSpeed extends Object
    {
        private var sound:Sound;
        private var samplesData:ByteArray;
        private var position:Number;
        private var buffer:int;
        private var speed:Number;
        private var bgmc:SoundChannel;

        public function SoundSpeed()
        {
            this.bgmc = new SoundChannel();
            this.buffer = 2048;
            this.position = 0;
            this.speed = 1;
        }// end function

        public function getExtractSound(param1:Sound) : void
        {
            this.position = 0;
            if (this.samplesData)
            {
                this.samplesData.clear();
            }
            this.samplesData = new ByteArray();
            param1.extract(this.samplesData, 99999999);
            this.sound = new Sound();
            this.clear();
            this.sound.addEventListener(SampleDataEvent.SAMPLE_DATA, this.sampleDataHandler);
        }// end function

        public function clear() : void
        {
            if (this.sound && this.sound.hasEventListener(SampleDataEvent.SAMPLE_DATA))
            {
                this.sound.removeEventListener(SampleDataEvent.SAMPLE_DATA, this.sampleDataHandler);
            }
        }// end function

        public function play() : void
        {
            this.bgmc = this.sound.play();
            this.bgmc.addEventListener(Event.SOUND_COMPLETE, this.replay);
        }// end function

        private function replay(event:Event) : void
        {
            this.sound.play();
        }// end function

        private function sampleDataHandler(event:SampleDataEvent) : void
        {
            var _loc_2:int = 0;
            var _loc_3:int = 0;
            var _loc_4:Number = NaN;
            var _loc_5:Number = NaN;
            _loc_2 = 0;
            while (_loc_2++ < this.buffer)
            {
                
                _loc_3 = int(this.position);
                this.samplesData.position = _loc_3 * 8;
                _loc_4 = this.samplesData.readFloat();
                _loc_5 = this.samplesData.readFloat();
                event.data.writeFloat(_loc_4);
                event.data.writeFloat(_loc_5);
                this.position = this.position + this.speed;
            }
        }// end function

        public function set playSpeed(param1:Number) : void
        {
            this.speed = Math.max(0, param1);
        }// end function

    }
}
