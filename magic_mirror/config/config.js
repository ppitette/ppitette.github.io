/* 
 * Magic Mirror Config
 */

var config = {
	address: "localhost",
	port: 8080,
	basePath: "/",
	ipWhitelist: ["127.0.0.1", "::ffff:127.0.0.1", "::1"],
	useHttps: false,
	httpsPrivateKey: "",
	httpsCertificate: "",
	language: "fr",
	logLevel: ["INFO", "LOG", "WARN", "ERROR"],
	timeFormat: 24,
	units: "metric",
	modules: [
		{
			module: "alert",
			welcome_message: "Bonjour"
		},
		{
			module: "updatenotification",
			position: "top_bar"
		},
		{
			module: "clock",
			position: "top_left",
			config: {
				showWeek: true,
				dateFormat: "dddd Do MMMM YYYY",
				displayType: "digital",
				timezone: "Europe/Paris"
			}
		},
		{
			module: "currentweather",
			position: "top_right",
			config: {
				location: "Gravigny",
				locationID: "3014795",
				appid: "f58d6954b8402901c0ffab5378af902a",
				degreeLabel: true,
				showHumidity: true,
				decimalSymbol: ","
			}
		},
		{
			module: "weatherforecast",
			position: "top_right",
			header: "Prévisions météo",
			config: {
				location: "Gravigny",
				locationID: "3014795",
				appid: "f58d6954b8402901c0ffab5378af902a"
			}
		},
		{
			module: "newsfeed",
			position: "bottom_bar",
			config: {
				feeds: [
					{
						title: "Actualités",
						url: "https://www.francetvinfo.fr/titres.rss"
					},
				],
				showSourceTitle: true,
				showPublishDate: true
			}
		},
	]
};

/*************** DO NOT EDIT THE LINE BELOW ***************/
if (typeof module !== "undefined") {module.exports = config;}
