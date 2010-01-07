package
{
	import com.logosware.event.QRreaderEvent;
	import com.logosware.utils.QRcode.GetQRimage;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.external.ExternalInterface;
	import flash.filters.ColorMatrixFilter;
	import flash.media.Camera;
	import flash.media.Video;
	import flash.utils.Timer;
	
	public class Qrread extends Sprite
	{
		private var qrImage:GetQRimage;
		private var camera:Camera;
		private var cameraView:Sprite;
		private var video:Video = new Video(SRC_SIZE, SRC_SIZE);
		private var cameraTimer:Timer = new Timer(2000);
		private var redBorder:Sprite = new Sprite();
		private var container:Sprite = new Sprite();;
		private const SRC_SIZE:int = 320;
		
		public function Qrread()
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			cameraTimer.addEventListener(TimerEvent.TIMER, getCamera);
			cameraTimer.start();
			getCamera();
		}
		
		private function getCamera(e:TimerEvent = null): void
		{
			camera = Camera.getCamera();
			if(camera != null)
			{
				cameraTimer.stop();
				start();
			}
		}
		
		private function start(): void
		{
			cameraView = buildCameraView();
			qrImage = new GetQRimage(video);
			qrImage.addEventListener(QRreaderEvent.QR_IMAGE_READ_COMPLETE, qrImageReadCompleteHandler);
			addEventListener(Event.ENTER_FRAME, enterFrameHandler);
			container.addChild(cameraView);
			addChild(container);
		}
		
		private function buildCameraView(): Sprite
		{
			camera.setQuality(0, 100);
			camera.setMode(SRC_SIZE, SRC_SIZE, 24, true );
			video.attachCamera( camera );
			video.smoothing = true;
			redBorder.graphics.lineStyle(2, 0xFF0000);
			redBorder.graphics.drawPath(Vector.<int>([1,2,2,1,2,2,1,2,2,1,2,2]), Vector.<Number>([30,60,30,30,60,30,290,60,290,30,260,30,30,260,30,290,60,290,290,260,290,290,260,290]));
			var view:Sprite = new Sprite();
			var holder:Sprite = new Sprite();
			holder.addChild(video);
			view.addChild(holder);
			view.addChild(redBorder);
			return view;
		}
		
		private function getVideoFilters(): Array
		{
			var m:Array = [-1,0,0,0,255,0,-1,0,0,255,0,0,-1,0,255,0,0,0,1,0];
			var f:ColorMatrixFilter = new ColorMatrixFilter(m);
			return [f];	
		}
		
		private function enterFrameHandler(e:Event): void
		{
			if(camera.currentFPS > 0)
			{
				qrImage.process();
			}
		}
		
		private function qrImageReadCompleteHandler(e:QRreaderEvent): void
		{
			var result:Array = e.data;
			if(ExternalInterface.available)
			{
				ExternalInterface.call("decode", result);			
			}
		}
		
	}
	
}