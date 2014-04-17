/*
Copyright (c) 2008 Tink Ltd - http://www.tink.ws

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
documentation files (the "Software"), to deal in the Software without restriction, including without limitation 
the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and
to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions
of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO 
THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, 
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
*/

package com.ws.tink.core
{
	
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	import flash.utils.describeType;
	
	import com.ws.tink.events.LibraryEvent;
	
	[Event(name="progress", type="flash.events.ProgressEvent")]
	[Event(name="embedComplete", type="ws.tink.events.LibraryEvent")]
	[Event(name="loadComplete", type="ws.tink.events.LibraryEvent")]
	
	public class Library extends EventDispatcher
	{
		
		private var _enterFrameDispatcher		: Sprite;
		
		private var _embeddedLoaders			: Array;
		private var _runtimeLoaders				: Array;
		
		private var _embeddedComplete			: Boolean;
		private var _runtimeCompletes			: Array;
		private var _runtimeComplete			: Boolean;
		
		private var _name						: String;
		
		private var _bytesLoaded				: Number = 0;
		private var _bytesTotal					: Number = 0;
		
		
		public function Library( name:String )
		{
			super();
			
			_name = name;
			initialize();
		}
		
		public function get name():String
		{
			return _name;
		}
		
		public function get bytesLoaded():Number
		{
			return _bytesLoaded;
		}
		
		public function get bytesTotal():Number
		{
			return _bytesTotal;
		}
		
		public function get complete():Boolean
		{
			return _embeddedComplete && _runtimeComplete;
		}
		
		public function get embeddedComplete():Boolean
		{
			return _embeddedComplete;
		}
		
		public function get runtimeComplete():Boolean
		{
			return _runtimeComplete;
		}
		
		public function loadSWF( url:String ):void
		{
			var loader:Loader = new Loader();	
			loader.contentLoaderInfo.addEventListener( ProgressEvent.PROGRESS, onLoaderProgress, false, 0, true );
			loader.contentLoaderInfo.addEventListener( Event.COMPLETE, onLoaderComplete, false, 0, true );
			loader.load( new URLRequest( url ) );
			_runtimeLoaders.push( loader );
			_runtimeCompletes.push( false );
		}
		
		public function embedSWF( ClassName:Class ):void
		{
			var loader:Loader = new Loader();
			loader.loadBytes( new ClassName() as ByteArray );
			
			_embeddedLoaders.push( loader );
		}
		
		public function loadSWFS( ...urls ):void
		{
			_runtimeComplete = false;
			
			var num:int = urls.length;
			for( var i:int = 0; i < num; i++ )
			{
				loadSWF( urls[ i ] as String );
			}
		}
		
		public function embedSWFS( ...classes ):void
		{
			if( _enterFrameDispatcher.hasEventListener( Event.ENTER_FRAME ) ) _enterFrameDispatcher.removeEventListener( Event.ENTER_FRAME, onEnterFrame );
			
			_embeddedComplete = false;
			
			var loader:Loader;
			var SWF:Class;
			var num:Number = classes.length;
			for( var i:int = 0; i < num; i++ )
			{
				SWF = Class( classes[ i ] );
				loader = new Loader();
				loader.loadBytes( new SWF() as ByteArray );
				
				_embeddedLoaders.push( loader );
			}
			
			_enterFrameDispatcher.addEventListener( Event.ENTER_FRAME, onEnterFrame, false, 0, true );
		}
		
		public function getDefinition( className:String ):Class
		{
			var loader:Loader;
			var numLoaders:int;
			var i:int;
			
			numLoaders = _embeddedLoaders.length;
			for( i = 0; i < numLoaders; i++ )
			{
				loader = Loader( _embeddedLoaders[ i ] );
				if( loader.contentLoaderInfo.applicationDomain.hasDefinition( className ) )
				{
					return loader.contentLoaderInfo.applicationDomain.getDefinition( className ) as Class;
				}
			}
			
			numLoaders = _runtimeLoaders.length;
			for( i = 0; i < numLoaders; i++ )
			{
				
				loader = Loader( _runtimeLoaders[ i ] );
				if( loader.contentLoaderInfo.applicationDomain.hasDefinition( className ) )
				{
					return loader.contentLoaderInfo.applicationDomain.getDefinition( className ) as Class;
				}
			}
			
			throw new ReferenceError( "ReferenceError: Error #1065: Variable " + className + " is not defined." );
		}
		
		public function contains( className:String ):Boolean
		{
			var loader:Loader;
			var numLoaders:Number = _embeddedLoaders.length;
			for( var i:int = 0; i < numLoaders; i++ )
			{
				loader = Loader( _embeddedLoaders[ i ] );
				if( loader.contentLoaderInfo.applicationDomain.hasDefinition( className ) )
				{
					return true;
				}
			}
			
			return false;
		}
		
		public function reset():void
		{
			destroy();
			initialize();
		}
		
		public function destroy():void
		{
			if( _enterFrameDispatcher.hasEventListener( Event.ENTER_FRAME ) ) _enterFrameDispatcher.removeEventListener( Event.ENTER_FRAME, onEnterFrame );
			
			var loader:Loader;
			var numLoaders:int
			var i:int;
			
			numLoaders = _runtimeLoaders.length;
			for( i = 0; i < numLoaders; i++ )
			{
				loader = Loader( _runtimeLoaders[ i ] );
				if( !_runtimeCompletes[ i ] )
				{
					loader.contentLoaderInfo.removeEventListener( ProgressEvent.PROGRESS, onLoaderProgress );
					loader.contentLoaderInfo.removeEventListener( Event.COMPLETE, onLoaderComplete );
					loader.close();
				}
				else
				{
					loader.unload();
				}
			}
			
			numLoaders = _embeddedLoaders.length;
			for( i = 0; i < numLoaders; i++ )
			{
				loader = Loader( _embeddedLoaders[ i ] );
				loader.unload();
			}
			
			_embeddedLoaders 		= null;
			_runtimeLoaders 		= null;
			_runtimeCompletes 		= null;
			
			_enterFrameDispatcher 	= null;
			
			_name					= null;
			
			_bytesLoaded			= undefined;
			_bytesTotal				= undefined;
		}
		
		private function initialize():void
		{
			_embeddedLoaders = new Array();
			_runtimeLoaders = new Array();
			_runtimeCompletes = new Array();
			
			_enterFrameDispatcher = new Sprite();
			
			_bytesLoaded = 0;
			_bytesTotal = 0;
		}
		
		private function onEnterFrame( event:Event ):void
		{
			_enterFrameDispatcher.removeEventListener( Event.ENTER_FRAME, onEnterFrame );
			
			_embeddedComplete = true;
			
			dispatchEvent( new LibraryEvent( LibraryEvent.EMBED_COMPLETE, false, false ) );
		}
		
		private function onLoaderProgress( event:ProgressEvent ):void
		{
			checkLoadersProgress();
		}
		
		private function onLoaderComplete( event:Event ):void
		{
			var loader:Loader = Loader( event.target.loader );
			loader.contentLoaderInfo.removeEventListener( ProgressEvent.PROGRESS, onLoaderProgress );
			loader.contentLoaderInfo.removeEventListener( Event.COMPLETE, onLoaderComplete );
			
			var numLoaders:int = _runtimeLoaders.length;
			for( var i:int = 0; i < numLoaders; i++ )
			{
				if( loader == Loader( _runtimeLoaders[ i ] ) )
				{
					_runtimeCompletes[ i ] = true;
					break;
				}
			}
			
			checkLoadersProgress( true );
		}
		
		private function checkLoadersProgress( complete:Boolean = false ):void
		{
			var bytesTotal:Number = 0;
			var bytesLoaded:Number = 0;
			var loader:Loader;
			
			var complete:Boolean = true;
			var numLoaders:int = _runtimeLoaders.length;
			for( var i:int = 0; i < numLoaders; i++ )
			{
				loader = Loader( _runtimeLoaders[ i ] );
				bytesTotal += loader.contentLoaderInfo.bytesTotal;
				bytesLoaded += loader.contentLoaderInfo.bytesLoaded;
				
				if( !_runtimeCompletes[ i ] ) complete = false;
			}			
			
			_bytesLoaded = bytesLoaded;
			_bytesTotal = bytesTotal;
			
			if( complete )
			{
				_runtimeComplete = true;
				dispatchEvent( new LibraryEvent( LibraryEvent.LOAD_COMPLETE, false, false ) );
			}
			else
			{
				dispatchEvent( new ProgressEvent( ProgressEvent.PROGRESS, false, false, bytesLoaded, bytesTotal ) );
			}
		}
		
	}
}