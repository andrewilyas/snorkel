var express = require('express');
var bodyParser = require("body-parser");
var app = express();
var fs = require('fs');
var stream = fs.createWriteStream("net.lua");
var sys = require('sys')
var path    = require("path");
var exec = require('child_process').exec;
function puts(error, stdout, stderr) { console.log(error); console.log(stdout); console.log(stderr); }

app.use(bodyParser.urlencoded({ extended: false }));
app.use(bodyParser.json());
app.use("/", express.static(__dirname + '/snorkle'));

app.get('/', function(req, res) {
	res.sendFile(path.join(__dirname+'/snorkle/index.html'));
});

app.post('/classify_this', function (req, res) {
	console.log(req.body.image_url);
	exec("wget " + req.body.image_url + " -O test_data/1/image_to_test.png", function() {
		exec("th feed_one.lua | tail -3 | head -1", function(error, stdout, stderr) {
			 console.log(error); console.log(stdout); console.log(stderr); 
			res.send(stdout);
		});
	});
});

app.post('/train_model', function(req, res) {
	stream.write(req.body.message);
	exec("wget " + req.body.image_url + " -O zipped", function(error, stdout, stderr) {
		 console.log(error); console.log(stdout); console.log(stderr); 
		exec("unzip zipped", function(error, stdout, stderr) {
			exec("th main_graph.lua", function(error, stdout, stderr) {
				 console.log(error); console.log(stdout); console.log(stderr); 
				res.send("YO");
			});
		})
	});
});

app.listen(3000, function () {
  console.log('Example app listening on port 3000!');
});

app.on('connection', function(socket) {
  socket.setTimeout(3000 * 1000); 
  // 30 second timeout. Change this as you see fit.
});
