package classes
{
	public class GlobalConstants
	{
		public static const DEVICE_TYPE:String = "PHONE";				//WEB, TABLET, PHONE
		
		public static const DEFAULT_LANGUAGE:String = "sv";			//svenska	//en=engelska
		public static const DEFAULT_CURRENCY:int = 124;				//=Svensk krona
        public static const DRUPAL_INTEGRATION:Boolean = true;
		
		/* DEMO */
		/*public static const APP_URL:String = "http://demo.vintigo.se/";
		public static const DRUPAL_PATH:String = "http://php-demo.vintigo.se/smorgasbord/";
		public static const PRODUCTIONSERVER:Boolean = false;	
		public static const PYSERVICE_URL:String = "http://python-demo.vintigo.se/amf";
		public static const STATIC_URL:String = "http://php-demo.vintigo.se/sites/php-demo.vintigo.se/files/";*/
		 
		/* PRODUCTION PETIT*/
//		public static const APP_URL:String = "www.petiit.se";
		public static const DRUPAL_PATH:String = "http://php.petiit.se/petit/";//	"http://petiit.dyndns.dk/petit/";	//https
		public static const PRODUCTIONSERVER:Boolean = true;
		public static const STATIC_URL:String = "http://php.petiit.se/sites/php.petiit.se/files/";		//	"http://petiit.dyndns.dk/sites/petiit.dyndns.dk/files/"
		public static const XML_URL:String = "http://php.petiit.se/xml/"; // "http://petiit.dyndns.dk/xml/";
		public static const AMAZON_URL:String = "http://petit-prod0.s3.amazonaws.com/";

		/* DEVELOP */
        /*public static const APP_URL:String = "www.petiit.se";
        public static const DRUPAL_PATH:String = "http://10.0.10.16/~ottob/petit/petit/";
        public static const PRODUCTIONSERVER:Boolean = false;
        public static const STATIC_URL:String = "http://10.0.10.16/~ottob/petit/sites/petit/files/";		//	"http://petiit.dyndns.dk/sites/petiit.dyndns.dk/files/"
        public static const XML_URL:String = "http://10.0.10.16/~ottob/petit/sites/petit/files/xml/"; // "http://petiit.dyndns.dk/xml/";
        public static const AMAZON_URL:String = "http://petit-dev0.s3.amazonaws.com/";*/
	}
}